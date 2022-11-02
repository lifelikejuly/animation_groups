import 'dart:math';

import 'package:animation_groups/animations.dart';
import 'package:flutter/material.dart';

import 'package:vector_math/vector_math_64.dart' hide Colors;

class ExpandAnimationDemo extends StatefulWidget {
  const ExpandAnimationDemo({Key? key}) : super(key: key);

  @override
  State<ExpandAnimationDemo> createState() => _AnimationDemoState2();
}

class _AnimationDemoState2 extends State<ExpandAnimationDemo>
    with TickerProviderStateMixin {
  AnimationDriver animationDriver = AnimationDriver();

  bool _repeat = false;

  @override
  void initState() {
    super.initState();
    // animationDriver.reverse(from: 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("demo"),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 200,
            left: 200,
            child: AnimationGroupWidget(
              animationDriver: animationDriver,
              animationGroups: [

                CircleTransitionAnimationGroup(parts: [
                  AnimationPart(moment: 0),
                  AnimationPart(moment: 5000),
                ]),

                // XTransitionAnimationGroup(parts: [
                //   AnimationPart(moment: 0,x: 100, y: 100),
                //   AnimationPart(
                //       moment: 1000, x: 300, y: 400, curve: Curves.easeIn),
                // ])
              ],
              child: Container(
                child: const Text("xxxxx"),
                width: 20,
                height: 20,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        animationDriver.forward(from: 0);
                      },
                      child: const Text("toForward")),
                  TextButton(
                      onPressed: () {
                        animationDriver.reverse(from: 1.0);
                      },
                      child: const Text("toReverse")),
                  Switch(
                      value: _repeat,
                      onChanged: (newValue) {
                        _repeat = !_repeat;
                        animationDriver.isRepeat = _repeat;
                        setState(() {});
                      }),
                ],
              )),
        ],
      ),
    );
  }
}

/// 画圆公式
/// https://xiaochaowei.com/2022/07/20/BezierCurveFittedAnyCurve/
///
///
class CircleTransitionAnimationGroup extends AnimationGroup {
  CircleTransitionAnimationGroup({required List<AnimationPart> parts})
      : super(parts: parts);

  double h = 4 / 3 * ((1 - cos(2 * pi / 2)) / sin(2 * pi / 2));

  @override
  String animationType() {
    return "CircleTransitionAnimationGroup";
  }

  @override
  Vector3 calculatePartXYZ(double t, AnimationPart right, AnimationPart left) {
    int moment = right.moment - left.moment;
    double per = (t - left.moment) / moment.toDouble();

    // double x0 = left.xyz.x;
    // double y0 = left.xyz.y;
    //
    // double x1 = 100 / 4 - x0;
    // double y1 = y0 - 100;
    //
    // double x2 = right.xyz.x;
    // double y2 = right.xyz.y;

    double angle = 4 * pi * per;

    double h = 4 / 3 * ((1 - cos(angle / 2)) / sin(angle / 2));

    double size = 100;

    double aX = cos(angle);
    double aY = sin(angle);

    double bX = cos(angle) + h * sin(angle);
    double bY = sin(angle) - h * cos(angle);

    double cX = 1;
    double cY = h;

    double dX = 1;
    double dY = 0;

    aX *= size;
    aY *= size;

    bX *= size;
    bY *= size;

    cX *= size;
    cY *= size;

    dX *= size;
    dY *= size;

    double x = aX * pow(1 - per, 3) +
        bX * 3 * pow(1 - per, 2) * per +
        cX * 3 * (1 - per) * pow(per, 2) +
        dX * pow(per, 3);
    double y = aY * pow(1 - per, 3) +
        bY * 3 * pow(1 - per, 2) * per +
        cY * 3 * (1 - per) * pow(per, 2) +
        dY * pow(per, 3);

    print("<> x $x y $y");
    // double x = pow(1 - per, 2) * x0 + 2 * per * (1 - per) * x1 + pow(per, 2) * x2;
    // double y = pow(1 - per, 2) * y0 + 2 * per * (1 - per) * y1 + pow(per, 2) * y2;

    return Vector3(x, y, 0.0);
  }

  @override
  Vector3 initXYZ() {
    return Vector3.all(0.0);
  }

  @override
  Matrix4 last(Matrix4 matrix4, Vector3 xyz) {
    return matrix4..setTranslation(xyz);
  }

  @override
  Matrix4 calculateMatrix4(Matrix4 matrix4, Vector3 xyz) {
    return matrix4..setTranslation(xyz);
  }
}

class XTransitionAnimationGroup extends AnimationGroup {
  XTransitionAnimationGroup({required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  String animationType() {
    return "XTransitionAnimationGroup";
  }

  @override
  Vector3 calculatePartXYZ(double t, AnimationPart right, AnimationPart left) {
    int moment = right.moment - left.moment;
    double per = (t - left.moment) / moment.toDouble();

    double x0 = left.xyz.x;
    double y0 = left.xyz.y;

    double x1 = x0 - 250;
    double y1 = y0 - 100;

    double x2 = right.xyz.x;
    double y2 = right.xyz.y;

    double x =
        pow(1 - per, 2) * x0 + 2 * per * (1 - per) * x1 + pow(per, 2) * x2;
    double y =
        pow(1 - per, 2) * y0 + 2 * per * (1 - per) * y1 + pow(per, 2) * y2;
    return Vector3(x, y, 0.0);
  }

  @override
  Vector3 initXYZ() {
    return Vector3.all(0.0);
  }

  @override
  Matrix4 last(Matrix4 matrix4, Vector3 xyz) {
    return matrix4..setTranslation(xyz);
  }

  @override
  Matrix4 calculateMatrix4(Matrix4 matrix4, Vector3 xyz) {
    return matrix4..setTranslation(xyz);
  }
}
