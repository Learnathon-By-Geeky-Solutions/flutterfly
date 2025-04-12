import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickdeal/features/auth/signup/client_signup/domain/entities/client_entity.dart';
import '../../domain/usecases/client_signup_usecase.dart';
import '../state/client_signup_state.dart';

class ClientSignupNotifier extends StateNotifier<ClientSignupState> {
  final SignupUseCase signupUseCase;

  ClientSignupNotifier(this.signupUseCase) : super(ClientSignupState());

 Future<bool> signup(String fullName, String email, String password) async {
   state = state.copyWith(isLoading: true, errorMessage: null);

   try {
     final clientEntity = ClientEntity(fullName: fullName, email: email, password: password);
     await signupUseCase.execute(clientEntity);
     state = state.copyWith(isLoading: false, isSuccess: true);
     return true;
   } catch (e) {
     state = state.copyWith(isLoading: false, errorMessage: e.toString());
     return false;
   }
 }
}