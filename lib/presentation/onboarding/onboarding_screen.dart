import 'package:flutter/material.dart';
import 'package:pdf_reader/app/theme/app_colors.dart';
import 'package:pdf_reader/presentation/onboarding/widgets/onboarding_slide.dart';
import 'package:pdf_reader/presentation/router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf_reader/app/utils/l10n_extensions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgGradient = isDark
        ? AppColors.darkBgGradient
        : AppColors.lightBgGradient;
    final loc = context.l10n;
    
    final List<Map<String, String>> onboardingData = [
      {
        'title': loc.onboardingNoAdsTitle,
        'description': loc.onboardingNoAdsDesc,
        'icon': 'block',
      },
      {
        'title': loc.onboardingFreeTitle,
        'description': loc.onboardingFreeDesc,
        'icon': 'money_off',
      },
      {
        'title': loc.onboardingOpenSourceTitle,
        'description': loc.onboardingOpenSourceDesc,
        'icon': 'code',
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = onboardingData[index];
                    return OnboardingSlide(data: data, isDark: isDark);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 24.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dots indicator
                    Row(
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: _currentIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    // Next / Start Button
                    FloatingActionButton.extended(
                      onPressed: () {
                        if (_currentIndex == onboardingData.length - 1) {
                          _completeOnboarding();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      label: Text(
                        _currentIndex == onboardingData.length - 1
                            ? loc.getStarted
                            : loc.nextButton,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      icon: Icon(
                        _currentIndex == onboardingData.length - 1
                            ? Icons.check
                            : Icons.arrow_forward_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
