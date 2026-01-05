import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import '../../../core/development/console.dart';
import '../../../core/enum.dart';
import '../../../network/services/orderService/chat_controller.dart';
import '../../../network/services/orderService/status_controller.dart';
import '../../widgets/custom_dialogs.dart';

class ChatScreen extends StatefulWidget {
  final String serviceId;
  final String orderId;
  final String firstName;
  final String lastName;
  final String userId;
  final String completedStatus;

  const ChatScreen({
    super.key,
    required this.serviceId,
    required this.orderId,
    required this.firstName,
    required this.lastName,
    required this.userId,
    required this.completedStatus,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = Get.put(ChatController());
  final chatController = TextEditingController();
  final authController = Get.put(AuthController());
  StatusController statusController = StatusController();
  int? tid;
  ScrollController scrollController = ScrollController();
  final rating = 0.obs;

  @override
  void initState() {
    controller.getChatDetail(widget.orderId);
    getToken();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollController.hasClients) {
        logger("scrolling", loggerType: LoggerType.info);
        Future.delayed(const Duration(milliseconds: 600))
            .then((value) => scrollController.animateTo(
                  scrollController.position.maxScrollExtent + 300,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                ));
      }
    });
    super.initState();
  }

  ///TODO
  bool isUser() {
    print("$tid :: ${widget.userId}");
    if (tid.toString() == widget.userId.toString()) {
      return true;
    } else {
      return false;
    }
  }

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? apptoken = prefs.getString("token");
    int? id = prefs.getInt("id");
    setState(() {
      tid = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    logger("Order ID :: ${widget.orderId} & ${widget.completedStatus}",
        loggerType: LoggerType.success);
    return Scaffold(
      // appBar: myAppbar(
      //   context,
      //   true,
      //   "${widget.firstName} ${widget.lastName}",
      //   isChat: true,
      //   isServiceProvider: !isUser(),
      //   completedStatus: widget.completedStatus,
      //   workOrderId: widget.orderId,
      // ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text(
          "${widget.firstName} ${widget.lastName}",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          widget.completedStatus == "1"
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                      onPressed: () {
                        Get.dialog(AlertDialog(
                          title: const Text(
                            'Complete?',
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                          content:
                              const Text('Have you paid the service provider?'),
                          actions: [
                            TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  'NO',
                                  style: TextStyle(color: Colors.red),
                                )),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                  widget.completedStatus == "1"
                                      ? CustomDialogs.fullLoadingDialog(
                                          context: context)
                                      : null;
                                  widget.completedStatus == "1"
                                      ? statusController.updateStatusWorkOrder(
                                          widget.orderId,
                                          completedStatusCode: 2,
                                        )
                                      : null;

                                  // widget.completedStatus == "3"
                                  //     ? showRatingDialog(
                                  //         completedStatus: "4",
                                  //         workOrderId: widget.orderId)
                                  //     : null;
                                },
                                child: const Text(
                                  'YES',
                                  style: TextStyle(color: Colors.green),
                                )),
                          ],
                        ));
                      },
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 30,
                      )),
                )
              : widget.completedStatus == "3"
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {
                            Get.dialog(AlertDialog(
                              title: const Text(
                                'Rating',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black),
                              ),
                              content: RatingBar.builder(
                                initialRating: rating.value.toDouble(),
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                                onRatingUpdate: (value) {
                                  rating.value = value.toInt();
                                },
                              ),
                              actions: [
                                Obx(
                                  () => statusController.isLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : TextButton(
                                          onPressed: () {
                                            // Get.back();
                                            consolelog(rating.value);
                                            CustomDialogs.fullLoadingDialog(
                                                context: context);
                                            statusController
                                                .updateStatusWorkOrder(
                                                    widget.orderId,
                                                    completedStatusCode: 4,
                                                    rating: true)
                                                .then((value) {
                                              if (value) {
                                                statusController
                                                    .ratingWorkOrder(
                                                        widget.orderId,
                                                        rating.value);
                                              }
                                            });
                                          },
                                          child: const Text(
                                            'Submit',
                                            style:
                                                TextStyle(color: Colors.green),
                                          )),
                                ),
                              ],
                            ));
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 30,
                          )),
                    )
                  : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.chat.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: controller.chat[index].userId == tid
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                color: controller.chat[index].userId == tid
                                    ? Colors.greenAccent
                                    : Colors.red,
                                padding: EdgeInsets.all(size.aspectRatio * 18),
                                margin: controller.chat[index].userId == tid
                                    ? EdgeInsets.only(
                                        left: size.aspectRatio * 100)
                                    : EdgeInsets.only(
                                        right: size.aspectRatio * 100),
                                child: Text(
                                  controller.chat[index].details.toString(),
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: chatController,
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: const TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                            onPressed: () {
                              controller.postChat(
                                widget.orderId,
                                chatController.text,
                                widget.serviceId,
                              );
                              // FocusManager.instance.primaryFocus?.unfocus();
                              chatController.clear();
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent + 300,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.linear,
                              );
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.red,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
