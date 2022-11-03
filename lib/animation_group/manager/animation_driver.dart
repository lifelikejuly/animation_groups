import 'package:vector_math/vector_math_64.dart';


typedef AnimationListener = Function(Matrix4 matrix4);


///
class AnimationDriver {
  double? _from;
  bool _isInitReverseDriver = false;
  bool _isInitForwardDriver = false;
  bool _isReverse = false;
  bool isRepeat = false;
  final List<AnimationListener> _listenerList = List.empty(growable: true);

  Function? reverseFunc;
  Function? forwardFunc;
  Function? resetFunc;

  double get from => _from ?? 0.0;

  bool get isInitReverseDriver => _isInitReverseDriver;

  bool get isInitForwardDriver => _isInitForwardDriver;

  bool get isReverse => _isReverse;



  AnimationDriver();

  void init() {
    if (_isInitReverseDriver) {
      _isInitReverseDriver = false;
      if (reverseFunc != null) reverseFunc!();
    } else if (_isInitForwardDriver) {
      _isInitForwardDriver = false;
      if (forwardFunc != null) forwardFunc!();
    }
  }

  void reverse({double from = 1.0}) {
    _isReverse = true;
    _from = from;
    if (reverseFunc != null) {
      reverseFunc!();
    } else {
      _isInitReverseDriver = true;
    }
  }

  void forward({double from = 0.0}) {
    _isReverse = false;
    _from = from;
    if (forwardFunc != null) {
      forwardFunc!();
    } else {
      _isInitForwardDriver = true;
    }
  }

  void reset() {
    if (resetFunc != null) {
      resetFunc!();
    }
  }

  void inputCurrentMatrixValue(Matrix4 matrix4) {
    for(AnimationListener listener in _listenerList){
      listener(matrix4);
    }
  }

  void addListener(AnimationListener listener){
    if(!_listenerList.contains(listener)) _listenerList.add(listener);
  }
  void removeListener(AnimationListener listener){
     _listenerList.remove(listener);
  }
}
