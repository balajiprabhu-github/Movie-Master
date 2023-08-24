import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/splash/bloc/splash_bloc.dart';
import 'package:movies/features/home/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  final SplashBloc splashBloc = SplashBloc();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    splashBloc.add(SplashAnimationStartEvent());
    initAnimations();
  }

  initAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocListener(
        bloc: splashBloc,
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: const ImageIcon(
              AssetImage("assets/app-logo.png"),
              color: Color(0xFFCD0404),
              size: 150,
            ),
          ),
        ),
        listener: (context, state) {
          if (state is SplashInitial) {
            _animationController.forward();
          } else if (state is SplashAnimationEndState) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
