import 'package:flutter/material.dart';

import '../i18n/strings.g.dart';
import '../theme/app_colors_extension.dart';

extension MotoBuildContext on BuildContext {
  AppColorsExtension get colors {
    return Theme.of(this).extension<AppColorsExtension>()!;
  }

  TextTheme get textTheme => Theme.of(this).textTheme;

  Translations get t => LocaleSettings.instance.currentTranslations;
}
