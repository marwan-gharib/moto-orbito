import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'core/i18n/strings.g.dart';
import 'core/theme/app_theme.dart';

final class MotoOrbitoApp extends StatefulWidget {
  const MotoOrbitoApp({super.key});

  @override
  State<MotoOrbitoApp> createState() => _MotoOrbitoAppState();
}

final class _MotoOrbitoAppState extends State<MotoOrbitoApp> {
  late final Future<void> _localeInitialization;

  @override
  void initState() {
    super.initState();
    _localeInitialization = LocaleSettings.setLocale(AppLocale.en);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _localeInitialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            snapshot.hasError) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: GetIt.instance<GoRouter>(),
          locale: const Locale('en'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          builder: (context, child) {
            ScreenUtil.init(
              context,
              designSize: const Size(390, 844),
              minTextAdapt: true,
            );
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: TextScaler.noScaling),
              child: Directionality(
                textDirection: LocaleSettings.currentLocale.languageCode == 'ar'
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}
