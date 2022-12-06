import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/service/auth_service.dart';
import '../navigator.dart';

class _ViewModelState {
  final String? login;
  final String? password;
  final bool isLoading;
  final String? errorText;
  const _ViewModelState(
      {this.login, this.password, this.isLoading = false, this.errorText});

  _ViewModelState copyWith({
    String? login,
    String? password,
    bool? isLoading = false,
    String? errorText,
  }) {
    return _ViewModelState(
      login: login ?? this.login,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  _ViewModel({required this.context}) {
    loginTEC.addListener(() {
      state = state.copyWith(login: loginTEC.text);
    });
    passTEC.addListener(() {
      state = state.copyWith(password: passTEC.text);
    });
  }
  _ViewModelState _state = const _ViewModelState();

  TextEditingController loginTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();

  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  _ViewModelState get state => _state;

  bool checkFields() {
    return (state.password?.isNotEmpty ?? false) &&
        (state.login?.isNotEmpty ?? false);
  }

  void login() async {
    state = state.copyWith(isLoading: true);

    try {
      await _authService
          .auth(state.login, state.password)
          .then((value) => AppNavigator.toLoader());
    } on NoNetworkException {
      state = state.copyWith(errorText: "Cannot connect to server");
    } on WrongCredentionalException {
      state = state.copyWith(errorText: "Invalid login/password");
    }
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: viewModel.loginTEC,
                          decoration:
                              const InputDecoration(hintText: "Enter login"),
                        ),
                        TextFormField(
                          controller: viewModel.passTEC,
                          obscureText: true,
                          decoration:
                              const InputDecoration(hintText: "Enter password"),
                        ),
                        ElevatedButton(
                            onPressed: viewModel.checkFields()
                                ? viewModel.login
                                : null,
                            child: const Text("Log in")),
                        if (viewModel.state.isLoading)
                          const CircularProgressIndicator(),
                        if (viewModel.state.errorText != null)
                          Text(viewModel.state.errorText!),
                      ]),
                ))));
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: const AuthWidget());
}
