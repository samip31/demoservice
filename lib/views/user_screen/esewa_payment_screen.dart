import 'package:flutter/material.dart';
import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/route_navigation.dart';
import 'package:smartsewa/views/widgets/custom_toasts.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/custom_snackbar.dart';

class EsewaPaymentScreen extends StatefulWidget {
  const EsewaPaymentScreen({super.key});

  @override
  State<EsewaPaymentScreen> createState() => _EsewaPaymentScreenState();
}

class _EsewaPaymentScreenState extends State<EsewaPaymentScreen> {
  WebViewController? _webViewController;
  String uniqueEsewaId = '';
  bool initialLoader = true;

  @override
  void initState() {
    uniqueEsewaId = "${DateTime.now().millisecondsSinceEpoch}";
    consolelog(uniqueEsewaId);
    super.initState();
  }

  success(String? refId) async {}

  NavigationDecision _interceptNavigation(NavigationRequest request) {
    if (request.url.contains('esewa_payment_success')) {
      console(Uri.parse(request.url.toString()).queryParameters['refId']);
      console("success ${request.url}");
      success(Uri.parse(request.url.toString()).queryParameters['refId']);
      return NavigationDecision.prevent;
    } else if (request.url.contains('esewa_payment_failed')) {
      errorToast(msg: "Payment failed at esewa end");
      back(context);
      console("failed ${request.url}");
      return NavigationDecision.prevent;
    } else {
      return NavigationDecision.navigate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CustomSnackBar.showSnackBar(
            title: "Payment Cancelled", color: Colors.red);
        return true;
      },
      child: Placeholder()
      // Scaffold(
      //   appBar: myAppbar(context, true, "Esewa Payment"),
      //   body: Stack(
      //     children: [
      //       WebView(
      //         navigationDelegate: _interceptNavigation,
      //         initialUrl: "about:blank",
      //         javascriptMode: JavascriptMode.unrestricted,
      //         onPageFinished: (data) {},
      //         debuggingEnabled: true,
      //         onWebResourceError: (error) {
      //           if (error.errorType ==
      //               WebResourceErrorType.javaScriptExceptionOccurred) {
      //             CustomSnackBar.showSnackBar(
      //                 title: 'Failed to execute', color: Colors.red);
      //           } else if (error.errorType ==
      //               WebResourceErrorType.fileNotFound) {
      //             CustomSnackBar.showSnackBar(
      //                 title: "Sorry, transaction is failed", color: Colors.red);
      //           } else {
      //             CustomSnackBar.showSnackBar(
      //                 title: "Failed to proceed", color: Colors.red);
      //           }
      //         },
      //         onWebViewCreated: (webViewController) {
      //           _webViewController = webViewController;
      //           _webViewController?.runJavascript('''
      // var path= "https://uat.esewa.com.np/epay/main";
      // var params= {
      //   amt: "10",
      //   psc: 0,
      //   pdc: 0,
      //   txAmt: 0,
      //   tAmt: "10",
      //   pid: '$uniqueEsewaId',
      //   scd: "EPAYTEST",
      //   su: "http://merchant.com.np/page/esewa_payment_success",
      //   fu: "http://merchant.com.np/page/esewa_payment_failed"
      // }
      //
      // function post(path, params) {
      //   var form = document.createElement("form");
      //   form.setAttribute("method", "POST");
      //   form.setAttribute("action", path);
      //
      //   for(var key in params) {
      //           var hiddenField = document.createElement("input");
      //           hiddenField.setAttribute("type", "hidden");
      //           hiddenField.setAttribute("name", key);
      //           hiddenField.setAttribute("value", params[key]);
      //           form.appendChild(hiddenField);
      //   }
      //
      //   document.body.appendChild(form);
      //   form.submit();
      // }
      // post(path,params);
      // ''').then((value) {
      //             setState(() {
      //               initialLoader = false;
      //             });
      //           });
      //         },
      //       ),
      //       Visibility(
      //         visible: initialLoader,
      //         child: Positioned(
      //           top: 0,
      //           left: 0,
      //           right: 0,
      //           child: Center(
      //             child: Container(
      //               color: Colors.white,
      //               child: const LinearProgressIndicator(),
      //             ),
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
