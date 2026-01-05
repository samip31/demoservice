// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BStringTextField extends StatelessWidget {
  final String name;
  final IconData boxIcon;
  final String hintText;
  final TextEditingController controller;
  final bool? readOnly;

  const BStringTextField({
    Key? key,
    required this.name,
    required this.boxIcon,
    required this.hintText,
    required this.controller,
    this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            Icon(
              boxIcon,
              size: size.aspectRatio * 55,
              color: Colors.white,
            ),
            SizedBox(width: size.width * 0.01),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'hello',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.012),
        TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'required**';
            }
            return null;
          },
          readOnly: readOnly ?? false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
