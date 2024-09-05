import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:phone_motion_simulator/business_logic/events/modelEvents.dart';
import 'package:phone_motion_simulator/business_logic/states/modelState.dart';

class ModelBloc extends Bloc<ModelEvents, ModelState> {
  ModelMoving modelMoving = ModelMoving();
  double theta = 0;
  double phi = 0;

  Map<String, double> fromAngularVelocityToSpherical(
      double x, double y, double z, int timestamp) {
    Map<String, double> spherical = {"theta": 20, "phi": 20, "radius": 1000};
    double deltatheta = y * timestamp;
    double deltaphi = x * timestamp;
    print("Angulare volecity over X axe : $x");
    print("Angulare volecity over Y axe : $y");
    print("Angulare volecity over Z axe : $z");
    theta += deltatheta;
    phi += deltaphi;

    ///normalizing the angles:

    theta = theta.clamp(-180, 180);
    phi = phi.clamp(0, 180);

    spherical["theta"] = theta;
    spherical["phi"] = phi;
    spherical["radius"] = 1000;
    return spherical;
  }

  ModelBloc() : super(InitialModelState()) {
    on<Animate3DModel>((event, emit) {
      emit(ModelLoading());
      try {
        Map<String, double> coordinates = fromAngularVelocityToSpherical(
            event.x, event.y, event.z, event.timestamp);
        modelMoving.controller.setCameraOrbit(
            coordinates["theta"]!, coordinates["phi"]!, coordinates["radius"]!);
        emit(modelMoving);
      } catch (e) {
        emit(ModelError(errorMessage: "$e"));
      }
    });
  }
}
