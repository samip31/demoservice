// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smartsewa/core/development/console.dart';
import 'package:smartsewa/core/enum.dart';
import 'package:smartsewa/network/services/authServices/auth_controller.dart';
import 'package:smartsewa/network/services/orderService/chat_controller.dart';
import 'package:smartsewa/network/services/orderService/request_service.dart';
import 'package:smartsewa/views/widgets/my_appbar.dart';

class ChatScreenService extends StatefulWidget {
  final String serviceId;
  final String orderId;
  final String firstName;
  final String lastName;
  final String userId;
  final String? completedStatus;

  const ChatScreenService({
    Key? key,
    required this.serviceId,
    required this.orderId,
    required this.firstName,
    required this.lastName,
    required this.userId,
    this.completedStatus,
  }) : super(key: key);

  @override
  State<ChatScreenService> createState() => _ChatScreenServiceState();
}

class _ChatScreenServiceState extends State<ChatScreenService> {
  final controller = Get.put(ChatController());
  final orderController = Get.put(OrderController());
  final chatController = TextEditingController();
  final authController = Get.put(AuthController());
  int? tid;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    getToken();
    controller.getChatDetail(widget.orderId);
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  ///TODO
  bool isUser() {
    if (tid.toString() == widget.userId.toString()) {
      return false;
    } else {
      return true;
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
    consolelog("Order ID :: ${widget.orderId} & ${widget.completedStatus}");
    logger("Order ID :: ${widget.orderId} & ${widget.completedStatus}",
        loggerType: LoggerType.success);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppbar(
        context,
        true,
        "${widget.firstName} ${widget.lastName} ",
        isChat: true,
        isServiceProvider: !isUser(),
        workOrderId: widget.orderId,
        completedStatus: widget.completedStatus,
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
                        physics: const ClampingScrollPhysics(),
                        itemCount: controller.chat.length,
                        shrinkWrap: true,
                        controller: scrollController,
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
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
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
