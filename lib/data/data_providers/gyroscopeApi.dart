import 'dart:async';
import 'dart:math';
import 'package:phone_motion_simulator/data/models/gyroscope.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../kalmanFilter/kalmanFilter.dart';

class GyroscopeApi {
  double filtredX = 0;
  double filtredY = 0;
  double filtredZ = 0;
  int lastTimeUpdate = 0;
  int currentTime = 0;
  Gyroscope gyroscope =
      Gyroscope(x: 0, y: 0, z: 0, timeStamp: DateTime.now().second);
  StreamSubscription<GyroscopeEvent>? gyroscopestreamsubscription;
  Duration sensorInterval = SensorInterval.normalInterval;

  Stream<Gyroscope> fetchGyroInfo() async* {
    final StreamController<Gyroscope> controller = StreamController();
    gyroscopestreamsubscription =
        gyroscopeEventStream(samplingPeriod: sensorInterval).listen(
            (GyroscopeEvent event) {
      if (event.x.abs() >= 0.2 ||
          event.y.abs() >= 0.2 ||
          event.z.abs() >= 0.2) {
        filtredX = filter(event.x, 3);
        filtredY = filter(event.y, 3);
        filtredZ = filter(event.z, 3);
        gyroscope.x = filtredX;
        gyroscope.y = filtredY;
        gyroscope.z = filtredZ;
        currentTime = DateTime.now().second;
        gyroscope.timeStamp = currentTime;
        controller.add(gyroscope);
      }
    }, onError: (e) {
      controller
          .addError(Exception('failed to fetch the device gyroscope sensore'));
    }, cancelOnError: true);
    yield* controller.stream;
    await controller.close();
  }

  double filter(double newValue, int windowSize) {
    final List<double> _values = [];
    _values.add(newValue);
    if (_values.length > windowSize) {
      _values.removeAt(0);
    }
    return _values.reduce((a, b) => a + b) /
        _values.length; // Calculate the average
  }
}
