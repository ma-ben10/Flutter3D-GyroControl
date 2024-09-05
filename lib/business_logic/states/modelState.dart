import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class ModelState {
  Flutter3DController controller = Flutter3DController();
}

class InitialModelState extends ModelState {
  String initMessage = "Laoding";
}

class ModelLoading extends ModelState {
  final CircularProgressIndicator circularProgressIndicator =
      const CircularProgressIndicator(
    color: Colors.white,
  );
}

class ModelError extends ModelState {
  String errorMessage;
  late Text errorText;

  ModelError({required this.errorMessage}) {
    errorText = Text(
      errorMessage,
      textAlign: TextAlign.center,
      style: GoogleFonts.ubuntu(
          textStyle: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.red)),
    );
  }
}

class ModelMoving extends ModelState {
  late Flutter3DViewer astronaut;

  ModelMoving() {
    astronaut = Flutter3DViewer(
        progressBarColor: Colors.black87,
        controller: controller,
        src: "assets/Astronaut.glb");
  }
}
