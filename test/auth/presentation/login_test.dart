import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickdeal/features/auth/presentation/screens/signin_screen.dart';
import 'package:quickdeal/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('Login screen has form validation', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.byKey(const Key('login-button')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.enterText(find.byKey(const Key('email-field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password-field')), 'Password123!');

    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
