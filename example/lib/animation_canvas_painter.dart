import 'dart:async';
import 'dart:ui';

import 'package:animation_groups/animations.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class AnimationCanvas extends StatefulWidget {
  final AnimationDriver animationDriver;

  const AnimationCanvas(this.animationDriver, {Key? key}) : super(key: key);

  @override
  State<AnimationCanvas> createState() => _AnimationCanvasState();
}

class _AnimationCanvasState extends State<AnimationCanvas> {
  Matrix4 matrix4 = Matrix4.identity();

  late StreamController<List<Matrix4>> streamController;

  List<Matrix4> points = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    streamController = StreamController();
    widget.animationDriver.addListener((matrix4) {
      // this.matrix4 = matrix4;
      // if(mounted) {
      //   setState(() {});
      // }
      // Vector3 vector3 = matrix4.getTranslation();
      // print("<> vector3 $vector3");
      points.add(matrix4);
      streamController.add(points);
      // setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Matrix4>>(
      stream: streamController.stream,
      initialData: List.empty(),
      builder: (context, data) {
        return CustomPaint(
          // size: MediaQuery.of(context).size,
          painter: AnimationCanvasPainter(points: data.data!),
        );
      },
    );
    // return CustomPaint(
    //   size: MediaQuery.of(context).size,
    //   painter: AnimationCanvasPainter(points: points),
    // );
  }
}

class AnimationCanvasPainter extends CustomPainter {
  // final Matrix4 matrix4;
  final List<Matrix4> points;
  final Color color; // 颜色
  final Paint _paint = Paint()
    ..color = Colors.yellow
    ..strokeWidth = 1
    ..style = PaintingStyle.fill;

  AnimationCanvasPainter({this.color = Colors.redAccent, required this.points})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.restore();
    canvas.drawColor(Colors.black12, BlendMode.src);
    // Vector3 vector3 = matrix4.getTranslation();
    canvas.drawPoints(
        PointMode.points,
        points.map((e) {
          Vector3 vector3 = e.getTranslation();
          return Offset(vector3.x, vector3.y + 100);
        }).toList(),
        _paint);
    canvas.save();
  }

  @override
  bool shouldRepaint(covariant AnimationCanvasPainter oldDelegate) {
    return false;
  }
}
