import '../repositories/splash_repository.dart';

class CheckAppInitialization {
  final ISplashRepository _splashRepository;

  CheckAppInitialization({required ISplashRepository splashRepository})
      : _splashRepository = splashRepository;

  Future<bool> execute() async {
    return await _splashRepository.isFirstTimeUser();
  }
}