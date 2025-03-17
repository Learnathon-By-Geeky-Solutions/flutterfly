import '../../data/repositories/splash_repository.dart';

class CheckAppInitialization {
  final SplashRepository _splashRepository;
  
  CheckAppInitialization({SplashRepository? splashRepository})
      : _splashRepository = splashRepository ?? SplashRepository();

  Future<bool> execute() async {
    return await _splashRepository.isFirstTimeUser();
  }
}