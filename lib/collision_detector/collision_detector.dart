library collision_detector;

import 'dart:math' as math;
import 'dart:mirrors';
import '../game.dart';

part 'util.dart';

class CollisionDetector {

  static Symbol _resolveDetectionMethod(var x, var y) {

    ClassMirror mirror = reflectClass(CollisionDetector);
    for (Symbol method in mirror.staticMembers.keys) {

      List<ParameterMirror> parameters = mirror.staticMembers[method].parameters;

      if (parameters.length != 2)
        continue;

      if (parameters[0].type.hasReflectedType &&
          x.runtimeType == parameters[0].type.reflectedType &&
          parameters[1].type.hasReflectedType &&
          y.runtimeType == parameters[1].type.reflectedType)
        return method;

    }

    return null;

  }

  static bool hasCollided(var x, var y) {
    Symbol method = _resolveDetectionMethod(x, y);
    if (method == null) return false;
    return reflectClass(CollisionDetector).invoke(method, [x, y]).reflectee;
  }

  static bool hasDetectionMethod(var x, var y) =>
    _resolveDetectionMethod(x, y) != null;

  static bool pointRectangle(math.Point point, Rectangle rectangle) =>
    inRange(point.x, rectangle.position.x, rectangle.position.x + rectangle.width) &&
    inRange(point.y, rectangle.position.y, rectangle.position.y + rectangle.height);

  static bool rectanglePoint(Rectangle rectangle, math.Point point) =>
    pointRectangle(point, rectangle);

  static bool rectangleRectangle(Rectangle rect1, Rectangle rect2) =>
    rect1.position.x < rect2.position.x + rect2.width &&
    rect1.position.x + rect1.width > rect2.position.x &&
    rect1.position.y < rect2.position.y + rect2.height &&
    rect1.height + rect1.position.y > rect2.position.y;

}
