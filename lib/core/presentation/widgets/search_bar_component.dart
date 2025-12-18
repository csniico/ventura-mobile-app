import 'dart:async';
import 'package:flutter/material.dart';

class SearchBarComponent<T> extends StatefulWidget {
  final String hint;

  /// Called when the user types — must return the search results
  final Future<List<T>> Function(String query) onSearch;

  /// Called when search results are ready — parent receives data
  final void Function(List<T> results) onResults;

  /// Optional decoration
  final Color? backgroundColor;
  final double borderRadius;

  const SearchBarComponent({
    super.key,
    required this.hint,
    required this.onSearch,
    required this.onResults,
    this.backgroundColor,
    this.borderRadius = 12,
  });

  @override
  State<SearchBarComponent<T>> createState() => _SearchBarComponentState<T>();
}

class _SearchBarComponentState<T> extends State<SearchBarComponent<T>> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onTextChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 350), () async {
      if (query.isEmpty) {
        widget.onResults([]);
        return;
      }

      final results = await widget.onSearch(query);

      if (!mounted) return;
      widget.onResults(results);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the border radius for a fully pill-shaped bar,
    // or use the provided radius if it's smaller.
    final double effectiveBorderRadius = widget.borderRadius < 30 ? 30.0 : widget.borderRadius;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _controller,
        onChanged: _onTextChanged,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          // Set hint text color to match the subtle grey in the image
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
          ),
          hintText: widget.hint,

          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
            size: 24,
          ),

          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),

          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[300]
              : Colors.grey[800],

          // Define the border to be fully rounded and without visible lines
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide.none, // Ensures no visible line/border
          ),

          // Use 'focusedBorder' and 'enabledBorder' as OutlineInputBorder with BorderSide.none
          // to prevent the default focus highlight line from appearing.
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}