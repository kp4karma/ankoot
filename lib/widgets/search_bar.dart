import 'package:flutter/material.dart';

class ReusableSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool showClearButton;
  final IconData prefixIcon;
  final Color? fillColor;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  const ReusableSearchBar({
    Key? key,
    this.hintText = 'Search...',
    required this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.controller,
    this.showClearButton = true,
    this.prefixIcon = Icons.search,
    this.fillColor,
    this.borderRadius = 8.0,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
  }) : super(key: key);

  @override
  State<ReusableSearchBar> createState() => _ReusableSearchBarState();
}

class _ReusableSearchBarState extends State<ReusableSearchBar> {
  late TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _showClear = _controller.text.isNotEmpty && widget.showClearButton;
    });
    widget.onChanged(_controller.text);
  }

  void _clearText() {
    _controller.clear();
    widget.onClear?.call();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: widget.textStyle,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ?? TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: Colors.grey[600],
          ),
          suffixIcon: _showClear
              ? IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.grey[600],
            ),
            onPressed: _clearText,
          )
              : null,
          filled: true,
          fillColor: widget.fillColor ?? Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

// Usage Examples:

class SearchBarExamples extends StatefulWidget {
  @override
  _SearchBarExamplesState createState() => _SearchBarExamplesState();
}

class _SearchBarExamplesState extends State<SearchBarExamples> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Bar Examples')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Search Bar
            Text('Basic Search Bar:', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            ReusableSearchBar(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            SizedBox(height: 20),

            // Customized Search Bar
            Text('Customized Search Bar:', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            ReusableSearchBar(
              controller: _searchController,
              hintText: 'Search products...',
              prefixIcon: Icons.shopping_cart,
              fillColor: Colors.blue[50],
              borderRadius: 15.0,
              onChanged: (value) {
                print('Search: $value');
              },
              onSubmitted: (value) {
                print('Submitted: $value');
              },
              onClear: () {
                print('Search cleared');
              },
            ),
            SizedBox(height: 20),

            // Compact Search Bar
            Text('Compact Search Bar:', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            ReusableSearchBar(
              hintText: 'Quick search...',
              borderRadius: 8.0,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              showClearButton: false,
              onChanged: (value) {
                // Handle search
              },
            ),
            SizedBox(height: 20),

            // Display search results
            if (_searchQuery.isNotEmpty) ...[
              Text('Search Results for: "$_searchQuery"',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('You searched for: $_searchQuery'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}