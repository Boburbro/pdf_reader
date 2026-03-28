import 'dart:ui';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/app/theme/app_colors.dart';
import 'package:pdf_reader/bloc/app_cubit.dart';
import 'package:pdf_reader/presentation/home/widgets/home_empty_state.dart';
import 'package:pdf_reader/presentation/home/widgets/pdf_card.dart';
import 'package:pdf_reader/presentation/router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgGradient = isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                color: isDark ? AppColors.darkSurface.withValues(alpha: 0.5) : AppColors.lightSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          title: const Text('PDF Files'),
          actions: [
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: child.key == const ValueKey(true)
                      ? Tween<double>(begin: 1.0, end: 0.75).animate(anim)
                      : Tween<double>(begin: 0.75, end: 1.0).animate(anim),
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  key: ValueKey(isDark),
                ),
              ),
              onPressed: () {
                final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
                if (isDarkTheme) {
                  AdaptiveTheme.of(context).setLight();
                } else {
                  AdaptiveTheme.of(context).setDark();
                }
              },
            ),
          ],
        ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(gradient: bgGradient),
          child: SafeArea(
            child: BlocConsumer<AppCubit, AppState>(
              listener: (context, state) {
                if (state.selectedPdf != null) {
                  Navigator.pushNamed(
                    context,
                    RouteNames.pdfViewRoute,
                    arguments: state.selectedPdf!.path,
                  );
                }
              },
              builder: (context, state) {
                if (state.pdfFiles.isEmpty) {
                  return HomeEmptyState(isDark: isDark);
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 80, left: 16, right: 16),
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.pdfFiles.length,
                  itemBuilder: (context, index) {
                    final file = state.pdfFiles[index];
                    return PdfCard(name: file.name, path: file.path, isDark: isDark);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
