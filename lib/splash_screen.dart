import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  final int duration;

  const SplashScreen({
    super.key,
    this.child,
    this.duration = 3,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: widget.duration),
      () {
        if (mounted && widget.child != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => widget.child!),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF532C8C), // #532C8C
              Color(0xFF171A58), // #171A58
            ],
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/logo/logo-light.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

