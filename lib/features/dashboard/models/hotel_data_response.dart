class HotelDataResponse {
  final int hotelId;
  final String hotelName;
  final String address1;
  final String address2;
  final int cityId;
  final String postCode;
  final int countryId;
  final String state;
  final String tel1;
  final String tel2;
  final String fax;
  final String email;
  final String propertyType;
  final String logoPath;
  final String webSite;
  final int grade;
  final String regNo1;
  final String regNo2;
  final String regNo3;
  final String hotelPolicy;
  final String cancellationPolicy;
  final String deviceId;
  final int dtVersion;
  final int cmIntegrationType;
  final int accIntegrationType;
  final String sysDateCreated;
  final String sysDateLastModified;
  final int sysVersion;
  final int createdBy;
  final int lastModifiedBy;
  final String rowVersion;
  final int status;

  HotelDataResponse({
    required this.hotelId,
    required this.hotelName,
    required this.address1,
    required this.address2,
    required this.cityId,
    required this.postCode,
    required this.countryId,
    required this.state,
    required this.tel1,
    required this.tel2,
    required this.fax,
    required this.email,
    required this.propertyType,
    required this.logoPath,
    required this.webSite,
    required this.grade,
    required this.regNo1,
    required this.regNo2,
    required this.regNo3,
    required this.hotelPolicy,
    required this.cancellationPolicy,
    required this.deviceId,
    required this.dtVersion,
    required this.cmIntegrationType,
    required this.accIntegrationType,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.createdBy,
    required this.lastModifiedBy,
    required this.rowVersion,
    required this.status,
  });

  factory HotelDataResponse.fromJson(Map<String, dynamic> json) {
    return HotelDataResponse(
      hotelId: json['hotelId'] ?? 0,
      hotelName: json['hotelName'] ?? '',
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      cityId: json['cityId'] ?? 0,
      postCode: json['postCode'] ?? '',
      countryId: json['countryId'] ?? 0,
      state: json['state'] ?? '',
      tel1: json['tel1'] ?? '',
      tel2: json['tel2'] ?? '',
      fax: json['fax'] ?? '',
      email: json['email'] ?? '',
      propertyType: json['propertyType'] ?? '',
      logoPath: json['logoPath'] ?? '',
      webSite: json['webSite'] ?? '',
      grade: json['grade'] ?? 0,
      regNo1: json['regNo1'] ?? '',
      regNo2: json['regNo2'] ?? '',
      regNo3: json['regNo3'] ?? '',
      hotelPolicy: json['hotelPolicy'] ?? '',
      cancellationPolicy: json['cancellationPolicy'] ?? '',
      deviceId: json['deviceId'] ?? '',
      dtVersion: json['dt_Version'] ?? 0,
      cmIntegrationType: json['cmIntegrationType'] ?? 0,
      accIntegrationType: json['accIntegrationType'] ?? 0,
      sysDateCreated: json['sysDateCreated'] ?? '',
      sysDateLastModified: json['sysDateLastModified'] ?? '',
      sysVersion: json['sysVersion'] ?? 0,
      createdBy: json['createdBy'] ?? 0,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      rowVersion: json['rowVersion'] ?? '',
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotelId': hotelId,
      'hotelName': hotelName,
      'address1': address1,
      'address2': address2,
      'cityId': cityId,
      'postCode': postCode,
      'countryId': countryId,
      'state': state,
      'tel1': tel1,
      'tel2': tel2,
      'fax': fax,
      'email': email,
      'propertyType': propertyType,
      'logoPath': logoPath,
      'webSite': webSite,
      'grade': grade,
      'regNo1': regNo1,
      'regNo2': regNo2,
      'regNo3': regNo3,
      'hotelPolicy': hotelPolicy,
      'cancellationPolicy': cancellationPolicy,
      'deviceId': deviceId,
      'dt_Version': dtVersion,
      'cmIntegrationType': cmIntegrationType,
      'accIntegrationType': accIntegrationType,
      'sysDateCreated': sysDateCreated,
      'sysDateLastModified': sysDateLastModified,
      'sysVersion': sysVersion,
      'createdBy': createdBy,
      'lastModifiedBy': lastModifiedBy,
      'rowVersion': rowVersion,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Hotel(hotelId: $hotelId, hotelName: $hotelName, address1: $address1, address2: $address2, cityId: $cityId, postCode: $postCode, countryId: $countryId, state: $state, tel1: $tel1, tel2: $tel2, email: $email, propertyType: $propertyType)';
  }
}
