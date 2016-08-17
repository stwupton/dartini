library game;

import 'dart:async';
import 'dart:html' hide Rectangle;
import 'dart:mirrors';
import 'collision_detector/collision_detector.dart';

part 'camera.dart';
part 'game_object/game_object.dart';
part 'game_object/rectangle.dart';
part 'scene.dart';

class Game {

  Camera camera;
  final CanvasElement canvas;
  double delta;
  int fps = 0;
  num lastFrame = 0;
  bool paused = false;
  Scene scene;
  num _width, _height;
  StreamController _loopController = new StreamController.broadcast();

  void set width(num w) {
    _width = w;
    _resetSize();
  }

  void set height(num h) {
    _height = h;
    _resetSize();
  }

  num get width => _width;
  num get height => _height;

  Stream get onLoop => _loopController.stream;

  Game(this.canvas, this._width, this._height) {
    camera = new Camera(0, 0);
    scene = new Scene(0, 0);
    _resetSize();
    _setListeners();
    window.requestAnimationFrame(_gameLoop);
  }

  void _drawScene() {

    // Draw scene.
    canvas.context2D
      ..fillStyle = scene.backgroundColor
      ..fillRect(0, 0, width, height);

    // Draw all objects in scene.
    scene.gameObjects.forEach((GameObject object) =>
      object.draw(canvas.context2D, canvasOffset(new Point(0, 0))));

  }

  void _gameLoop(num currentFrame) {

    window.requestAnimationFrame(_gameLoop);

    if (paused) return;

    if (lastFrame == 0) {
      lastFrame = currentFrame;
      return;
    }

    // Calucate fps
    delta = currentFrame - lastFrame;
    fps = (delta * 1000).truncate();
    lastFrame = currentFrame;

    if (_loopController.hasListener)
      _loopController.add(null);

    scene.gameObjects.forEach((GameObject object) => object.detectCollisions());

    _drawScene();

  }

  void _resetSize() {
    canvas.context2D.save();
    canvas
      ..width = _width
      ..height = _height;
    canvas.context2D.restore();
    _drawScene();
  }

  Point sceneOffset(Point canvasOffset) =>
    canvasOffset + (camera.position - scene.origin);

  Point canvasOffset(Point sceneOffset) =>
    sceneOffset - (camera.position + scene.origin);

  void _setListeners() {

    canvas.onMouseUp.listen((e) {
      if (paused) return;
      scene.handleInputUp(sceneOffset(e.offset));
    });

  }

}
