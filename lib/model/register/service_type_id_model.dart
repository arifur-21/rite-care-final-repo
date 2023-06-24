class ServiceTypeIdModel {
  Patient? patient;
  int? count;

  ServiceTypeIdModel({this.patient, this.count});

  ServiceTypeIdModel.fromJson(Map<String, dynamic> json) {
    patient =
    json['Patient'] != null ? new Patient.fromJson(json['Patient']) : null;
    count = json['Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patient != null) {
      data['Patient'] = this.patient!.toJson();
    }
    data['Count'] = this.count;
    return data;
  }
}

class Patient {
  String? firstName;
  String? phoneNumber;
  String? serviceId;
  int? serviceTypeId;


  Patient(
      {
        this.firstName,
        this.phoneNumber,
        this.serviceId,
        this.serviceTypeId,
       });

  Patient.fromJson(Map<String, dynamic> json) {
    firstName = json['FirstName'];
    phoneNumber = json['PhoneNumber'];
    serviceId = json['ServiceId'];
    serviceTypeId = json['ServiceTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['FirstName'] = this.firstName;
    data['PhoneNumber'] = this.phoneNumber;
    data['ServiceId'] = this.serviceId;
    data['ServiceTypeId'] = this.serviceTypeId;
    return data;
  }
}
