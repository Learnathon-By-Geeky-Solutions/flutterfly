import '../../data/repositories/splash_repository.dart';

class CheckAppInitialization {
  final SplashRepository _splashRepository = SplashRepository();

  Future<bool> execute() async {
    return await _splashRepository.isFirstTimeUser();
  }
}