// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordTextField extends StatefulWidget {
  final String name;
  final TextEditingController controller;
  final TextEditingController passwordController;

  const ConfirmPasswordTextField({
    Key? key,
    required this.name,
    required this.controller,
    required this.passwordController,
  }) : super(key: key);

  @override
  State<ConfirmPasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<ConfirmPasswordTextField> {
  bool _passwordvisible1 = false;
  // String? _errorMessage;

  RegExp regex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[!@#$&*~]).{8,}$');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.lock_open_rounded,
              size: 25,
              color: Color(0xFF889AAD),
            ),
            SizedBox(width: size.width * 0.01),
            Text(
              widget.name,
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
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (password) {
            if (password!.isEmpty) {
              return 'Required**';
            } else if (password.length < 8) {
              return 'Password must contain atleast 8 characters';
            } else if (widget.passwordController.text !=
                widget.controller.text) {
              return "Password doesn't match";
            }
            return null;
          },
          textAlign: TextAlign.left,
          style: const TextStyle(color: Colors.black),
          obscureText: !_passwordvisible1,
          decoration: InputDecoration(
              errorMaxLines: 2,
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _passwordvisible1 = !_passwordvisible1;
                    });
                  },
                  icon: Icon(_passwordvisible1
                      ? CupertinoIcons.eye
                      : CupertinoIcons.eye_slash)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              hintText: '********',
              hintStyle: Theme.of(context).textTheme.titleLarge),
        ),
        // if (_errorMessage != null)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8.0),
        //     child: Expanded(
        //       child: Text(
        //         _errorMessage!,
        //         style: const TextStyle(
        //           color: Colors.red,
        //           overflow: TextOverflow.visible,
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
