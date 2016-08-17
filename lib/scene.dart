part of game;

class Scene {

  List<GameObject> gameObjects = [];
  bool inputEnabled = true;
  String backgroundColor;
  StreamController _inputUpController = new StreamController();
  Point origin;

  Stream get onInputUp => _inputUpController.stream;

  Scene(int x, int y, [this.backgroundColor = 'rgba(0, 0, 0, 1)']) {
    origin = new Point(x, y);
  }

  handleInputUp(Point offset) {

    GameObject target;
    if (gameObjects.isNotEmpty) {
      target = gameObjects.lastWhere(
          (obj) => obj.inputEnabled && CollisionDetector.hasCollided(offset, obj),
          orElse: () => null);
    }

    if (target != null) {
      target.handleInputUp(offset);
    } else {
      if (_inputUpController.hasListener && inputEnabled)
        _inputUpController.add(offset);
    }

  }

}
