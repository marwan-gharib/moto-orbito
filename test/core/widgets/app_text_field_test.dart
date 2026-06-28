import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moto_orbito/core/widgets/app_text_field.dart';
import 'package:moto_orbito/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget({required Widget child}) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  group('AppTextField', () {
    testWidgets('renders label and hint', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: AppTextField(
            label: 'Test Label',
            hint: 'Test Hint',
            controller: TextEditingController(),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
    });

    testWidgets('obscureText toggles correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: AppTextField(
            label: 'Test',
            hint: 'Test Hint',
            controller: TextEditingController(),
            obscureText: true,
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.obscureText, isTrue);
    });
  });
}
