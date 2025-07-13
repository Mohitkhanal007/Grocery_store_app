import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/splash/presentation/pages/welcome_screen.dart';

void main() {
  testWidgets('Splash screen shows Grocery Store text', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: WelcomeScreen()));
    expect(find.text('Grocery Store'), findsOneWidget);
  });
}
