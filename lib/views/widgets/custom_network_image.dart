import 'package:flutter/material.dart';

import '../../network/base_client.dart';

Widget customNetworkImage({
  String? pictureName,
  String? token,
  BoxFit? boxFit,
  String? errorImageName,
  double? width,
}) {
  String baseUrl = BaseClient().baseUrl;

  return Image.network(
    '$baseUrl/api/allimg/image/$pictureName',
    headers: {
      'Authorization': "Bearer $token",
    },
    fit: boxFit ?? BoxFit.cover,
    width: 150,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
          strokeWidth: 1.5,
        ),
      );
    },
    // errorBuilder: (context, exception, stackTrace) {
    //   // return Center(
    //   //   child: CustomText.ourText(
    //   //     "Error",
    //   //     color: Colors.red,
    //   //   ),
    //   // );
    //   return Image.asset(
    //     errorImageName ?? "",
    //     fit: BoxFit.cover,
    //     width: appWidth(context) * 0.2,
    //   );
    // },
  );
}
