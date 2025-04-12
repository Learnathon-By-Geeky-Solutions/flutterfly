import '../repositories/auth_repository.dart';
import '../entities/client_entity.dart';

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<void> execute(ClientEntity clientEntity) async {
    return await repository.signup(clientEntity);
  }
}