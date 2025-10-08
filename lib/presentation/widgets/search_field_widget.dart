
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_more_jank/controllers/search_controller.dart';

class SearchField extends ConsumerStatefulWidget {
  const SearchField({super.key, required this.janky});
  final bool janky;
  @override
  ConsumerState<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<SearchField> {
  final _searchController = TextEditingController();
  @override
  void dispose() { _searchController.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: const InputDecoration(labelText: 'Search TMDB', hintText: 'e.g., batman', border: OutlineInputBorder()),
      onChanged: (searchQuery) => ref.read(searchControllerProvider.notifier).onQueryChanged(searchQuery, janky: widget.janky),
    );
  }
}