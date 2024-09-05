abstract class ModelEvents {}

class Animate3DModel extends ModelEvents {
  double x;
  double y;
  double z;
  int timestamp;

  Animate3DModel(
      {required this.x,
      required this.y,
      required this.z,
      required this.timestamp});
}
