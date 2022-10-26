import 'dart:math';

import 'package:vector_math/vector_math_64.dart';


import '../parameter/animation_group.dart';

class AnimationManager {
  List<AbsAnimationGroup> animationGroups = List.empty(growable: true);
  List<AbsAnimationGroup> opacityGroups = List.empty(growable: true);
  late Duration duration;
  Matrix4 matrix4 = Matrix4.identity();

  AnimationManager(List<AbsAnimationGroup> groups) {
    int maxDuration = 0;
    for (AbsAnimationGroup group in groups) {
      maxDuration = max(group.duration, maxDuration);
      if(group is OpacityAnimationGroup){
        opacityGroups.add(group);
      }else{
        animationGroups.add(group);
      }
    }
    duration = Duration(milliseconds: maxDuration);
  }

  Matrix4 calculateMatrix(double millTime) {
    Matrix4 outPutMatrix4 = Matrix4.identity();
    for (AbsAnimationGroup group in animationGroups) {
      outPutMatrix4 = group.getCurrentMatrix4(outPutMatrix4, millTime);
    }
    return outPutMatrix4;
  }

  double calculateOpacity(double millTime) {
    Matrix4 outPutMatrix4 = Matrix4.identity();
    for (AbsAnimationGroup group in opacityGroups) {
      outPutMatrix4 = group.getCurrentMatrix4(outPutMatrix4, millTime);
    }
    return outPutMatrix4.entry(0, 0);
  }

  void isReverse(bool reverse) {
    for (AbsAnimationGroup group in animationGroups) {
      group.setReverse(reverse);
    }
    for (AbsAnimationGroup group in opacityGroups) {
      group.setReverse(reverse);
    }
  }


  void reset() {
    for (AbsAnimationGroup group in animationGroups) {
      group.reset();
    }

    for (AbsAnimationGroup group in opacityGroups) {
      group.reset();
    }
  }
}
