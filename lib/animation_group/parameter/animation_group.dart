import 'package:vector_math/vector_math_64.dart';
import 'animation_part.dart';

// 动画组
abstract class AbsAnimationGroup {
  late List<AnimationPart> _parts;
  late Vector3 _currentXYZ;
  late int _duration;
  late int _startMoment;
  late int _endMoment;
  int _step = 0;
  bool _isReverse = false;

  List<AnimationPart> get parts => _parts;

  int get duration => _duration;

  Vector3 get lastXYZ => _currentXYZ;

  Matrix4 _last(Matrix4 matrix4);

  Matrix4 _calculate(Matrix4 matrix4, double t);

  Vector3 _initXYZ();

  AbsAnimationGroup({required List<AnimationPart> parts})
      : assert((parts?.isNotEmpty ?? false) && parts.length > 1,
            "AnimationPart list must be not null and size > 1") {
    _currentXYZ = _initXYZ();
    //动画序列调整
    _parts = parts;
    _parts.sort((a, b) {
      return a.moment.compareTo(b.moment);
    });
    // 第一个起步值是否存在

    // 初始化值设置
    AnimationPart tempPart = AnimationPart(moment: 0);
    tempPart.xyz = _currentXYZ;
    Iterator<AnimationPart> iterator = _parts.iterator;
    while (iterator.moveNext()) {
      AnimationPart animationPart = iterator.current;
      if (animationPart.isAddPart) {
        animationPart.xyz = tempPart.xyz + animationPart.xyzAdd;
      } else {
        Vector3? vector3 = animationPart.xyz;
        if (vector3!.x == double.infinity) vector3.x = tempPart.xyz!.x;
        if (vector3!.y == double.infinity) vector3.y = tempPart.xyz!.y;
        if (vector3!.z == double.infinity) vector3.z = tempPart.xyz!.z;
      }
      tempPart = animationPart;
    }
    //计算得到时长
    _duration = _parts.last.moment;
    _startMoment = _parts.first.moment;
    _endMoment = _duration;
  }

  Vector3 _getCurrentValue(double t) {
    if (_step >= parts.length || t < _startMoment) return _currentXYZ;
    AnimationPart currentPart = parts[_step];
    Vector3? value;
    if (_isReverse) {
      value = _reverse(currentPart, t);
    } else {
      value = _getForwardValue(currentPart, t);
    }
    if (value != null) {
      _currentXYZ = value;
      return value;
    }
    return _getCurrentValue(t);
  }

  Vector3? _getForwardValue(AnimationPart currentPart, double t) {
    AnimationPart leftPart;
    AnimationPart rightPart;
    if (currentPart.moment <= t) {
      if (_step + 1 < parts.length) {
        rightPart = parts[_step + 1];
        if (rightPart.moment > t) {
          // 当下一个节点大于当前时间 做计算
          return _calculatePartXYZ(t, rightPart, currentPart);
        }
      } else {
        leftPart = parts[_step - 1];
        return _calculatePartXYZ(t, currentPart, leftPart);
      }
    }
    _step++;
    return null;
  }

  Vector3? _reverse(AnimationPart currentPart, double t) {
    AnimationPart leftPart;
    AnimationPart rightPart;
    if (currentPart.moment >= t) {
      if (_step - 1 >= 0) {
        leftPart = parts[_step - 1];
        if (leftPart.moment < t) {
          // 当下一个节点大于当前时间 做计算
          return _calculatePartXYZ(t, currentPart, leftPart);
        }
      } else {
        rightPart = parts[_step + 1];
        return _calculatePartXYZ(t, rightPart, currentPart);
      }
    }
    _step--;
    return null;
  }

  Vector3 _calculatePartXYZ(double t, AnimationPart right, AnimationPart left) {
    int moment = right.moment - left.moment;
    double per = (t - left.moment) / moment.toDouble();
    return left.xyz + (right.xyz - left.xyz) * left.curve.transform(per);
  }

  // 判断是否在时间范围内
  bool _inTime(double time) {
    return _startMoment <= time && _endMoment >= time;
  }

  // 是否超出时间范围
  bool _overTime(double time) {
    return _endMoment < time;
  }

  Matrix4 getCurrentMatrix4(Matrix4 matrix4, double t) {
    if (_overTime(t)) matrix4 = _last(matrix4);
    if (_inTime(t)) matrix4 = _calculate(matrix4, t);
    return matrix4;
  }

  void reset() {
    _step = 0;
  }

  void setReverse(bool reverse) {
    _isReverse = reverse;
    _step = reverse ? (_parts.length - 1) : 0;
    _currentXYZ =
        reverse ? _getCurrentValue(_endMoment.toDouble()) : Vector3.all(0.0);
  }
}

class TransitionAnimationGroup extends AbsAnimationGroup {
  TransitionAnimationGroup({required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 _calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    return matrix4..setTranslation(xyz);
  }

  @override
  Matrix4 _last(Matrix4 matrix4) {
    return matrix4..setTranslation(_currentXYZ);
  }

  @override
  Vector3 _initXYZ() {
    return Vector3.all(0.0);
  }
}

class ScaleAnimationGroup extends AbsAnimationGroup {
  ScaleAnimationGroup({required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 _calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    return matrix4..scale(xyz);
  }

  @override
  Matrix4 _last(Matrix4 matrix4) {
    return matrix4..scale(_currentXYZ);
  }

  @override
  Vector3 _initXYZ() {
    return Vector3.all(1.0);
  }
}

class RotationAnimationGroup extends AbsAnimationGroup {
  RotationAnimationGroup({required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 _calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    matrix4.rotateX(xyz.x);
    matrix4.rotateY(xyz.y);
    matrix4.rotateZ(xyz.z);
    return matrix4;
  }

  @override
  Matrix4 _last(Matrix4 matrix4) {
    matrix4.rotateX(_currentXYZ.x);
    matrix4.rotateY(_currentXYZ.y);
    matrix4.rotateZ(_currentXYZ.z);
    return matrix4;
  }

  @override
  Vector3 _initXYZ() {
    return Vector3.all(0.0);
  }
}

class OpacityAnimationGroup extends AbsAnimationGroup{
  OpacityAnimationGroup({required List<AnimationPart> parts})
      : super(parts: parts);

  @override
  Matrix4 _calculate(Matrix4 matrix4, double t) {
    Vector3 xyz = _getCurrentValue(t);
    return matrix4..setEntry(0, 0, xyz.x.clamp(0.0, 1.0));
  }

  @override
  Vector3 _initXYZ() {
    return Vector3.all(1.0);
  }

  @override
  Matrix4 _last(Matrix4 matrix4) {
    return matrix4..setEntry(0, 0, _currentXYZ.x);
  }


}
