import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/auth_controller.dart';
import '../../widgets/nexify_transitions.dart';
import '../app_shell.dart';
import '../auth/authentication_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  late Animation<double> _nameFade;
  late Animation<Offset> _nameSlide;

  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;

  late Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();

    // Main splash animation controller.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    // ------------------------------------------------------------
    // LOGO ANIMATION
    // ------------------------------------------------------------

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    // ------------------------------------------------------------
    // NEXIFY NAME ANIMATION
    // ------------------------------------------------------------

    _nameFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.30, 0.72, curve: Curves.easeOut),
    );

    _nameSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.30, 0.78, curve: Curves.easeOutCubic),
          ),
        );

    // ------------------------------------------------------------
    // TAGLINE ANIMATION
    // ------------------------------------------------------------

    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.52, 0.85, curve: Curves.easeOut),
    );

    _taglineSlide =
        Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.52, 0.90, curve: Curves.easeOutCubic),
          ),
        );

    // ------------------------------------------------------------
    // LOADING INDICATOR
    // ------------------------------------------------------------

    _loaderFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.72, 1.0, curve: Curves.easeOut),
    );

    // Start the animation.
    _controller.forward();

    // ------------------------------------------------------------
    // SPLASH → AUTHENTICATION
    // ------------------------------------------------------------

    Timer(const Duration(milliseconds: 1200), _finishSplash);
  }

  Future<void> _finishSplash() async {
    if (!mounted) return;

    await context.read<AuthController>().tryRestoreSession();
    if (!mounted) return;

    final destination = context.read<AuthController>().session.isLoggedIn
        ? const AppShell()
        : const AuthenticationScreen();
    Navigator.pushReplacement(
      context,
      NexifyTransitions.fadeSlide(destination),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF000000), Color(0xFF0A0F1C)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --------------------------------------------------
              // NEXIFY LOGO
              // --------------------------------------------------

              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF22C55E)
                              .withValues(alpha: 0.64),
                          blurRadius: 32,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'N',
                        style: TextStyle(
                          fontSize: 58,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // --------------------------------------------------
              // NEXIFY NAME
              // --------------------------------------------------
              FadeTransition(
                opacity: _nameFade,
                child: SlideTransition(
                  position: _nameSlide,
                  child: const Text(
                    'Nexify',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // --------------------------------------------------
              // TAGLINE
              // --------------------------------------------------
              FadeTransition(
                opacity: _taglineFade,
                child: SlideTransition(
                  position: _taglineSlide,
                  child: const Text(
                    'Where Markets Meet Opportunity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFB8C0CC),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 45),

              // --------------------------------------------------
              // LOADING INDICATOR
              // --------------------------------------------------
              FadeTransition(
                opacity: _loaderFade,
                child: const SizedBox(
                  width: 23,
                  height: 23,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF22C55E),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
