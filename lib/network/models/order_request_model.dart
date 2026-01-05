// To parse this JSON data, do
//
//     final userServicesListResponse = userServicesListResponseFromJson(jsonString);

import 'dart:convert';

List<UserServicesListResponse> userServicesListResponseFromJson(String str) =>
    List<UserServicesListResponse>.from(
        json.decode(str).map((x) => UserServicesListResponse.fromJson(x)));

String userServicesListResponseToJson(List<UserServicesListResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserServicesListResponse {
  int? orderId;
  int? serviceProviderId;
  DateTime? orderDate;
  DateTime? completedDate;
  bool? chat;
  String? completedStatus;
  ServiceProvider? user;
  ServiceProvider? serviceProvider;
  List<OrderChat>? orderChats;

  UserServicesListResponse({
    this.orderId,
    this.serviceProviderId,
    this.orderDate,
    this.completedDate,
    this.chat,
    this.completedStatus,
    this.user,
    this.serviceProvider,
    this.orderChats,
  });

  factory UserServicesListResponse.fromJson(Map<String, dynamic> json) =>
      UserServicesListResponse(
        orderId: json["orderId"],
        serviceProviderId: json["serviceProviderId"],
        orderDate: json["orderDate"] == null
            ? null
            : DateTime.parse(json["orderDate"]),
        completedDate: json["completedDate"] == null
            ? null
            : DateTime.parse(json["completedDate"]),
        chat: json["chat"],
        completedStatus: json["completedStatus"],
        user: json["user"] == null
            ? null
            : ServiceProvider.fromJson(json["user"]),
        serviceProvider: json["serviceProvider"] == null
            ? null
            : ServiceProvider.fromJson(json["serviceProvider"]),
        orderChats: json["orderChats"] == null
            ? []
            : List<OrderChat>.from(
                json["orderChats"]!.map((x) => OrderChat.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "serviceProviderId": serviceProviderId,
        "orderDate": orderDate?.toIso8601String(),
        "completedDate": completedDate?.toIso8601String(),
        "chat": chat,
        "completedStatus": completedStatus,
        "user": user?.toJson(),
        "serviceProvider": serviceProvider?.toJson(),
        "orderChats": orderChats == null
            ? []
            : List<dynamic>.from(orderChats!.map((x) => x.toJson())),
      };
}

class OrderChat {
  int? chatRoomId;
  int? userId;
  int? chatId;
  DateTime? chatDate;
  String? details;
  String? status;
  String? chatParty;
  int? providerId;

  OrderChat({
    this.chatRoomId,
    this.userId,
    this.chatId,
    this.chatDate,
    this.details,
    this.status,
    this.chatParty,
    this.providerId,
  });

  factory OrderChat.fromJson(Map<String, dynamic> json) => OrderChat(
        chatRoomId: json["chatRoomId"],
        userId: json["userId"],
        chatId: json["chatId"],
        chatDate:
            json["chatDate"] == null ? null : DateTime.parse(json["chatDate"]),
        details: json["details"],
        status: json["status"],
        chatParty: json["chatParty"],
        providerId: json["providerId"],
      );

  Map<String, dynamic> toJson() => {
        "chatRoomId": chatRoomId,
        "userId": userId,
        "chatId": chatId,
        "chatDate": chatDate?.toIso8601String(),
        "details": details,
        "status": status,
        "chatParty": chatParty,
        "providerId": providerId,
      };
}

class ServiceProvider {
  String? email;
  String? mobileNumber;
  String? companyName;
  dynamic role;
  String? citizenshipNum;
  String? issuedDate;
  String? fullname;
  String? imageUrlCitizenshipFront;
  String? imageUrlCitizenshipBack;
  String? picture;
  String? associationImg;
  String? academicImg;
  String? latitude;
  String? longitude;
  String? serviceProvided;
  dynamic serviceUsed;
  bool? workStatus;
  bool? approval;
  bool? onlineStatus;
  String? jobField;
  DateTime? userCreatedDate;
  DateTime? dateOfBirth;
  dynamic review;
  double? averageRating;
  int? noOfRatingReceived;
  List<Role>? roles;
  int? id;
  String? issusedDistrict;
  String? jobTitle;
  DateTime? serviceProviderUserCreatedDate;
  String? gender;
  String? cv;
  String? lastName;
  String? firstName;

  ServiceProvider({
    this.email,
    this.mobileNumber,
    this.companyName,
    this.role,
    this.citizenshipNum,
    this.issuedDate,
    this.fullname,
    this.imageUrlCitizenshipFront,
    this.imageUrlCitizenshipBack,
    this.picture,
    this.associationImg,
    this.academicImg,
    this.latitude,
    this.longitude,
    this.serviceProvided,
    this.serviceUsed,
    this.workStatus,
    this.approval,
    this.onlineStatus,
    this.jobField,
    this.userCreatedDate,
    this.dateOfBirth,
    this.review,
    this.averageRating,
    this.noOfRatingReceived,
    this.roles,
    this.id,
    this.issusedDistrict,
    this.jobTitle,
    this.serviceProviderUserCreatedDate,
    this.gender,
    this.cv,
    this.lastName,
    this.firstName,
  });

  factory ServiceProvider.fromJson(Map<String, dynamic> json) =>
      ServiceProvider(
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        companyName: json["companyName"],
        role: json["role"],
        citizenshipNum: json["citizenshipNum"],
        issuedDate: json["issuedDate"],
        fullname: json["fullname"],
        imageUrlCitizenshipFront: json["imageUrlCitizenshipFront"],
        imageUrlCitizenshipBack: json["imageUrlCitizenshipBack"],
        picture: json["picture"],
        associationImg: json["associationImg"],
        academicImg: json["academicImg"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        serviceProvided: json["serviceProvided"],
        serviceUsed: json["serviceUsed"],
        workStatus: json["workStatus"],
        approval: json["approval"],
        onlineStatus: json["onlineStatus"],
        jobField: json["jobField"],
        userCreatedDate: json["UserCreatedDate"] == null
            ? null
            : DateTime.parse(json["UserCreatedDate"]),
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        review: json["review"],
        averageRating: json["average_rating"],
        noOfRatingReceived: json["no_of_rating_received"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        id: json["id"],
        issusedDistrict: json["issusedDistrict"],
        jobTitle: json["jobTitle"],
        serviceProviderUserCreatedDate: json["userCreatedDate"] == null
            ? null
            : DateTime.parse(json["userCreatedDate"]),
        gender: json["gender"],
        cv: json["cv"],
        lastName: json["lastName"],
        firstName: json["firstName"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "mobileNumber": mobileNumber,
        "companyName": companyName,
        "role": role,
        "citizenshipNum": citizenshipNum,
        "issuedDate": issuedDate,
        "fullname": fullname,
        "imageUrlCitizenshipFront": imageUrlCitizenshipFront,
        "imageUrlCitizenshipBack": imageUrlCitizenshipBack,
        "picture": picture,
        "associationImg": associationImg,
        "academicImg": academicImg,
        "latitude": latitude,
        "longitude": longitude,
        "serviceProvided": serviceProvided,
        "serviceUsed": serviceUsed,
        "workStatus": workStatus,
        "approval": approval,
        "onlineStatus": onlineStatus,
        "jobField": jobField,
        "UserCreatedDate": userCreatedDate?.toIso8601String(),
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "review": review,
        "average_rating": averageRating,
        "no_of_rating_received": noOfRatingReceived,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "id": id,
        "issusedDistrict": issusedDistrict,
        "jobTitle": jobTitle,
        "userCreatedDate": serviceProviderUserCreatedDate?.toIso8601String(),
        "gender": gender,
        "cv": cv,
        "lastName": lastName,
        "firstName": firstName,
      };
}

class Role {
  int? id;
  String? name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
