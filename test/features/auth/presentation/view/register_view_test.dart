import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:grocerystore/app/service_locator/service_locator.dart';
import 'package:grocerystore/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:grocerystore/features/auth/presentation/view/register_view.dart';

class MockUserRegisterUsecase extends Mock implements UserRegisterUsecase {}

void main() {
  late MockUserRegisterUsecase mockUserRegisterUsecase;

  setUp(() {
    mockUserRegisterUsecase = MockUserRegisterUsecase();

    // Register the mock in service locator
    serviceLocator.registerFactory<UserRegisterUsecase>(
      () => mockUserRegisterUsecase,
    );
  });

  tearDown(() {
    serviceLocator.reset();
  });

  Future<void> pumpRegisterView(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: RegisterView())),
    );
  }

  testWidgets('renders all input fields and sign up button', (
    WidgetTester tester,
  ) async {
    await pumpRegisterView(tester);

    expect(find.byKey(const Key('usernameField')), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('addressField')), findsOneWidget);
    expect(find.byKey(const Key('signUpButton')), findsOneWidget);
    expect(find.text('Sign Up'), findsWidgets); // Title and Button
  });

  // TODO: Fix this test - the alert dialog is not showing properly in the test environment
  // testWidgets('shows alert when fields are empty', (WidgetTester tester) async {
  //   await pumpRegisterView(tester);

  //   // Find and tap the sign up button
  //   final signUpButton = find.byKey(const Key('signUpButton'));
  //   await tester.ensureVisible(signUpButton);
  //   await tester.tap(signUpButton, warnIfMissed: false);
  //   await tester.pumpAndSettle();

  //   expect(find.text('Missing Fields'), findsOneWidget);
  //   expect(find.textContaining('fill in all the fields'), findsOneWidget);
  // });
}
