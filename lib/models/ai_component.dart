import 'package:flutter/material.dart';

class AIComponent {
  final int level;
  final String name;
  final Color color;
  final IconData icon;
  final int points;

  const AIComponent({
    required this.level,
    required this.name,
    required this.color,
    required this.icon,
    required this.points,
  });

  static const List<AIComponent> components = [
    AIComponent(
      level: 1,
      name: 'Basic CPU',
      color: Colors.grey,
      icon: Icons.memory,
      points: 2,
    ),
    AIComponent(
      level: 2,
      name: 'GPU Core',
      color: Colors.green,
      icon: Icons.computer,
      points: 4,
    ),
    AIComponent(
      level: 3,
      name: 'Neural Net',
      color: Colors.blue,
      icon: Icons.psychology,
      points: 8,
    ),
    AIComponent(
      level: 4,
      name: 'Deep Learning',
      color: Colors.purple,
      icon: Icons.hub,
      points: 16,
    ),
    AIComponent(
      level: 5,
      name: 'AI Assistant',
      color: Colors.orange,
      icon: Icons.support_agent,
      points: 32,
    ),
    AIComponent(
      level: 6,
      name: 'Quantum AI',
      color: Colors.red,
      icon: Icons.science,
      points: 64,
    ),
    AIComponent(
      level: 7,
      name: 'AGI System',
      color: Colors.teal,
      icon: Icons.auto_awesome,
      points: 128,
    ),
    AIComponent(
      level: 8,
      name: 'Super AI',
      color: Colors.deepPurple,
      icon: Icons.rocket_launch,
      points: 256,
    ),
  ];

  static AIComponent? getComponentByLevel(int level) {
    if (level < 1 || level > components.length) return null;
    return components[level - 1];
  }
}