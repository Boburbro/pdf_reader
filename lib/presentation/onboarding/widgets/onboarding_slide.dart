import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdf_reader/app/theme/app_colors.dart';

class OnboardingSlide extends StatelessWidget {
  final Map<String, String> data;
  final bool isDark;

  const OnboardingSlide({
    super.key,
    required this.data,
    required this.isDark,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'block':
        return Icons.block_outlined;
      case 'money_off':
        return Icons.money_off_csred_outlined;
      case 'code':
        return Icons.code_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final blurColor = isDark ? AppColors.blurDark : AppColors.blurLight;
    final blurBorder = isDark ? AppColors.blurBorderDark : AppColors.blurBorderLight;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: blurColor,
              border: Border.all(color: blurBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 10,
                )
              ],
            ),
            child: Icon(
              _getIconData(data['icon']!),
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 48),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: blurColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: blurBorder, width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      data['title']!,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      data['description']!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
