enum CacheKey {
  firstTimeUser,
  isOnboardingCompleted,
  isUserLoggedIn,
  userToken,
}

abstract class CacheService {
  Future<void> save<T>(CacheKey key, T value);

  T? get<T>(CacheKey key);

  Future<void> remove(List<CacheKey> keys);

  Future<void> clear();
}