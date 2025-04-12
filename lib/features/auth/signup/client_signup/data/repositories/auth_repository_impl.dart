import 'package:quickdeal/features/auth/signup/client_signup/domain/entities/client_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/client_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);
  @override
  Future<void> signup(ClientEntity clientEntity) async {
    // Convert ClientEntity to ClientModel
    final clientModel = ClientModel(
      fullName: clientEntity.fullName,
      email: clientEntity.email,
      password: clientEntity.password
    );
    // Call the remote data source to perform the signup
    // and handle any exceptions that may occur
    try {
      await remoteDataSource.signup(clientModel);
    } catch (e) {
      // Handle exceptions here if needed
      rethrow; // Rethrow the exception to be handled by the caller
    }
  }
}