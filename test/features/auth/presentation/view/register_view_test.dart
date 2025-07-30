import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jerseyhub/app/service_locator/service_locator.dart';
import 'package:jerseyhub/features/auth/domain/use_case/user_register_usecase.dart';
import 'package:jerseyhub/features/auth/presentation/view/register_view.dart';

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
    await tester.pumpWidget(const MaterialApp(home: RegisterView()));
  }

  testWidgets('renders all input fields and sign up button', (
    WidgetTester tester,
  ) async {
    await pumpRegisterView(tester);

    expect(find.byKey(const Key('usernameField')), findsOneWidget);
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    expect(find.byKey(const Key('signUpButton')), findsOneWidget);
    expect(find.text('Sign Up'), findsWidgets); // Title and Button
  });

  testWidgets('shows alert when fields are empty', (WidgetTester tester) async {
    await pumpRegisterView(tester);

    await tester.tap(find.byKey(const Key('signUpButton')));
    await tester.pumpAndSettle();

    expect(find.text('Missing Fields'), findsOneWidget);
    expect(find.textContaining('fill in all the fields'), findsOneWidget);
  });
}
