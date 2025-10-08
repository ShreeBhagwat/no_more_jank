import 'package:flutter/material.dart';

class LeanCard extends StatelessWidget {
  const LeanCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(blurRadius: 4, offset: Offset(0, 1))],
      ),
      child: const ListTile(
        leading: Icon(Icons.movie_outlined),
        title: Text('Lean layout'),
        subtitle: Text('Isolated paints; minimal effects'),
      ),
    );
  }
}
