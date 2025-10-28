class UpdateGuestPayload {
  String? address1;
  String? alllergies;
  String? anniversaryDate;
  int? birthCityId;
  int? birthCountryId;
  String? blackListedReason;
  int? cityId;
  String? civilStatus;
  int? countryId;
  String? dateofBirth;
  String? designation;
  String? email;
  String? expiryDate;
  String? fax;
  String? firstName;
  int? formOfCommunication;
  String? fullAddress;
  String? gender;
  List<dynamic>? guestAddresses;
  int? guestId;
  String? guestIdentityImage;
  String? homeTel;
  int? identityIssuingCityId;
  int? identityIssuingCountryId;
  String? identityNumber;
  int? identityType;
  String? imagePath;
  bool? isAdult;
  bool? isBlackListed;
  bool? isMainGuest;
  String? lastName;
  String? mobile;
  int? nationalityId;
  String? phone1;
  String? phone2;
  String? registrationId;
  String? remark;
  int? salutation;
  String? specialReq;
  String? spouseDateofBirth;
  String? state;
  int? status;
  String? swipeCardId;
  int? titleId;
  int? vIPStatusId;
  int? vipStatusId;
  String? workPlace;
  String? zipCode;

  UpdateGuestPayload({
    this.address1,
    this.alllergies,
    this.anniversaryDate,
    this.birthCityId,
    this.birthCountryId,
    this.blackListedReason,
    this.cityId,
    this.civilStatus,
    this.countryId,
    this.dateofBirth,
    this.designation,
    this.email,
    this.expiryDate,
    this.fax,
    this.firstName,
    this.formOfCommunication,
    this.fullAddress,
    this.gender,
    this.guestAddresses,
    this.guestId,
    this.guestIdentityImage,
    this.homeTel,
    this.identityIssuingCityId,
    this.identityIssuingCountryId,
    this.identityNumber,
    this.identityType,
    this.imagePath,
    this.isAdult,
    this.isBlackListed,
    this.isMainGuest,
    this.lastName,
    this.mobile,
    this.nationalityId,
    this.phone1,
    this.phone2,
    this.registrationId,
    this.remark,
    this.salutation,
    this.specialReq,
    this.spouseDateofBirth,
    this.state,
    this.status,
    this.swipeCardId,
    this.titleId,
    this.vIPStatusId,
    this.vipStatusId,
    this.workPlace,
    this.zipCode,
  });

  factory UpdateGuestPayload.fromJson(Map<String, dynamic> json) {
    return UpdateGuestPayload(
      address1: json['address1'],
      alllergies: json['alllergies'],
      anniversaryDate: json['anniversaryDate'],
      birthCityId: json['birthCityId'],
      birthCountryId: json['birthCountryId'],
      blackListedReason: json['blackListedReason'],
      cityId: json['cityId'],
      civilStatus: json['civilStatus'],
      countryId: json['countryId'],
      dateofBirth: json['dateofBirth'],
      designation: json['designation'],
      email: json['email'],
      expiryDate: json['expiryDate'],
      fax: json['fax'],
      firstName: json['firstName'],
      formOfCommunication: json['formOfCommunication'],
      fullAddress: json['fullAddress'],
      gender: json['gender'],
      guestAddresses: json['guestAddresses'],
      guestId: json['guestId'],
      guestIdentityImage: json['guestIdentityImage'],
      homeTel: json['homeTel'],
      identityIssuingCityId: json['identityIssuingCityId'],
      identityIssuingCountryId: json['identityIssuingCountryId'],
      identityNumber: json['identityNumber'],
      identityType: json['identityType'],
      imagePath: json['imagePath'],
      isAdult: json['isAdult'],
      isBlackListed: json['isBlackListed'],
      isMainGuest: json['isMainGuest'],
      lastName: json['lastName'],
      mobile: json['mobile'],
      nationalityId: json['nationalityId'],
      phone1: json['phone1'],
      phone2: json['phone2'],
      registrationId: json['registrationId'],
      remark: json['remark'],
      salutation: json['salutation'],
      specialReq: json['specialReq'],
      spouseDateofBirth: json['spouseDateofBirth'],
      state: json['state'],
      status: json['status'],
      swipeCardId: json['swipeCardId'],
      titleId: json['titleId'],
      vIPStatusId: json['vIPStatusId'],
      vipStatusId: json['vipStatusId'],
      workPlace: json['workPlace'],
      zipCode: json['zipCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address1': address1,
      'alllergies': alllergies,
      'anniversaryDate': anniversaryDate,
      'birthCityId': birthCityId,
      'birthCountryId': birthCountryId,
      'blackListedReason': blackListedReason,
      'cityId': cityId,
      'civilStatus': civilStatus,
      'countryId': countryId,
      'dateofBirth': dateofBirth,
      'designation': designation,
      'email': email,
      'expiryDate': expiryDate,
      'fax': fax,
      'firstName': firstName,
      'formOfCommunication': formOfCommunication,
      'fullAddress': fullAddress,
      'gender': gender,
      'guestAddresses': guestAddresses,
      'guestId': guestId,
      'guestIdentityImage': guestIdentityImage,
      'homeTel': homeTel,
      'identityIssuingCityId': identityIssuingCityId,
      'identityIssuingCountryId': identityIssuingCountryId,
      'identityNumber': identityNumber,
      'identityType': identityType,
      'imagePath': imagePath,
      'isAdult': isAdult,
      'isBlackListed': isBlackListed,
      'isMainGuest': isMainGuest,
      'lastName': lastName,
      'mobile': mobile,
      'nationalityId': nationalityId,
      'phone1': phone1,
      'phone2': phone2,
      'registrationId': registrationId,
      'remark': remark,
      'salutation': salutation,
      'specialReq': specialReq,
      'spouseDateofBirth': spouseDateofBirth,
      'state': state,
      'status': status,
      'swipeCardId': swipeCardId,
      'titleId': titleId,
      'vIPStatusId': vIPStatusId,
      'vipStatusId': vipStatusId,
      'workPlace': workPlace,
      'zipCode': zipCode,
    };
  }

  @override
  String toString() {
    return 'UpdateGuestPayload(firstName: $firstName, email: $email, mobile: $mobile, countryId: $countryId, guestId: $guestId)';
  }
}
