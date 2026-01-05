// To parse this JSON data, do
//
//     final currentUserResponseModel = currentUserResponseModelFromJson(jsonString);

import 'dart:convert';

CurrentUserResponseModel currentUserResponseModelFromJson(String str) =>
    CurrentUserResponseModel.fromJson(json.decode(str));

String currentUserResponseModelToJson(CurrentUserResponseModel data) =>
    json.encode(data.toJson());

class CurrentUserResponseModel {
  String? email;
  String? password;
  String? mobileNumber;
  String? companyName;
  dynamic role;
  String? citizenshipNum;
  dynamic issuedDate;
  String? fullname;
  dynamic imageUrlCitizenshipFront;
  dynamic imageUrlCitizenshipBack;
  String? picture;
  dynamic associationImg;
  dynamic academicImg;
  String? latitude;
  String? longitude;
  String? serviceProvided;
  dynamic serviceUsed;
  bool? workStatus;
  bool? approval;
  bool? onlineStatus;
  DateTime? userCreatedDate;
  dynamic dateOfBirth;
  dynamic review;
  List<Role>? roles;
  int? id;
  dynamic gender;
  DateTime? currentUserResponseModelUserCreatedDate;
  dynamic cv;
  String? firstName;
  String? lastName;
  dynamic jobTitle;
  dynamic jobField;
  dynamic issusedDistrict;

  CurrentUserResponseModel({
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
    this.gender,
    this.currentUserResponseModelUserCreatedDate,
    this.cv,
    this.firstName,
    this.lastName,
    this.jobTitle,
    this.jobField,
    this.issusedDistrict,
  });

  factory CurrentUserResponseModel.fromJson(Map<String, dynamic> json) =>
      CurrentUserResponseModel(
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
        dateOfBirth: json["dateOfBirth"],
        review: json["review"],
        roles: json["roles"] == null
            ? []
            : List<Role>.from(json["roles"]!.map((x) => Role.fromJson(x))),
        id: json["id"],
        gender: json["gender"],
        currentUserResponseModelUserCreatedDate: json["userCreatedDate"] == null
            ? null
            : DateTime.parse(json["userCreatedDate"]),
        cv: json["cv"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        jobTitle: json["jobTitle"],
        jobField: json["jobField"],
        issusedDistrict: json["issusedDistrict"],
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
        "dateOfBirth": dateOfBirth,
        "review": review,
        "roles": roles == null
            ? []
            : List<dynamic>.from(roles!.map((x) => x.toJson())),
        "id": id,
        "gender": gender,
        "userCreatedDate":
            currentUserResponseModelUserCreatedDate?.toIso8601String(),
        "cv": cv,
        "firstName": firstName,
        "lastName": lastName,
        "jobTitle": jobTitle,
        "jobField": jobField,
        "issusedDistrict": issusedDistrict,
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
