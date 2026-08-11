import 'package:dailyreport/pages/home_page.dart';
import 'package:dailyreport/pages/name_entry_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Helper/setting_servive.dart';

class StudioSplah extends StatefulWidget {
  const StudioSplah({super.key});

  @override
  State<StudioSplah> createState() => _StudioSplahState();
}

class _StudioSplahState extends State<StudioSplah>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Hide system UI while splash screen is visible.
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.08,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    // Start loading the application immediately.
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // --------------------------------------------------
      // 1. Load settings while splash screen is showing
      // --------------------------------------------------

      final settings = await SettingsService.loadSettings();

      final bool hasCompletedSetup =
          settings['hasCompletedInitialSetup'] == true;

      // --------------------------------------------------
      // 2. Keep splash visible for at least 2.8 seconds
      // --------------------------------------------------

      await Future.delayed(
        const Duration(milliseconds: 2800),
      );

      if (!mounted) return;

      // --------------------------------------------------
      // 3. Decide where the user should go
      // --------------------------------------------------

      final Widget nextPage;

      if (hasCompletedSetup) {
        nextPage = const HomePage();
      } else {
        nextPage = const WelcomePage();
      }

      // --------------------------------------------------
      // 4. ONE navigation only
      // --------------------------------------------------

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(
            milliseconds: 700,
          ),
          reverseTransitionDuration: Duration.zero,

          pageBuilder: (_, animation, __) {
            return nextPage;
          },

          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      debugPrint(
        'App initialization error: $e',
      );

      if (!mounted) return;

      // If settings cannot be loaded,
      // show the Welcome page.
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(
            milliseconds: 700,
          ),
          reverseTransitionDuration: Duration.zero,

          pageBuilder: (_, animation, __) {
            return const WelcomePage();
          },

          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    // Restore system UI.
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SizedBox.expand(
            child: Image.asset(
              'assets/sohamarts.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}