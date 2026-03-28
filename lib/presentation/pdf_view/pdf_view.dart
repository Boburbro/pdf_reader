import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/app/theme/app_colors.dart';
import 'package:pdf_reader/bloc/app_cubit.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key, required this.path});

  final String path;

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> {
  @override
  void initState() {
    context.read<AppCubit>().openedPath();
    super.initState();
  }

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
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                color: isDark ? AppColors.darkSurface.withValues(alpha: 0.5) : AppColors.lightSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          title: Text(
            widget.path.split('/').last,
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        body: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(gradient: bgGradient),
          child: SafeArea(
            child: SfPdfViewer.file(
              File(widget.path),
              canShowScrollHead: false,
              pageLayoutMode: PdfPageLayoutMode.continuous,
            ),
          ),
        ),
      ),
    );
  }
}
