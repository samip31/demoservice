import 'dart:io';

import 'package:flutter/material.dart';

class ImageBox extends StatelessWidget {
  final String name;
  final File? image;
  final VoidCallback onTap;

  const ImageBox(
      {super.key,
      required this.image,
      required this.onTap,
      required this.name});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.person_outline,
              size: 30,
              color: Color(0xFF889AAD),
            ),
            const SizedBox(width: 5),
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        SizedBox(height: size.height * 0.012),
        InkWell(
          onTap: () {
            onTap.call();
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black26),
                color: Colors.white),
            height: size.height * 0.066,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        image != null ? 'ReUpload Picture' : 'Upload Picture',
                        style: const TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.black38,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        image != null
            ? Image.file(
                image!,
              )
            : Container(),
      ],
    );
  }
}
