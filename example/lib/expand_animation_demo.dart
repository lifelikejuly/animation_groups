import 'dart:math';

import 'package:animation_groups/animations.dart';
import 'package:flutter/material.dart';

import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'animation_canvas_painter.dart';

class ExpandAnimationDemo extends StatefulWidget {
  const ExpandAnimationDemo({Key? key}) : super(key: key);

  @override
  State<ExpandAnimationDemo> createState() => _AnimationDemoState2();
}

class _AnimationDemoState2 extends State<ExpandAnimationDemo>
    with TickerProviderStateMixin {
  AnimationDriver animationDriver = AnimationDriver();

  bool _repeat = false;

  final List<AbsAnimationGroup> animationGroupA = [
    WaveAnimationGroup(parts: [
      AnimationPart(moment: 0, x: 200, y: 300),
      AnimationPart(moment: 5000, x: 300),
    ]),
  ];

  final List<AbsAnimationGroup> animationGroupB = [
    CircleTransitionAnimationGroup(parts: [
      AnimationPart(moment: 0, x: 200, y: 200),
      AnimationPart(moment: 5000, x: 200, y: 200),
    ]),
  ];

  late List<AbsAnimationGroup> selected;

  int _radioGroupA = 0;

  void _handleRadioValueChanged(int? value) {
    switch(value){
      case 0:
        selected = animationGroupA;
        break;
      case 1:
        selected = animationGroupB;
        break;
    }
    setState(() {
      _radioGroupA = value ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    // animationDriver.reverse(from: 1.0);
    selected = animationGroupA;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("demo"),
      ),
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, child: AnimationCanvas(animationDriver)),
          Positioned(
            top: 0,
            left: 0,
            child: AnimationGroupWidget(
              animationDriver: animationDriver,
              animationGroups: selected,
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
              child: Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        // tileColor: Colors.white,
                        groupValue: _radioGroupA,
                        onChanged: _handleRadioValueChanged,
                        // title:Text('Option A') ,
                        // selected: _radioGroupA == 0,
                      ),
                      Radio(
                        value: 1,
                        // tileColor: Colors.white,
                        groupValue: _radioGroupA,
                        onChanged: _handleRadioValueChanged,
                        // title:Text('Option B') ,
                        // selected: _radioGroupA == 1,
                      ),
                    ],
                  ),
                  Row(
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
                  )
                ],
              )),
        ],
      ),
    );
  }
}

class WaveAnimationGroup extends AnimationGroup {
  WaveAnimationGroup({required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  String animationType() {
    return "WaveAnimationGroup";
  }

  @override
  Matrix4 calculateMatrix4(Matrix4 matrix4, Vector3 xyz) {
    return matrix4..setTranslation(xyz);
  }

  @override
  Vector3 calculatePartXYZ(double t, AnimationPart right, AnimationPart left) {
    int moment = right.moment - left.moment;
    double per = (t - left.moment) / moment.toDouble();

    double angle = 2 * pi * per;
    return Vector3(
        left.xyz.x + (right.xyz.x - left.xyz.x) * left.curve.transform(per),
        left.xyz.y +
            (right.xyz.y - left.xyz.y) * left.curve.transform(per) +
            sin(angle) * 100,
        0.0);
  }

  @override
  Vector3 initXYZ() {
    return Vector3.all(0.0);
  }

  @override
  Matrix4 last(Matrix4 matrix4, Vector3 xyz) {
    return matrix4..setTranslation(xyz);
  }
}

/// 画圆公式
/// https://xiaochaowei.com/2022/07/20/BezierCurveFittedAnyCurve/
///
/// https://spencermortensen.com/articles/bezier-circle/
///
/// a=1.00005519, b=0.55342686, and c=0.99873585
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
    double allPer = (t - left.moment) / moment.toDouble();

    // print("<> per $per");
    //
    // double angle = pi * per;
    //
    // double h = 4 / 3 * ((1 - cos(angle / 2)) / sin(angle / 2));
    // // 可能会为空
    // if (h.isNaN) h = 0;
    // // 半径
    // double size = 100;
    //
    // double aX = cos(angle);
    // double aY = sin(angle);
    //
    // double bX = cos(angle) + h * sin(angle);
    // double bY = sin(angle) - h * cos(angle);
    //
    // double cX = 1;
    // double cY = h;
    //
    // double dX = 1;
    // double dY = 0;
    //
    // aX *= size;
    // aY *= size;
    //
    // bX *= size;
    // bY *= size;
    //
    // cX *= size;
    // cY *= size;
    //
    // dX *= size;
    // dY *= size;

    // cX = (angle < pi || angle > 3 * pi )? cX : -cX;
    // cY = (angle >= 0  &&  angle > 2 * pi )? cY : -cY;

    // double x = aX * pow(1 - per, 3) +
    //     bX * 3 * pow(1 - per, 2) * per +
    //     cX * 3 * (1 - per) * pow(per, 2) +
    //     dX * pow(per, 3);
    // double y = aY * pow(1 - per, 3) +
    //     bY * 3 * pow(1 - per, 2) * per +
    //     cY * 3 * (1 - per) * pow(per, 2) +
    //     dY * pow(per, 3);
    // if(x.isNaN) x = size;
    // if(y.isNaN) y = 0;
    // print(
    //     "<> angle $angle sin(angle / 2)  ${sin(angle / 2)} h $h aX $aX aY $aY bx $bX bY $bY cX $cX cY $cY dX $dX dY $dY");
    // double x = pow(1 - per, 2) * x0 + 2 * per * (1 - per) * x1 + pow(per, 2) * x2;
    // double y = pow(1 - per, 2) * y0 + 2 * per * (1 - per) * y1 + pow(per, 2) * y2;

    // p0( 0 ,a)
    // p1( b ,c)
    // p2( c ,b)
    // p3( a ,0)

    // p0( 0 ,a)
    // p1( -b ,c)
    // p2( -c ,b)
    // p3( -a ,0)

    // p0( 0 ,-a)
    // p1( b ,-c)
    // p2( c ,-b)
    // p3( a ,0)

    const double a = 1.00005519 * 100;
    const double b = 0.55342686 * 100;
    const double c = 0.99873585 * 100;

    double per = 0;
    double xPN = 1;
    double yPN = 1;
    if (allPer <= 0.25) {
      per = allPer * 4.0;
    } else if (allPer <= 0.5) {
      per = 1 - (allPer - 0.25) * 4.0;
      yPN = -1;
    } else if (allPer <= 0.75) {
      per = (allPer - 0.5) * 4.0;
      xPN = -1;
      yPN = -1;
    } else {
      per = 1 - (allPer - 0.75) * 4.0;
      xPN = -1;
    }

    // per *= 2;
    double x = xPN *
        (3 * b * pow((1 - per), 2) * per + // p1
            3 * c * (1 - per) * pow(per, 2) + // p2
            a * pow(per, 3)); // p3

    double y = yPN *
        (a * pow(1 - per, 3) + // p0
            3 * c * pow(1 - per, 2) * per + // p1
            3 * b * (1 - per) * pow(per, 2)); // p2

    // x = -x;
    // y = -y;

    x += left.xyz.x + (right.xyz.x - left.xyz.x) * left.curve.transform(per);
    y += left.xyz.y + (right.xyz.y - left.xyz.y) * left.curve.transform(per);

    // print("<> x- y $x x $y ");

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

/// 贝塞尔曲线
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
