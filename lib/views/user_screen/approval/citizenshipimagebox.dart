import 'dart:io';

import 'package:flutter/material.dart';

class CitizenshipImageBox extends StatelessWidget {
  final String hinttext;
  final File? image;
  final VoidCallback onTap;

  const CitizenshipImageBox({
    super.key,
    required this.hinttext,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black26),
              color: Colors.white),
          height: size.height * 0.066,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GestureDetector(
                onTap: () {
                  onTap.call();
                },
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        image != null ? 'ReUpload Picture' : hinttext,
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
