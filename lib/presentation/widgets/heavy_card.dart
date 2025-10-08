import 'package:flutter/material.dart';

class HeavyCard extends StatelessWidget {
  const HeavyCard({super.key});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Opacity(
        opacity: 0.97,
        child: Container(
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 24, spreadRadius: 3, offset: Offset(0, 8))],
            gradient: LinearGradient(colors: [Colors.deepPurple, Colors.pinkAccent]),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const Icon(Icons.movie, size: 48, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Complex item', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Intentional heavy effects: gradient + shadow + clip + opacity', style: TextStyle(color: Colors.white70)),
            ])),
          ]),
        ),
      ),
    );
  }
}