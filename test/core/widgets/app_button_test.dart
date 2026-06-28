import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';
import 'package:moto_orbito/core/theme/app_theme.dart';

void main() {
  Widget buildTestWidget({required Widget child}) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    );
  }

  group('AppButton', () {
    testWidgets('renders label', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: AppButton(
            label: 'Test Button',
            onTap: () {},
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('renders loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: AppButton(
            label: 'Test Button',
            onTap: () {},
            isLoading: true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestWidget(
          child: AppButton(
            label: 'Test Button',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when disabled', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestWidget(
          child: AppButton(
            label: 'Test Button',
            onTap: () {
              tapped = true;
            },
            isDisabled: true,
          ),
        ),
      );

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });
  });
}
