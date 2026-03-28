import 'package:flutter/material.dart';
import 'package:pdf_reader/app/theme/app_colors.dart';
import 'package:pdf_reader/presentation/onboarding/widgets/onboarding_slide.dart';
import 'package:pdf_reader/presentation/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'No Ads',
      'description':
          'Enjoy a seamless reading experience without any interruptions.',
      'icon': 'block',
    },
    {
      'title': 'Completely Free',
      'description': 'All premium features are available to you at zero cost.',
      'icon': 'money_off',
    },
    {
      'title': 'Open Source',
      'description':
          'Transparent, secure, and built by the community for the community.',
      'icon': 'code',
    },
  ];

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
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    final data = _onboardingData[index];
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
                        _onboardingData.length,
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
                        if (_currentIndex == _onboardingData.length - 1) {
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
                        _currentIndex == _onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      icon: Icon(
                        _currentIndex == _onboardingData.length - 1
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
