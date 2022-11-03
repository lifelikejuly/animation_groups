import 'dart:math';

import 'package:animation_groups/animations.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'animation_canvas_painter.dart';

class BaseAnimationDemo extends StatefulWidget {
  const BaseAnimationDemo({Key? key}) : super(key: key);

  @override
  State<BaseAnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<BaseAnimationDemo> {
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
          Positioned(top: 200, left: 200, child: AnimationCanvas(animationDriver)),
          Positioned(
            top: 0,
            left: 0,
            child: AnimationGroupWidget(
              animationDriver: animationDriver,
              animationGroups: [
                RotationAnimationGroup(parts: [
                  AnimationPart(moment: 0),
                  AnimationPart(moment: 2000, x: pi, z: pi),
                  // AnimationPart(moment: 2000, x: 2 * pi),
                ]),
                TransitionAnimationGroup(parts: [
                  AnimationPart(moment: 0, x: 300, y: 300),
                  AnimationPart.add(
                      moment: 1000, x: -200, y: -200, curve: Curves.easeIn),
                ])
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
