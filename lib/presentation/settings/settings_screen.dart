import 'dart:ui';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/bloc/app_cubit.dart';
import 'package:pdf_reader/app/theme/app_colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf_reader/presentation/router.dart';
import 'package:pdf_reader/app/utils/l10n_extensions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  void _showLanguageDialog(BuildContext context, Color textColor, Color surfaceColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: surfaceColor,
        title: Text(context.l10n.selectLanguage, style: TextStyle(color: textColor)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(context.l10n.english, style: TextStyle(color: textColor)),
              onTap: () {
                context.read<AppCubit>().setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(context.l10n.uzbek, style: TextStyle(color: textColor)),
              onTap: () {
                context.read<AppCubit>().setLocale(const Locale('uz'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
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
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {
          if (!state.isClearingCache && state.pdfFiles.isEmpty) {
            // Show success message only if it was just cleared
          }
        },
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: BackButton(
                color: textColor,
              ),
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
                loc.settings,
                style: TextStyle(color: textColor),
              ),
            ),
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(gradient: bgGradient),
              child: SafeArea(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Appearance & Locale
                    _buildSettingItem(
                      icon: isDark ? Icons.light_mode : Icons.dark_mode,
                      title: loc.changeTheme,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      onTap: () {
                        if (isDark) {
                          AdaptiveTheme.of(context).setLight();
                        } else {
                          AdaptiveTheme.of(context).setDark();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingItem(
                      icon: Icons.language,
                      title: loc.language,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      onTap: () =>
                          _showLanguageDialog(context, textColor, surfaceColor),
                    ),
                    const SizedBox(height: 24),

                    // Help & Support
                    _buildSettingItem(
                      icon: Icons.help_outline,
                      title: loc.faq,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.faqRoute);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingItem(
                      icon: Icons.support_agent,
                      title: loc.support,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      onTap: () {
                        _launchUrl('https://t.me/liderBobur');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingItem(
                      icon: Icons.delete_sweep_outlined,
                      title: loc.clearCache,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      trailing: Text(
                        state.cacheSize,
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.5),
                          fontSize: 13,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                            context, RouteNames.clearCacheRoute);
                      },
                    ),
                    const SizedBox(height: 24),

                    // App & Social
                    _buildSettingItem(
                      icon: Icons.star_outline,
                      title: loc.rateApp,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      onTap: () {
                        _launchUrl('https://github.com/Boburbro/pdf_reader');
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingItem(
                      icon: Icons.share_outlined,
                      title: loc.shareApp,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      onTap: () {
                        // ignore: deprecated_member_use
                        Share.share(
                            loc.shareMessage);
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildSettingItem(
                      icon: Icons.code,
                      title: loc.openSource,
                      textColor: textColor,
                      surfaceColor: surfaceColor,
                      onTap: () {
                        _launchUrl('https://github.com/Boburbro/pdf_reader');
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Color textColor,
    required Color surfaceColor,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: surfaceColor.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: textColor, size: 28),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (trailing != null)
                  trailing
                else
                  Icon(Icons.chevron_right,
                      color: textColor.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
