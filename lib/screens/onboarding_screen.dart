import 'package:flutter/material.dart';
import 'login_screen.dart'; // sua tela de login
// import 'dashboard_screen.dart'; // não precisamos mais aqui

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentSlide = 0;

  final List<String> _slides = ['SLIDE 1', 'SLIDE 2', 'SLIDE 3'];

  void _nextSlide() {
    if (_currentSlide < _slides.length - 1) {
      setState(() {
        _currentSlide++;
      });
    } else {
      // Último slide → vai para a tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  _slides[_currentSlide],
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextSlide,
                  child: Text(
                    _currentSlide < _slides.length - 1
                        ? 'Continuar'
                        : 'Começar', // muda no último slide
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
