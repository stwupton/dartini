part of game;

class Rectangle extends GameObject {

  num height, width;
  String color = '#ffffff';

  Rectangle(x, y, this.width, this.height) : super(x, y);

  void draw(CanvasRenderingContext2D context, Point offset) {
    context
      ..fillStyle = color
      ..fillRect(position.x + offset.x, position.y + offset.y, width, height);
  }

}
