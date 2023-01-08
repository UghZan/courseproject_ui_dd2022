// ignore_for_file: depend_on_referenced_packages
import 'package:courseproject_ui_dd2022/domain/models/create_models/create_user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/service/auth_service.dart';
import '../../navigation/app_navigator.dart';

class _ViewModelState {
  final String? name;
  final String? email;
  final String? password;
  final String? retryPassword;
  final bool isLoading;
  final String? errorText;
  const _ViewModelState(
      {this.name,
      this.email,
      this.password,
      this.retryPassword,
      this.isLoading = false,
      this.errorText});

  _ViewModelState copyWith({
    String? name,
    String? email,
    String? password,
    String? retryPassword,
    bool? isLoading = false,
    String? errorText,
  }) {
    return _ViewModelState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      retryPassword: retryPassword ?? this.retryPassword,
      isLoading: isLoading ?? this.isLoading,
      errorText: errorText ?? this.errorText,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  BuildContext context;
  final _authService = AuthService();
  _ViewModel({required this.context}) {
    nameTEC.addListener(() {
      state = state.copyWith(name: nameTEC.text);
    });
    emailTEC.addListener(() {
      state = state.copyWith(email: emailTEC.text);
    });
    passTEC.addListener(() {
      state = state.copyWith(password: passTEC.text);
    });
    rPassTEC.addListener(() {
      state = state.copyWith(retryPassword: rPassTEC.text);
    });
  }
  _ViewModelState _state = const _ViewModelState();

  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();
  TextEditingController rPassTEC = TextEditingController();

  set state(_ViewModelState val) {
    _state = val;
    notifyListeners();
  }

  _ViewModelState get state => _state;

  bool checkFields() {
    return (state.password?.isNotEmpty ?? false) &&
        (state.email?.isNotEmpty ?? false) &&
        (state.retryPassword?.isNotEmpty ?? false) &&
        (state.name?.isNotEmpty ?? false);
  }

  void createUser() async {
    state = state.copyWith(isLoading: true);
    if (state.password != state.retryPassword) {
      state = state.copyWith(errorText: "Passwords don't match");
      return;
    }
    var newUser = CreateUserModel(
        name: state.name,
        email: state.email,
        password: state.password,
        retryPassword: state.retryPassword);
    try {
      var delay = const Duration(seconds: 3);
      _authService.createUser(newUser);
      state = state.copyWith(
          errorText:
              "User successfully created! You will be logged in shortly.");
      Future.delayed(delay).then((value) => _authService
          .auth(state.email, state.password)
          .then((value) => AppNavigator.toLoader()));
    } on NoNetworkException {
      state = state.copyWith(errorText: "Cannot connect to server");
    } on UserAlreadyExists {
      state = state.copyWith(
          errorText: "User with such credentials already exists");
    }
  }
}

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({Key? key}) : super(key: key);
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
                          controller: viewModel.nameTEC,
                          decoration: const InputDecoration(
                              hintText: "Enter your login"),
                        ),
                        TextFormField(
                          controller: viewModel.emailTEC,
                          decoration: const InputDecoration(
                              hintText: "Enter your e-mail"),
                        ),
                        TextFormField(
                          controller: viewModel.passTEC,
                          obscureText: true,
                          decoration:
                              const InputDecoration(hintText: "Enter password"),
                        ),
                        TextFormField(
                          controller: viewModel.rPassTEC,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: "Enter password again"),
                        ),
                        ElevatedButton(
                            onPressed: viewModel.checkFields()
                                ? viewModel.createUser
                                : null,
                            child: const Text("Register")),
                        if (viewModel.state.isLoading)
                          const CircularProgressIndicator(),
                        if (viewModel.state.errorText != null)
                          Text(viewModel.state.errorText!),
                      ]),
                ))));
  }

  static Widget create() => ChangeNotifierProvider<_ViewModel>(
      create: (context) => _ViewModel(context: context),
      child: const RegisterWidget());
}
