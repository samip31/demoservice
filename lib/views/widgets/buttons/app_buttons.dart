import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String name;
  final IconData? icon;
  final bool? isDisabled;
  final VoidCallback onPressed;

  const AppButton({
    Key? key,
    required this.name,
    this.icon,
    required this.onPressed,
    this.isDisabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return MaterialButton(
        disabledColor: Colors.grey.shade300,
        color: isDisabled ?? false
            ? Colors.grey.shade300
            : const Color(0xFF86E91A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        onPressed: isDisabled ?? false
            ? null
            : () {
                onPressed.call();
              },
        child: SizedBox(
          height: size.height * 0.064,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon != null
                    ? Icon(
                        icon,
                        color: Colors.redAccent,
                      )
                    : Container(),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: isDisabled ?? false ? 18 : 21,
                    color: isDisabled ?? false ? Colors.black : Colors.black,
                  ),
                ),
                // SizedBox(
                //   width: size.width * 0.01,
                // )
              ],
            ),
          ),
        ));
  }
}
