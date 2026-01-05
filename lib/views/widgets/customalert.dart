import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/views/widgets/Welcome%20Screen/splashscreen.dart';

class MyDialogs {
  myAlert(
    BuildContext context,
    String title,
    String message,
    VoidCallback no,
    VoidCallback yes,
  ) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 28, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 18, color: Colors.black45),
                  ),
                ],
              ),
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          no.call();
                        },
                        child: const Text(
                          'NO',
                          style: TextStyle(
                            fontFamily: 'hello',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      InkWell(
                        onTap: () async {
                          yes.call();
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setBool(SplashScreenState.keylogin, false);
                        },
                        child: Text(
                          'YES',
                          style: TextStyle(
                            fontFamily: 'hello',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }
}
