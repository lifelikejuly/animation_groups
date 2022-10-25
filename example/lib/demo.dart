import 'dart:math';

import 'package:animation_groups/animations.dart';
import 'package:flutter/material.dart';

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({Key? key}) : super(key: key);

  @override
  State<AnimationDemo> createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> {
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
      body:  Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: AnimationGroupWidget(
              animationDriver: animationDriver,
              animationGroups: [
                TransitionAnimationGroup(parts: [
                  AnimationPart(moment: 0, x: 0, y: 0),
                  AnimationPart(moment: 1000, x: 100, y: 100,curve: Curves.easeIn),
                  AnimationPart(moment: 2000, x: 100, y: 200,curve: Curves.easeIn),
                  AnimationPart(moment: 3000, x: 200, y: 200),
                  AnimationPart(moment: 4000, x: 300, y: 300),
                ]),

                // TransitionAnimationGroup(parts: [
                //   AnimationPart(moment: 5000, x: 300, y: 300),
                //   AnimationPart(moment: 6000, x: 200, y: 200),
                // ]),

                // ScaleAnimationGroup(parts: [
                //   AnimationPart(moment: 1000, x: 1.0, y: 1.0,z: 1.0),
                //   AnimationPart(moment: 2000, x: 1.5, y: 1.5,z: 1.0,curve: Curves.easeIn),
                //   AnimationPart(moment: 3000, x: 1.0, y: 1.0,z: 1.0),
                // ]),
                //
                // ScaleAnimationGroup(parts: [
                //   AnimationPart(moment: 4000, x: 1.0, y: 1.0,z: 1.0,curve: Curves.bounceIn),
                //   AnimationPart(moment: 5000, x: 2.0, y: 2.0,z: 1.0),
                // ]),

                RotationAnimationGroup(
                    parts: [
                      AnimationPart(moment: 4000, x: 0, y: 0,z: 0,),
                      AnimationPart(moment: 5000, x: 0, y: 0,z: pi,),
                    ]
                ),
              ],
              child: Container(
                child: Text("xxxxx"),
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
