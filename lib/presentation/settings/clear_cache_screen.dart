import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/app/theme/app_colors.dart';
import 'package:pdf_reader/bloc/app_cubit.dart';
import 'package:pdf_reader/app/utils/l10n_extensions.dart';

class ClearCacheScreen extends StatefulWidget {
  const ClearCacheScreen({super.key});

  @override
  State<ClearCacheScreen> createState() => _ClearCacheScreenState();
}

class _ClearCacheScreenState extends State<ClearCacheScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClear(BuildContext context) async {
    await context.read<AppCubit>().clearCache();
    if (!context.mounted) return;
    if (mounted) {
      setState(() => _showSuccess = true);
      _controller.forward();
      
      // Haptic feedback
      HapticFeedback.mediumImpact();

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted && context.mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgGradient = isDark ? AppColors.darkBgGradient : AppColors.lightBgGradient;
    final surfaceColor = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final loc = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: textColor),
          title: Text(loc.clearCache, style: TextStyle(color: textColor)),
        ),
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(gradient: bgGradient),
          child: BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Cache Icon / Success Icon
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: _showSuccess 
                                ? Colors.green.withValues(alpha: 0.1)
                                : AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _showSuccess 
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : AppColors.primary.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            _showSuccess ? Icons.check_circle_outline : Icons.delete_sweep_outlined,
                            size: 80,
                            color: _showSuccess ? Colors.green : AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      
                      // Storage Usage Info
                      if (!_showSuccess) ...[
                        Text(
                          state.cacheSize,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.storageUsage, // Corrected key
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                      ] else ...[
                        Text(
                          loc.cacheCleared,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 80),

                      // Glassmorphism Action Button
                      if (!_showSuccess)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 64,
                              decoration: BoxDecoration(
                                color: state.isClearingCache 
                                    ? surfaceColor.withValues(alpha: 0.3)
                                    : AppColors.primary,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                boxShadow: [
                                  if (!state.isClearingCache)
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: state.isClearingCache ? null : () => _handleClear(context),
                                  child: Center(
                                    child: state.isClearingCache
                                        ? SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: textColor,
                                            ),
                                          )
                                        : Text(
                                            loc.clearCache,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
