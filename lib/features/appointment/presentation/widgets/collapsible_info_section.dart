import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

/// A reusable collapsible section widget for displaying secondary information.
/// Shows a summary when collapsed and reveals full details when expanded.
class CollapsibleInfoSection extends StatefulWidget {
  const CollapsibleInfoSection({
    super.key,
    required this.icon,
    required this.title,
    required this.summary,
    required this.children,
    this.accentColor,
    this.initiallyExpanded = false,
  });

  /// The icon to display (HugeIcons type)
  final List<List<dynamic>> icon;

  /// The section title
  final String title;

  /// A brief summary shown when collapsed
  final String summary;

  /// The detailed content shown when expanded
  final List<Widget> children;

  /// Optional accent color for the section
  final Color? accentColor;

  /// Whether the section starts expanded
  final bool initiallyExpanded;

  @override
  State<CollapsibleInfoSection> createState() => _CollapsibleInfoSectionState();
}

class _CollapsibleInfoSectionState extends State<CollapsibleInfoSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _iconRotation;
  late Animation<double> _contentHeight;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }

    _iconRotation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _contentHeight = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor =
        widget.accentColor ?? const Color(0xFF10B981); // Green default

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(
          color: accentColor.withValues(alpha: 0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (always visible)
          InkWell(
            onTap: _toggleExpansion,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  HugeIcon(icon: widget.icon, size: 22, color: accentColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (!_isExpanded) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.summary,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: _iconRotation,
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _contentHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: accentColor.withValues(alpha: 0.2),
                  height: 1,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.children,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
