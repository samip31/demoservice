import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OverlayedLoadingScreen extends StatelessWidget {
  const OverlayedLoadingScreen({
    super.key,
    this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    log("STACKED LOADING CALLED");
    return Stack(
      children: [
        // Blurred background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            color: const Color.fromARGB(209, 0, 0, 0).withOpacity(0.6),
          ),
        ),

        // Loading indicator
        Center(
            child: SpinKitCircle(
          color: color ?? const Color(0xFF86E91A),
        )),
      ],
    );
  }
}
