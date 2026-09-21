import 'package:app_core/app_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_injections/flutter_injections.dart';

import 'app_env.dart';
import 'app_routes.dart';
import 'theme/app_theme.dart';

/// Root widget. Registers the global injections exactly once.
class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterInjectionsWidget(
      injections: CoreInjections.core(baseUrl: AppEnv.baseUrl),
      builder: (_) => MaterialApp(
        title: AppEnv.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRouteNames.appointments,
      ),
    );
  }
}
