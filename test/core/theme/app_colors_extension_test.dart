import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moto_orbito/core/theme/app_colors_extension.dart';
import 'package:moto_orbito/core/theme/app_theme.dart';

void main() {
  group('AppColorsExtension', () {
    testWidgets('resolves all 13 tokens in light and dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.system,
          home: Builder(
            builder: (context) {
              final colors = Theme.of(context).extension<AppColorsExtension>();
              expect(colors, isNotNull);
              expect(colors!.primary, isNotNull);
              expect(colors.primaryVariant, isNotNull);
              expect(colors.onPrimary, isNotNull);
              expect(colors.surface, isNotNull);
              expect(colors.onSurface, isNotNull);
              expect(colors.background, isNotNull);
              expect(colors.onBackground, isNotNull);
              expect(colors.error, isNotNull);
              expect(colors.onError, isNotNull);
              expect(colors.success, isNotNull);
              expect(colors.warning, isNotNull);
              expect(colors.divider, isNotNull);
              expect(colors.skeleton, isNotNull);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });
  });
}
