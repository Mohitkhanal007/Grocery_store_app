import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:my_flutter_app/features/auth/presentation/pages/signup_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Mock path_provider to avoid MissingPluginException
    const MethodChannel(
      'plugins.flutter.io/path_provider',
    ).setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.'; // mock directory
      }
      return null;
    });

    await Hive.initFlutter();
    await Hive.openBox('usersBox');
  });

  tearDown(() async {
    final usersBox = Hive.box('usersBox');
    await usersBox.clear();
  });

  group('SignupScreen Widget Tests', () {
    testWidgets('shows error when any field is empty', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('All fields are required'), findsOneWidget);
    });

    testWidgets('shows error when passwords do not match', (tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupScreen()));

      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), '1234');
      await tester.enterText(find.byType(TextField).at(3), '5678');

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('shows error if email already exists', (tester) async {
      final usersBox = Hive.box('usersBox');

      // Wait for Hive write
      await usersBox.put('test@example.com', {
        'name': 'Test User',
        'email': 'test@example.com',
        'password': '1234',
      });

      await tester.pumpWidget(MaterialApp(home: SignupScreen()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Test User');
      await tester.enterText(find.byType(TextField).at(1), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(2), '1234');
      await tester.enterText(find.byType(TextField).at(3), '1234');

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(
        find.text('Email already exists. Try logging in.'),
        findsOneWidget,
      );
    });

    testWidgets('navigates to dashboard on successful signup', (tester) async {
      var navigated = false;

      await tester.pumpWidget(
        MaterialApp(
          home: SignupScreen(),
          routes: {
            '/dashboard': (_) {
              navigated = true;
              return const Scaffold(body: Text('Dashboard Page'));
            },
          },
        ),
      );

      await tester.enterText(find.byType(TextField).at(0), 'New User');
      await tester.enterText(find.byType(TextField).at(1), 'new@example.com');
      await tester.enterText(find.byType(TextField).at(2), '1234');
      await tester.enterText(find.byType(TextField).at(3), '1234');

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(navigated, isTrue);
    });
  }, skip: true);

  tearDownAll(() async {
    await Hive.close();
  });
}
