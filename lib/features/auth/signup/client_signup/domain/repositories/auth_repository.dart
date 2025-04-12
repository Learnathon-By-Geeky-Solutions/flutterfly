import '../entities/client_entity.dart';

abstract class AuthRepository {
  Future<void> signup(ClientEntity clientEntity);
}