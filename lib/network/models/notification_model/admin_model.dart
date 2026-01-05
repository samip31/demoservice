class AdminNotificationModel {
  final int adminNotificationId;
  final String title;
  final String information;
  final String? dateAndTime;
  final bool historyStatus;

  AdminNotificationModel({
    required this.adminNotificationId,
    required this.title,
    required this.information,
    required this.dateAndTime,
    required this.historyStatus,
  });
}
