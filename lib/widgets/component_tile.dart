import 'package:flutter/material.dart';
import '../models/ai_component.dart';
import '../utils/constants.dart';

class ComponentTile extends StatefulWidget {
  final AIComponent component;
  final double size;

  const ComponentTile({
    super.key,
    required this.component,
    required this.size,
  });

  @override
  State<ComponentTile> createState() => _ComponentTileState();
}

class _ComponentTileState extends State<ComponentTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.component.color,
                  widget.component.color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.component.color.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.component.color.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.component.icon,
                  color: Colors.white,
                  size: widget.size * 0.3,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.component.level.toString(),
                  style: TextStyle(
                    fontSize: widget.size * 0.15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (widget.size > 60)
                  Text(
                    widget.component.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.size * 0.08,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}