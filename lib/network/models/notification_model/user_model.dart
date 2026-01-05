class UserNotificationModel {
  final int notificationId;
  final String notificationType;
  final String information;
  final String dateAndTime;
  bool seen;
  final bool historyStatus;
  final String usedBy;
  final dynamic details;

  UserNotificationModel({
    required this.notificationId,
    required this.notificationType,
    required this.information,
    required this.dateAndTime,
    required this.seen,
    required this.historyStatus,
    required this.usedBy,
    required this.details,
  });
  dynamic operator [](String key) {
    switch (key) {
      case 'notificationId':
        return notificationId;
      case 'notificationType':
        return notificationType;
      case 'information':
        return information;
      case 'dateAndTime':
        return dateAndTime;
      case 'seen':
        return seen;
      case 'historyStatus':
        return historyStatus;
      case 'usedBy':
        return usedBy;
      case 'details':
        return details;
      default:
        throw ArgumentError('Invalid key: $key');
    }
  }
}

// // To parse this JSON data, do
// //
// //     final userNotificationResponseModel = userNotificationResponseModelFromJson(jsonString);

// import 'dart:convert';

// UserNotificationResponseModel userNotificationResponseModelFromJson(
//         String str) =>
//     UserNotificationResponseModel.fromJson(json.decode(str));

// String userNotificationResponseModelToJson(
//         UserNotificationResponseModel data) =>
//     json.encode(data.toJson());

// class UserNotificationResponseModel {
//   bool? seenStatus;
//   List<Notification>? notification;

//   UserNotificationResponseModel({
//     this.seenStatus,
//     this.notification,
//   });

//   factory UserNotificationResponseModel.fromJson(Map<String, dynamic> json) =>
//       UserNotificationResponseModel(
//         seenStatus: json["seenStatus"],
//         notification: json["notification"] == null
//             ? []
//             : List<Notification>.from(
//                 json["notification"]!.map((x) => Notification.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "seenStatus": seenStatus,
//         "notification": notification == null
//             ? []
//             : List<dynamic>.from(notification!.map((x) => x.toJson())),
//       };
// }

// class Notification {
//   int? notificationId;
//   String? notificationType;
//   DateTime? information;
//   DateTime? dateAndTime;
//   bool? seen;
//   bool? historyStatus;
//   String? usedBy;
//   dynamic details;

//   Notification({
//     this.notificationId,
//     this.notificationType,
//     this.information,
//     this.dateAndTime,
//     this.seen,
//     this.historyStatus,
//     this.usedBy,
//     this.details,
//   });

//   factory Notification.fromJson(Map<String, dynamic> json) => Notification(
//         notificationId: json["notificationId"],
//         notificationType: json["notificationType"],
//         information: json["information"] == null
//             ? null
//             : DateTime.parse(json["information"]),
//         dateAndTime: json["dateAndTime"] == null
//             ? null
//             : DateTime.parse(json["dateAndTime"]),
//         seen: json["seen"],
//         historyStatus: json["historyStatus"],
//         usedBy: json["usedBy"],
//         details: json["details"],
//       );

//   Map<String, dynamic> toJson() => {
//         "notificationId": notificationId,
//         "notificationType": notificationType,
//         "information": information?.toIso8601String(),
//         "dateAndTime":
//             "${dateAndTime!.year.toString().padLeft(4, '0')}-${dateAndTime!.month.toString().padLeft(2, '0')}-${dateAndTime!.day.toString().padLeft(2, '0')}",
//         "seen": seen,
//         "historyStatus": historyStatus,
//         "usedBy": usedBy,
//         "details": details,
//       };
// }
