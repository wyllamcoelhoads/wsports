import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Simula um carregamento de dados inicial (ex: buscar próxima corrida de F1)
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      // Aqui você decide para onde o usuário vai
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Mesma cor da nativa
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Seu Logo com uma animação suave
            TweenAnimationBuilder(
              duration: const Duration(milliseconds: 1500),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(scale: value, child: child),
                );
              },
              child: Image.asset('assets/images/logo_splash.png', width: 180),
            ),
            const SizedBox(height: 30),
            // Indicador de carregamento sutil
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.f1Red), // Cor da F1/Copa
            ),
          ],
        ),
      ),
    );
  }
}