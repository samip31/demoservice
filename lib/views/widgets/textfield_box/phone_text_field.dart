import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  const PhoneTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              CupertinoIcons.phone,
              size: 25,
              color: Color(0xFF889AAD),
            ),
            SizedBox(width: size.width * 0.01),
            const Text(
              'Phone',
              style: TextStyle(
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
            if (!RegExp(r'^[9][7-8]\d{8}$').hasMatch(value)) {
              return "Phone number not valid";
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: TextAlign.left,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: '98********',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
