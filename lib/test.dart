import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class LoadingPainter extends CustomPainter {
  final int itemCount;
  final int currentCount;

  LoadingPainter(this.itemCount, this.currentCount);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xffD9D9D9) // Change color as needed
      ..style = PaintingStyle.fill;

    final double segmentWidth = size.width / itemCount;

    // Draw the filled segments
    for (int i = 0; i < currentCount; i++) {
      final double startX = i * segmentWidth;
      final double endX = (i + 1) * segmentWidth;

      final Rect rect = Rect.fromLTRB(startX, 0, endX, size.height);
      canvas.drawRect(rect, paint);
    }

    // Draw the remaining empty segments
    final Paint emptyPaint = Paint()
      ..color = Colors.white // Change color as needed
      ..style = PaintingStyle.fill;
    for (int i = currentCount; i < itemCount; i++) {
      final double startX = i * segmentWidth;
      final double endX = (i + 1) * segmentWidth;

      final Rect rect = Rect.fromLTRB(startX, 0, endX, size.height);
      canvas.drawRect(rect, emptyPaint);
    }

    // Draw the text showing the current count out of total count
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$currentCount/$itemCount',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final xOffset = (size.width - textPainter.width) / 2;
    final yOffset = (size.height - textPainter.height) / 2;
    textPainter.paint(canvas, Offset(xOffset, yOffset));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class LoadingWidget extends StatelessWidget {
  final int itemCount;
  final int currentCount;

  LoadingWidget(this.itemCount, this.currentCount);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: LoadingPainter(itemCount, currentCount),
      size: Size.infinite,
    );
  }
}
