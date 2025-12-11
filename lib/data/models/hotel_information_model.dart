class HotelInformationModel {
  int? accIntegrationType;
  String? address1;
  String? address2;
  String? cancellationPolicy;
  int? cityId;
  int? cmIntegrationType;
  int? countryId;
  int? createdBy;
  String? deviceId;
  int? dtVersion;
  String? email;
  String? fax;
  int? grade;
  int? hotelId;
  String? hotelName;
  String? hotelPolicy;
  int? lastModifiedBy;
  String? logoPath;
  String? postCode;
  String? propertyType;
  String? regNo1;
  String? regNo2;
  String? regNo3;
  String? rowVersion;
  String? state;
  int? status;
  String? sysDateCreated;
  String? sysDateLastModified;
  int? sysVersion;
  String? tel1;
  String? tel2;
  String? webSite;

   factory HotelInformationModel.empty() {
    return HotelInformationModel(
      accIntegrationType: 0,
      address1: "",
      address2: "",
      cancellationPolicy: "",
      cityId: 0,
      cmIntegrationType: 0,
      countryId: 0,
      createdBy: 0,
      deviceId: "",
      dtVersion: 0,
      email: "",
      fax: "",
      grade: 0,
      hotelId: 0,
      hotelName: "",
      hotelPolicy: "",
      lastModifiedBy: 0,
      logoPath: "",
      postCode: "",
      propertyType: "",
      regNo1: "",
      regNo2: "",
      regNo3: "",
      rowVersion: "",
      state: "",
      status: 0,
      sysDateCreated: "",
      sysDateLastModified: "",
      sysVersion: 0,
      tel1: "",
      tel2: "",
      webSite: "",
    );
  }

  HotelInformationModel({
    this.accIntegrationType,
    this.address1,
    this.address2,
    this.cancellationPolicy,
    this.cityId,
    this.cmIntegrationType,
    this.countryId,
    this.createdBy,
    this.deviceId,
    this.dtVersion,
    this.email,
    this.fax,
    this.grade,
    this.hotelId,
    this.hotelName,
    this.hotelPolicy,
    this.lastModifiedBy,
    this.logoPath,
    this.postCode,
    this.propertyType,
    this.regNo1,
    this.regNo2,
    this.regNo3,
    this.rowVersion,
    this.state,
    this.status,
    this.sysDateCreated,
    this.sysDateLastModified,
    this.sysVersion,
    this.tel1,
    this.tel2,
    this.webSite,
  });

  factory HotelInformationModel.fromJson(Map<String, dynamic> json) {
    return HotelInformationModel(
      accIntegrationType: json['accIntegrationType'],
      address1: json['address1'],
      address2: json['address2'],
      cancellationPolicy: json['cancellationPolicy'],
      cityId: json['cityId'],
      cmIntegrationType: json['cmIntegrationType'],
      countryId: json['countryId'],
      createdBy: json['createdBy'],
      deviceId: json['deviceId'],
      dtVersion: json['dt_Version'],
      email: json['email'],
      fax: json['fax'],
      grade: json['grade'],
      hotelId: json['hotelId'],
      hotelName: json['hotelName'],
      hotelPolicy: json['hotelPolicy'],
      lastModifiedBy: json['lastModifiedBy'],
      logoPath: json['logoPath'],
      postCode: json['postCode'],
      propertyType: json['propertyType'],
      regNo1: json['regNo1'],
      regNo2: json['regNo2'],
      regNo3: json['regNo3'],
      rowVersion: json['rowVersion'],
      state: json['state'],
      status: json['status'],
      sysDateCreated: json['sysDateCreated'],
      sysDateLastModified: json['sysDateLastModified'],
      sysVersion: json['sysVersion'],
      tel1: json['tel1'],
      tel2: json['tel2'],
      webSite: json['webSite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accIntegrationType': accIntegrationType,
      'address1': address1,
      'address2': address2,
      'cancellationPolicy': cancellationPolicy,
      'cityId': cityId,
      'cmIntegrationType': cmIntegrationType,
      'countryId': countryId,
      'createdBy': createdBy,
      'deviceId': deviceId,
      'dt_Version': dtVersion,
      'email': email,
      'fax': fax,
      'grade': grade,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'hotelPolicy': hotelPolicy,
      'lastModifiedBy': lastModifiedBy,
      'logoPath': logoPath,
      'postCode': postCode,
      'propertyType': propertyType,
      'regNo1': regNo1,
      'regNo2': regNo2,
      'regNo3': regNo3,
      'rowVersion': rowVersion,
      'state': state,
      'status': status,
      'sysDateCreated': sysDateCreated,
      'sysDateLastModified': sysDateLastModified,
      'sysVersion': sysVersion,
      'tel1': tel1,
      'tel2': tel2,
      'webSite': webSite,
    };
  }

  @override
  String toString() {
    return '''
HotelInfo(
  hotelId: $hotelId,
  hotelName: $hotelName,
  address1: $address1,
  address2: $address2,
  cityId: $cityId,
  countryId: $countryId,
  email: $email,
  tel1: $tel1,
  tel2: $tel2,
  webSite: $webSite,
  logoPath: $logoPath,
  grade: $grade,
  status: $status
)
''';
  }
}
