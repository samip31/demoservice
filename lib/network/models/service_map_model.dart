class ServiceMapModel {
  int id;
  String firstName;
  String serviceProvided;
  String? picture;
  String latitude;
  String longitude;
  String? jobfield;
  String? companyName;
  String? mobileNumber;
  String? email;
  String lastName;

  ServiceMapModel({
    required this.id,
    required this.firstName,
    required this.serviceProvided,
    required this.picture,
    required this.latitude,
    required this.longitude,
    required this.lastName,
    required this.jobfield,
    this.companyName,
    required this.mobileNumber,
    this.email,
  });

  factory ServiceMapModel.fromJson(Map<String, dynamic> json) {
    return ServiceMapModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        picture: json['picture'],
        serviceProvided: json['serviceProvided'] ?? "",
        latitude: json['latitude'],
        longitude: json['longitude'],
        companyName: json['companyName'],
        mobileNumber: json['mobileNumber'],
        email: json['email'],
        jobfield: json['jobField']);
  }
}
