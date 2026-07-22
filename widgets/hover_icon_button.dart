import 'package:flutter/material.dart';

class HoverIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const HoverIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  State<HoverIconButton> createState() => _HoverIconButtonState();
}

class _HoverIconButtonState extends State<HoverIconButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(isHovered ? 0.20 : 0.10),
          borderRadius: BorderRadius.circular(10),
        ),

        child: Column(
          children: [
            IconButton(
              iconSize: isHovered ? 45 : 35,
              color: widget.color,
              icon: Icon(widget.icon),
              onPressed: widget.onTap,
            ),

            AnimatedOpacity(
              opacity: isHovered ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
