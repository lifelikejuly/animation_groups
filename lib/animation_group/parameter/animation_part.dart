
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

/// [AnimationPart] is moment animation information
/// it hava two constructor to create [AnimationPart.add] or [AnimationPart]
/// [AnimationPart.add] is depends before AnimationPart to do.
/// [AnimationPart] is respect itself moment information.
class AnimationPart {

  int moment;
  Vector3 xyz;
  Vector3 xyzAdd;
  Curve curve;
  late bool _isAddPart = false;

  AnimationPart({
    required this.moment,
    this.curve = Curves.linear,
    double x = double.infinity,
    double y = double.infinity,
    double z = double.infinity,
  })  : xyz = Vector3(x, y, z),
        xyzAdd = Vector3.zero();

  AnimationPart.add({
    required this.moment,
    this.curve = Curves.linear,
    double x = 0,
    double y = 0,
    double z = 0,
  })  : xyzAdd = Vector3(x, y, z),
        xyz = Vector3.zero(),
        _isAddPart = true;

  bool get isAddPart => _isAddPart;

  @override
  String toString() {
    return "moment:$moment xyz:$xyz";
  }
}

extension NVector3 on Vector3 {
  bool isInfinityVector() {
    return x == double.infinity && y == double.infinity && z == double.infinity;
  }
}
