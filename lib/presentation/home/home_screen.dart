import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader/app/utils/l10n_extensions.dart';
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
  Future<void> _pickPdfFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        if (context.mounted) {
          context.read<AppCubit>().addPdfFile(file.path!, file.name);
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgGradient =
        isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _pickPdfFile(context),
          backgroundColor: AppColors.primary,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
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
          title: Text(context.l10n.pdfFiles),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.settingsRoute);
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
                    return PdfCard(
                      name: file.name,
                      path: file.path,
                      lastOpenedAt: file.lastOpenedAt,
                      isDark: isDark,
                    );
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
