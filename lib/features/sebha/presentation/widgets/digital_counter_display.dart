import 'package:flutter/material.dart';

class DigitalCounterDisplay extends StatelessWidget {
  final int count;

  const DigitalCounterDisplay({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final height = (screenWidth * 0.18).clamp(55.0, 75.0);
    final fontSize = (screenWidth * 0.1).clamp(28.0, 42.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: Text(
            '$count',
            key: ValueKey(count),
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
              fontFamily: 'monospace',
            ),
          ),
        ),
      ),
    );
  }
}
