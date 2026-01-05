import 'package:flutter/material.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

import '../../../core/dimension.dart';
import '../../widgets/custom_network_image.dart';

class ImageDetailsExtraService extends StatefulWidget {
  final String? title;
  final String? token;
  final String? image;
  const ImageDetailsExtraService(
      {super.key, this.title, this.token, this.image});

  @override
  State<ImageDetailsExtraService> createState() =>
      _ImageDetailsExtraServiceState();
}

class _ImageDetailsExtraServiceState extends State<ImageDetailsExtraService>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<Matrix4>? _zoomAnimation;
  late TransformationController _transformationController;
  TapDownDetails? _doubleTapDetails;
  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(() {
        _transformationController.value = _zoomAnimation!.value;
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    final newValue = _transformationController.value.isIdentity()
        ? _applyZoom()
        : _revertZoom();

    _zoomAnimation = Matrix4Tween(
      begin: _transformationController.value,
      end: newValue,
    ).animate(CurveTween(curve: Curves.fastLinearToSlowEaseIn)
        .animate(_animationController));
    _animationController.forward(from: 0);
  }

  Matrix4 _applyZoom() {
    final tapPosition = _doubleTapDetails!.localPosition;
    const translationCorrection = 2 - 1;
    final zoomed = Matrix4.identity()
      ..translate(
        -tapPosition.dx * translationCorrection,
        -tapPosition.dy * translationCorrection,
      )
      ..scale(2);
    return zoomed;
  }

  Matrix4 _revertZoom() => Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar(context, true, widget.title ?? ""),
      body: SizedBox(
        width: appWidth(context),
        height: appHeight(context),
        child: GestureDetector(
          onDoubleTapDown: _handleDoubleTapDown,
          onDoubleTap: _handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _transformationController,
            // minScale: 1,
            // maxScale: 5,
            child: customNetworkImage(
              boxFit: BoxFit.contain,
              pictureName: widget.image,
              token: widget.token,
            ),
          ),
        ),
      ),
    );
  }
}
