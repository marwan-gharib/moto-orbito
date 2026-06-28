import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

final class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.colorScheme.primary),
    );
  }
}
