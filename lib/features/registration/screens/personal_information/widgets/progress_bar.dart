import 'package:flutter/material.dart';

class TProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final Duration animationDuration;
  final bool showPercentage;
  final TextStyle? percentageTextStyle;

  const TProgressBar({
    super.key,
    required this.value,
    this.height = 20.0, // Increased height to accommodate text
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = const Color(0xFF6FE08D),
    this.animationDuration = const Duration(milliseconds: 300),
    this.showPercentage = true,
    this.percentageTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(height / 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Progress bar fill
              AnimatedContainer(
                duration: animationDuration,
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                height: height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(height / 2),
                  gradient: LinearGradient(
                    colors: [
                      progressColor,
                      progressColor.withOpacity(0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: progressColor.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              // Percentage text
              if (showPercentage)
                Positioned.fill(
                  child: Center(
                    child: Text(
                      '${(value * 100).toInt()}%',
                      style: percentageTextStyle ??
                          TextStyle(
                            color: value > 0.5 ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: height * 0.6,
                          ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}