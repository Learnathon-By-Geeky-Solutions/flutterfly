import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quickdeal/features/auth/signup/client_signup/domain/entities/client_entity.dart';
import 'package:quickdeal/features/auth/signup/client_signup/domain/usecases/client_signup_usecase.dart';
import 'package:quickdeal/features/auth/signup/client_signup/presentation/controllers/client_signup_notifier.dart';
import 'package:quickdeal/features/auth/signup/client_signup/presentation/state/client_signup_state.dart';

class MockSignupUseCase extends Mock implements SignupUseCase {}
class FakeClientEntity extends Fake implements ClientEntity {}

void main() {
  late MockSignupUseCase mockSignupUseCase;

  setUpAll(() {
    registerFallbackValue(ClientEntity(
      fullName: 'Test User',
      email: 'test@example.com',
      password: 'Password123!',
    ));
  });

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
  });

  group('Client Entity Tests', () {
    test('creates client entity with required fields', () {
      final client = ClientEntity(
        fullName: 'Test User',
        email: 'test@example.com',
        password: 'Password123!',
      );

      expect(client.fullName, 'Test User');
      expect(client.email, 'test@example.com');
      expect(client.password, 'Password123!');
      expect(client.profilePic, null);
      expect(client.contactNumber, null);
      expect(client.clientBkashNumber, null);
    });

    test('creates client entity with optional fields', () {
      final client = ClientEntity(
        fullName: 'Test User',
        email: 'test@example.com',
        password: 'Password123!',
        profilePic: 'profile.jpg',
        contactNumber: '1234567890',
        clientBkashNumber: '0987654321',
      );

      expect(client.profilePic, 'profile.jpg');
      expect(client.contactNumber, '1234567890');
      expect(client.clientBkashNumber, '0987654321');
    });
  });

  group('ClientSignupNotifier Tests', () {
    test('initial state is correct', () {
      final notifier = ClientSignupNotifier(mockSignupUseCase);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, null);
      expect(notifier.state.isSuccess, false);
    });

    test('successful signup updates state correctly', () async {
      final notifier = ClientSignupNotifier(mockSignupUseCase);
      when(() => mockSignupUseCase.execute(any())).thenAnswer((_) async {});

      final result = await notifier.signup(
        'Test User',
        'test@example.com',
        'Password123!',
      );

      expect(result, true);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.isSuccess, true);
      expect(notifier.state.errorMessage, null);

      verify(() => mockSignupUseCase.execute(any())).called(1);
    });

    test('failed signup updates state with error', () async {
      final notifier = ClientSignupNotifier(mockSignupUseCase);
      when(() => mockSignupUseCase.execute(any()))
          .thenThrow(Exception('Signup failed'));

      final result = await notifier.signup(
        'Test User',
        'test@example.com',
        'Password123!',
      );

      expect(result, false);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.isSuccess, false);
      expect(notifier.state.errorMessage, 'Exception: Signup failed');

      // Verify that execute was called with any ClientEntity
      verify(() => mockSignupUseCase.execute(any())).called(1);
    });
  });
}
