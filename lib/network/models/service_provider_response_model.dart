// To parse this JSON data, do
//
//     final serviceProviderOngoingResponseModel = serviceProviderOngoingResponseModelFromJson(jsonString);

import 'dart:convert';

ServiceProviderOngoingResponseModel serviceProviderOngoingResponseModelFromJson(
        String str) =>
    ServiceProviderOngoingResponseModel.fromJson(json.decode(str));

String serviceProviderOngoingResponseModelToJson(
        ServiceProviderOngoingResponseModel data) =>
    json.encode(data.toJson());

class ServiceProviderOngoingResponseModel {
  String? message;
  List<WorkOrder>? workOrders;

  ServiceProviderOngoingResponseModel({
    this.message,
    this.workOrders,
  });

  factory ServiceProviderOngoingResponseModel.fromJson(
          Map<String, dynamic> json) =>
      ServiceProviderOngoingResponseModel(
        message: json["Message"],
        workOrders: json["Work Orders"] == null
            ? []
            : List<WorkOrder>.from(
                json["Work Orders"]!.map((x) => WorkOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Work Orders": workOrders == null
            ? []
            : List<dynamic>.from(workOrders!.map((x) => x.toJson())),
      };
}

class WorkOrder {
  int? orderId;
  int? serviceProviderId;
  DateTime? orderDate;
  DateTime? completedDate;
  bool? chat;
  int? userId;
  String? completedStatus;
  User? user;

  WorkOrder({
    this.orderId,
    this.serviceProviderId,
    this.orderDate,
    this.completedDate,
    this.chat,
    this.userId,
    this.completedStatus,
    this.user,
  });

  factory WorkOrder.fromJson(Map<String, dynamic> json) => WorkOrder(
        orderId: json["orderId"],
        serviceProviderId: json["serviceProviderId"],
        orderDate: json["orderDate"] == null
            ? null
            : DateTime.parse(json["orderDate"]),
        completedDate: json["completedDate"] == null
            ? null
            : DateTime.parse(json["completedDate"]),
        chat: json["chat"],
        userId: json["userId"],
        completedStatus: json["completedStatus"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "serviceProviderId": serviceProviderId,
        "orderDate": orderDate?.toIso8601String(),
        "completedDate": completedDate?.toIso8601String(),
        "chat": chat,
        "userId": userId,
        "completedStatus": completedStatus,
        "user": user?.toJson(),
      };
}

class User {
  String? email;
  String? password;
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
  DateTime? userCreatedDate;
  DateTime? dateOfBirth;
  dynamic review;
  List<Role>? roles;
  int? id;
  String? cv;
  String? lastName;
  String? firstName;
  String? issusedDistrict;
  String? gender;
  String? jobTitle;
  String? jobField;
  DateTime? userUserCreatedDate;

  User({
    this.email,
    this.password,
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
    this.userCreatedDate,
    this.dateOfBirth,
    this.review,
    this.roles,
    this.id,
    this.cv,
    this.lastName,
    this.firstName,
    this.issusedDistrict,
    this.gender,
    this.jobTitle,
    this.jobField,
    this.userUserCreatedDate,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        password: json["password"],
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
        userCreatedDate: json["UserCreatedDate"] == null
            ? null
            : DateTime.parse(json["UserCreatedDate"]),
        dateOfBirth: json["dateOfBirth"] == null
            ? null
            : DateTime.parse(json["dateOfBirth"]),
        review: json["review"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        id: json["id"],
        cv: json["cv"],
        lastName: json["lastName"],
        firstName: json["firstName"],
        issusedDistrict: json["issusedDistrict"],
        gender: json["gender"],
        jobTitle: json["jobTitle"],
        jobField: json["jobField"],
        userUserCreatedDate: json["userCreatedDate"] == null
            ? null
            : DateTime.parse(json["userCreatedDate"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
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
        "UserCreatedDate": userCreatedDate?.toIso8601String(),
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "review": review,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "id": id,
        "cv": cv,
        "lastName": lastName,
        "firstName": firstName,
        "issusedDistrict": issusedDistrict,
        "gender": gender,
        "jobTitle": jobTitle,
        "jobField": jobField,
        "userCreatedDate": userUserCreatedDate?.toIso8601String(),
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
