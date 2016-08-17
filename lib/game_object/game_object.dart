part of game;

class GameObject {

  bool inputEnabled = true;
  Point position;
  String color = '#ffffff';
  StreamController _inputUpController = new StreamController();
  Map<GameObject, StreamController> _collisionObservers = {};
  Map<GameObject, StreamController> _separationObservers = {};
  List<GameObject> _currentCollisions = [];

  Stream get onInputUp => _inputUpController.stream;

  GameObject(x, y) {
    position = new Point(x, y);
  }

  StreamController _createObserver(Map observerMap, GameObject object) {

    if (!CollisionDetector.hasDetectionMethod(this, object)) {
      throw new Exception('No collision detection method found for types: ${this.runtimeType} and ${object.runtimeType}');
    }

    if (!observerMap.keys.contains(object)) {

      StreamController controller;
      controller =  new StreamController.broadcast(onCancel: () {
        if (!controller.hasListener) {
          controller.close();
          observerMap.remove(object);
        }
      });

      observerMap[object] = controller;
      return controller;

    } else {
      return observerMap[object];
    }

  }

  void detectCollisions() {

    List collided = [];
    List separated = [];

    for (GameObject object in _collisionObservers.keys) {
      if (CollisionDetector.hasCollided(this, object))
        collided.add(object);
      else
        separated.add(object);
    }

    for (GameObject object in _separationObservers.keys) {
      if (!CollisionDetector.hasCollided(this, object))
        separated.add(object);
      else
        collided.add(object);
    }

    for (GameObject object in separated) {
      if (_currentCollisions.contains(object)) {

        if (_separationObservers.containsKey(object) &&
            !_separationObservers[object].hasListener) {
          _separationObservers[object].close();
        } else if (_separationObservers.containsKey(object)) {
          _separationObservers[object].add(null);
        }

        _currentCollisions.remove(object);

      }
    }

    for (GameObject object in collided) {
      if (!_currentCollisions.contains(object)) {

        if (_collisionObservers.containsKey(object) &&
            !_collisionObservers[object].hasListener) {
          _collisionObservers[object].close();
        } else if (_collisionObservers.containsKey(object)) {
          _collisionObservers[object].add(null);
        }

        _currentCollisions.add(object);

      }
    }

  }

  void draw(CanvasRenderingContext2D context, Point sceneOffset) {}

  void handleInputUp(Point sceneOffset) {
    if (_inputUpController.hasListener)
      _inputUpController.add(sceneOffset - position);
  }

  Stream onCollide(GameObject object) =>
    _createObserver(_collisionObservers, object).stream;

  Stream onSeparate(GameObject object) =>
    _createObserver(_separationObservers, object).stream;

}
