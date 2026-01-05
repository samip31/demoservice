import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import 'custom_toasts.dart';

Future<File?> customCropImageWidget(File picked, BuildContext context) async {
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: picked.path,
    compressFormat: ImageCompressFormat.jpg,
    compressQuality: 100,
    // cropStyle: CropStyle.rectangle,
    // aspectRatioPresets: [
    //   // CropAspectRatioPreset.original,
    //   // CropAspectRatioPreset.ratio16x9,
    //   CropAspectRatioPreset.ratio4x3,
    // ],
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        cropGridColor: Colors.white,
        hideBottomControls: true,
      ),
      IOSUiSettings(
        title: 'Cropper',
      ),
      WebUiSettings(
        context: context,
      //   presentStyle: CropperPresentStyle.dialog,
      //   boundary: const CroppieBoundary(
      //     width: 520,
      //     height: 520,
      //   ),
      //   viewPort:
      //       const CroppieViewPort(width: 480, height: 480, type: 'circle'),
      //   enableExif: true,
      //   enableZoom: true,
      //   showZoomer: true,
      ),
    ],
  );
  if (croppedFile != null) {
    return File(croppedFile.path);
  } else {
    errorToast(msg: "No profile picture selected");
  }
  return null;
}
