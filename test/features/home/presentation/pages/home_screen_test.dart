import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/home/presentation/pages/home_screen.dart';

void main() {
  testWidgets('Home screen shows Fresh Deals and product categories', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: HomeScreen()),
      ),
    );

    await tester.pumpAndSettle();

    // Expect "Fresh Deals!" text
    expect(find.text('Fresh Deals!'), findsOneWidget);

    // Expect all 4 categories to be rendered
    expect(find.text('Vegetables'), findsOneWidget);
    expect(find.text('Fruits'), findsOneWidget);
    expect(find.text('Dairy'), findsOneWidget);
    expect(find.text('Snacks'), findsOneWidget);
  });
}
