import '../../data/repository/api_data_repository.dart';
import '../../domain/repository/api_repository.dart';
import '../dependencies/api_module.dart';

class RepositoryModule {
  static ApiRepository? _apiRepository;
  static ApiRepository apiRepository() {
    return _apiRepository ??
        ApiDataRepository(ApiModule.auth(), ApiModule.api());
  }
}
