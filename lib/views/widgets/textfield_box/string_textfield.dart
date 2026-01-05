import 'package:flutter/material.dart';

class StringTextField extends StatelessWidget {
  final String name;
  final IconData boxIcon;
  final String hintText;
  final TextEditingController controller;
  final bool? fill;

  const StringTextField({
    Key? key,
    required this.name,
    required this.controller,
    required this.boxIcon,
    required this.hintText,
    required this.fill,
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
              color: const Color(0xFF889AAD),
            ),
            SizedBox(width: size.width * 0.01),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'hello',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF889AAD),
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.012),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return 'required**';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              filled: fill,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
              hintText: hintText,
              hintStyle: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    );
  }
}
