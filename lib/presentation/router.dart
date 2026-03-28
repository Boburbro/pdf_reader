import 'package:flutter/material.dart';
import 'package:pdf_reader/presentation/home/home_screen.dart';
import 'package:pdf_reader/presentation/onboarding/onboarding_screen.dart';
import 'package:pdf_reader/presentation/pdf_view/pdf_view.dart';
import 'package:pdf_reader/presentation/splash/splash_screen.dart';

class RouteNames {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String pdfViewRoute = '/pdf_view';
  static const String onboardingRoute = '/onboarding';
}

class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashRoute:
        return navigate(const SplashScreen());
      case RouteNames.pdfViewRoute:
        return navigate(PdfView(path: settings.arguments as String));
      case RouteNames.onboardingRoute:
        return navigate(const OnboardingScreen());
      default:
        return navigate(const HomeScreen());
    }
  }
}

MaterialPageRoute navigate(Widget widget) =>
    MaterialPageRoute(builder: (context) => widget);
