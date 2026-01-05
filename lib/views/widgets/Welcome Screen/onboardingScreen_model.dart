import 'package:flutter/material.dart';

class BuildScreen extends StatelessWidget {
  final String name;
  final String images;

  final String desc;

  const BuildScreen({
    Key? key,
    required this.name,
    required this.images,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          Image.asset('assets/$images'),
          SizedBox(height: size.height * 0.02),
          Text(
            name,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 0.91,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }
}
