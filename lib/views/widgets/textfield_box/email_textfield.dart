import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  EmailTextField({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final regx =
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\"
          r".[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.email_outlined,
              size: 30,
              color: Color(0xFF889AAD),
            ),
            const SizedBox(width: 5),
            Text(
              'Email',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        SizedBox(height: size.height * 0.012),
        TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value!.isEmpty) {
              return null;
            } else if (!regx.hasMatch(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
          textAlign: TextAlign.left,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            hintText: 'Email address',
            hintStyle: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
