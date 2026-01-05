class ChatModel {
  int? chatRoomId;
  int? userId;
  int? chatId;

  dynamic chatDate;
  // Null? status;
  String? details;

  //Null? chatParty;

  ChatModel({
    this.chatRoomId,
    this.userId,
    this.chatId,
    //  this.chatDate,
    //this.status,
    this.details,
    //this.chatParty
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    chatRoomId = json['chatRoomId'];
    userId = json['userId'];
    chatId = json['chatId'];
    // chatDate = json['chatDate'];
    // status = json['status'];
    details = json['details'];
    //chatParty = json['chatParty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chatRoomId'] = chatRoomId;
    data['userId'] = userId;
    data['chatId'] = chatId;
    // data['chatDate'] = chatDate;
    //data['status'] = this.status;
    data['details'] = details;
    //data['chatParty'] = this.chatParty;
    return data;
  }
}
