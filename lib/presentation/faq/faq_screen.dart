import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader/app/theme/app_colors.dart';
import 'package:pdf_reader/app/utils/l10n_extensions.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgGradient =
        isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final loc = context.l10n;

    final faqItems = [
      {'q': loc.faqQ1, 'a': loc.faqA1},
      {'q': loc.faqQ2, 'a': loc.faqA2},
      {'q': loc.faqQ3, 'a': loc.faqA3},
      {'q': loc.faqQ4, 'a': loc.faqA4},
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: textColor),
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                color: surfaceColor.withValues(alpha: 0.5),
              ),
            ),
          ),
          title: Text(
            loc.faq,
            style: TextStyle(color: textColor),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(gradient: bgGradient),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Section
                  Text(
                    loc.faqAboutTitle,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.faqAboutDesc,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.8),
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Features Section
                  Text(
                    loc.faqFeaturesTitle,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.faqFeaturesDesc,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.8),
                      fontSize: 16,
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // FAQ Section Header
                  Text(
                    loc.faq,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // FAQ Items
                  ...faqItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['q']!,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['a']!,
                            style: TextStyle(
                              color: textColor.withValues(alpha: 0.8),
                              fontSize: 15,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
