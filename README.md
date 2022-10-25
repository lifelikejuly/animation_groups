<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
## AnimationGroup
This is Flutter Customer Animation Library.It can make AnimationGroup to do Animation.

## Features

1. you can input AnimationPart.It is this moment animationInfo.
2. Then Create AnimationDriver to Controller Animation to do.(forward or reserve)
3. Now this Library is easy,maybe more function waiting dev.
4. You can use TransitionAnimation、ScaleAnimation、RotationAnimation

AnimationPart support X Y Z three coordinate and curve.
Many AnimationPart compose to AnimationGroup.

## Usage

Show Usage Demo like this.

```dart

animationDriver.forward(from: 0);
animationDriver.reverse(from: 1.0);
animationDriver.isRepeat = _repeat;

AnimationGroupWidget(
  animationDriver: animationDriver,
  animationGroups: [
    TransitionAnimationGroup(parts: [
      AnimationPart(moment: 0, x: 0, y: 0),
      AnimationPart(moment: 1000, x: 100, y: 100,curve: Curves.easeIn),
      AnimationPart(moment: 2000, x: 100, y: 200,curve: Curves.easeIn),
      AnimationPart(moment: 3000, x: 200, y: 200),
      AnimationPart(moment: 4000, x: 300, y: 300),
    ]),

    ScaleAnimationGroup(parts: [
      AnimationPart(moment: 4000, x: 1.0, y: 1.0,z: 1.0,curve: Curves.bounceIn),
      AnimationPart(moment: 5000, x: 2.0, y: 2.0,z: 1.0),
    ]),

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
```



