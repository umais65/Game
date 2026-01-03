import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        debugPrint('Navigating to login screen');
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark detailed background
      body: Stack(
        children: [
          // Background Pattern
          const Positioned.fill(
            child: Opacity(
              opacity: 0.03, // Very subtle
              child: IconPatternBackground(),
            ),
          ),
          
          // Center Blob and Text
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                   // Organic Blob Shape
                  Container(
                    width: 250,
                    height: 250,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFBB86FC), Color(0xFF03DAC6)], // Primary & Secondary
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        topRight: Radius.circular(80),
                        bottomLeft: Radius.circular(80),
                        bottomRight: Radius.circular(100),
                      ),
                      boxShadow: [
                         BoxShadow(
                          color: Color(0x66BB86FC),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(end: const Offset(1.1, 1.1), duration: 2000.ms, curve: Curves.easeInOut)
                  .rotate(begin: -0.05, end: 0.05, duration: 3000.ms, curve: Curves.easeInOut),

                  // Overlay another blob for effect
                   Container(
                    width: 230,
                    height: 240,
                     decoration: BoxDecoration(
                      color: const Color(0xFF121212).withValues(alpha: 0.3), // Darker overlay for depth
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(110),
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                  )
                   .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .scale(begin: const Offset(1.05, 1.05), end: const Offset(0.95, 0.95), duration: 2500.ms, curve: Curves.easeInOut)
                   .rotate(begin: 0.05, end: -0.05, duration: 3500.ms, curve: Curves.easeInOut),

                  // Text
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'MINDMIX',
                        style: GoogleFonts.orbitron( // Gaming font
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3.0,
                          shadows: [
                             const BoxShadow(
                              color: Color(0xFF03DAC6),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0, duration: 800.ms, curve: Curves.easeOutBack),
                      
                      const SizedBox(height: 8),
                      Text(
                        'GAME ON',
                        style: GoogleFonts.rajdhani(
                          fontSize: 14,
                          color: Colors.white70,
                          letterSpacing: 4.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate(delay: 400.ms).fadeIn(duration: 800.ms),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IconPatternBackground extends StatelessWidget {
  const IconPatternBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 40,
          runSpacing: 40,
          children: List.generate(100, (index) {
             IconData iconData;
             if (index % 4 == 0) {
               iconData = Icons.gamepad;
             } else if (index % 4 == 1) {
               iconData = Icons.extension; // Puzzle piece
             } else if (index % 4 == 2) {
               iconData = Icons.school; // Brain
             } else {
               iconData = Icons.timer;
             }
             
            return Transform.rotate(
              angle: (index % 2 == 0 ? 0.2 : -0.2),
              child: Icon(
                iconData,
                color: Colors.white, // White icons for dark theme
                size: 24,
              ),
            );
          }),
        );
      },
    );
  }
}
