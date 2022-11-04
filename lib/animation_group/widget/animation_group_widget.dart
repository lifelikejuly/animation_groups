import 'package:flutter/widgets.dart';

import '../parameter/animation_group.dart';
import '../manager/animation_manager.dart';
import '../manager/animation_driver.dart';

/// Flutter widget that can easy create animationGroups.
///
/// [child] is need do animation widget.
/// [animationGroups] is all animation.
/// [animationDriver] like animationController,can do forward or reverse animation.
class AnimationGroupWidget extends StatefulWidget {
  final Widget child;
  final List<AbsAnimationGroup> animationGroups;
  final AnimationDriver animationDriver;

  const AnimationGroupWidget({
    super.key,
    required this.child,
    required this.animationGroups,
    required this.animationDriver,
  });

  @override
  State<AnimationGroupWidget> createState() => _AnimationGroupWidgetState();
}

class _AnimationGroupWidgetState extends State<AnimationGroupWidget>
    with TickerProviderStateMixin {
  AnimationDriver get animationDriver => widget.animationDriver;
  late AnimationController _animationController;
  late AnimationManager _animationManager;
  late VoidCallback voidCallback;

  double _getMilliseconds() {
    double allTime = _animationController.duration?.inMilliseconds.toDouble() ??
        0 / Duration.microsecondsPerMillisecond;
    return allTime * _animationController.value;
  }

  @override
  void initState() {
    super.initState();

    _animationManager = AnimationManager(widget.animationGroups);
    _animationController = AnimationController(vsync: this);
    _animationController.duration = _animationManager.duration;
    animationDriver.reverseFunc = () {
      _animationManager.isReverse(true);
      _animationController.reverse(from: animationDriver.from);
    };

    animationDriver.forwardFunc = () {
      _animationManager.isReverse(false);
      _animationController.forward(from: animationDriver.from);
    };
    animationDriver.resetFunc = () {
      _animationController.reset();
      _animationManager.reset();
    };
    voidCallback = (){
      double value = _animationController.value;
      if(value == 1.0 && !animationDriver.isReverse){
        if (animationDriver.isRepeat) {
          animationDriver.forwardFunc!();
        }
      }else if(value == 0.0 && animationDriver.isReverse){
        if (animationDriver.isRepeat) {
          animationDriver.reverseFunc!();
        }
      }
    };
    _animationController.addListener(voidCallback);
    animationDriver.init();
  }

  @override
  void didUpdateWidget(covariant AnimationGroupWidget oldWidget) {
    if(oldWidget.animationGroups != widget.animationGroups){
      _animationManager = AnimationManager(widget.animationGroups);
      _animationController = AnimationController(vsync: this);
      _animationController.duration = _animationManager.duration;
    }
  }

  @override
  void dispose() {
    _animationController.removeListener(voidCallback);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, child) {
        Matrix4 matrix4 = _animationManager.calculateMatrix(_getMilliseconds());
        double opacity =  _animationManager.calculateOpacity(_getMilliseconds());
        animationDriver.inputCurrentMatrixValue(matrix4);
        return Opacity(
          opacity: opacity,
          child: Transform(
            transform: matrix4,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
    );
  }
}
