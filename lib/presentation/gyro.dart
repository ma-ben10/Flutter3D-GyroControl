import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phone_motion_simulator/business_logic/blocs/modelBloc.dart';
import 'package:phone_motion_simulator/business_logic/states/modelState.dart';
import 'package:phone_motion_simulator/data/data_providers/gyroscopeApi.dart';
import 'package:phone_motion_simulator/data/models/gyroscope.dart';

import '../business_logic/events/modelEvents.dart';

class GyroScopeTesting extends StatefulWidget {
  const GyroScopeTesting({super.key});

  @override
  State<GyroScopeTesting> createState() => _GyroScopeTestingState();
}

class _GyroScopeTestingState extends State<GyroScopeTesting> {
  late GyroscopeApi gyroscopeApi;
  String holder = "";

  @override
  void initState() {
    super.initState();
    gyroscopeApi = GyroscopeApi();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ModelBloc modelBloc = ModelBloc();
    return BlocProvider(
        create: (context) => modelBloc,
        child: Scaffold(
          body: Stack(fit: StackFit.expand, children: [
            Image.asset(
              "assets/space.jpg",
              fit: BoxFit.fill,
            ),
            Center(
              child: StreamBuilder<Gyroscope>(
                  stream: gyroscopeApi.fetchGyroInfo(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Gyroscope> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.white,
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Failed to get device position coordinates",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ubuntu(
                            textStyle: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.red)),
                      );
                    } else if (snapshot.hasData) {
                      modelBloc.add(Animate3DModel(
                          x: snapshot.data!.x,
                          y: snapshot.data!.y,
                          z: snapshot.data!.z,
                          timestamp: snapshot.data!.timeStamp));
                      return BlocBuilder<ModelBloc, ModelState>(
                          bloc: modelBloc,
                          builder: (context, state) {
                            if (state is InitialModelState) {
                              return Center(
                                  child: Text('${state.initMessage}'));
                            } else if (state is ModelLoading) {
                              return Center(
                                child: state.circularProgressIndicator,
                              );
                            } else if (state is ModelError) {
                              return Center(
                                child: state.errorText,
                              );
                            } else {
                              final initial = state as ModelMoving;
                              return Center(
                                child: initial.astronaut,
                              );
                            }
                          });
                    } else
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.black87),
                      );
                  }),
            )
          ]),
        ));
  }
}
