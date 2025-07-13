import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/features/home/presentation/pages/dashboard_screen.dart';

void main() {
  testWidgets(
    'DashboardScreen renders app bar, search field, and featured products',
    (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: DashboardScreen()));

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Featured Products'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    },
  );
}
