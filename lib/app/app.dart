import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/app/theme/app_theme.dart';
import 'package:pdf_reader/bloc/app_cubit.dart';
import 'package:pdf_reader/presentation/router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AppCubit())],
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.lightTheme,
      dark: AppTheme.darkTheme,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PDF Reader',
        theme: theme,
        darkTheme: darkTheme,
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: RouteNames.splashRoute,
      ),
    );
  }
}
