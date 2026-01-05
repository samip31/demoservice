import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
class ConnectionWidget extends StatelessWidget {
  final Widget widget;
  void Function()? onPressed;
  ConnectionWidget({required this.widget, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder:
          (BuildContext context, ConnectivityResult connection, Widget child) {
        final bool connected = connection != ConnectivityResult.none;
        // print(connected);
        return connected ? widget : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text('Connection Lost'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Oops! It seems you lost your internet connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onPressed,
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(),
    );
  }
}
