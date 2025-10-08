
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HeavyNumber extends StatefulWidget {
  const HeavyNumber({super.key, required this.janky, required this.vote});
  final bool janky; final double vote;
  @override
  State<HeavyNumber> createState() => _HeavyNumberState();
}

class _HeavyNumberState extends State<HeavyNumber> {
  final Map<int, int> _cache = {};
  static int _fibCompute(int n) => n < 2 ? n : _fibCompute(n - 1) + _fibCompute(n - 2);
  Future<int> _fibAsync(int n) => compute(_fibCompute, n);
  @override
  Widget build(BuildContext context) {
    final n = widget.janky ? 32 : 28;
    final cached = _cache[n];
    if (cached != null) {
      return Text('heavy=$cached  •  ⭐️ ${widget.vote.toStringAsFixed(1)}', maxLines: 1, overflow: TextOverflow.ellipsis);
    }
    return FutureBuilder<int>(
      future: _fibAsync(n).then((v) => _cache[n] = v).then((_) => _cache[n]!),
      builder: (context, snap) => Text(
        snap.hasData ? 'heavy=${snap.data}  •  ⭐️ ${widget.vote.toStringAsFixed(1)}' : 'computing…',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
