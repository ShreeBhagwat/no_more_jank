import 'package:flutter/material.dart';
import 'package:no_more_jank/presentation/screens/home_screen.dart';
import 'package:no_more_jank/presentation/widgets/common_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          child: const Text('Go to Home'),
        ),
      ),
    );
  }
}
