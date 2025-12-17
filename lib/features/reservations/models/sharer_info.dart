import 'package:inta_mobile_pms/features/reservations/models/guest_phone_info.dart';
import 'package:inta_mobile_pms/features/reservations/models/pick_drop_info.dart';

class SharerInfo {
  String? address1;
  String? address2;
  String? allergies;
  DateTime? anniversaryDate;
  int birthCityId;
  int birthCountryId;
  String blackListedReason;
  int? cityId;
  int cityLedgerAccountId;
  String cityName;
  String? civilStatus;
  int countryId;
  String countryName;
  bool createCityLedgerAccount;
  int createdBy;
  double? creditLimit;
  DateTime? dateOfBirth;
  String? designation;
  String email;
  DateTime? expiryDate;
  String fax;
  String firstName;
  int formOfCommunication;
  String? fullAddress;
  String fullNameWithTitle;
  String gender;
  int guestId;
  String? guestIdentityImage;
  List<dynamic> guestIncidents;
  List<GuestPhoneInfo> guestPhoneNumbers;
  String homeTel;
  int identityIssuingCityId;
  int identityIssuingCountryId;
  String identityNumber;
  int identityType;
  String? imagePath;
  bool isAdult;
  bool isBlackListed;
  bool isMainGuest;
  int lastModifiedBy;
  String lastName;
  String mobile;
  int nationalityId;
  PickDropInfo pickUpDropOffDataModel;
  String? remark;
  String rowVersion;
  String? specialReq;
  DateTime? spouseDateOfBirth;
  String state;
  int status;
  String? swipeCardId;
  DateTime sysDateCreated;
  DateTime sysDateLastModified;
  int sysVersion;
  int titleId;
  int vipStatusId;
  String workPlace;
  String zipCode;

  SharerInfo({
    this.address1,
    this.address2,
    this.allergies,
    this.anniversaryDate,
    required this.birthCityId,
    required this.birthCountryId,
    required this.blackListedReason,
    this.cityId,
    required this.cityLedgerAccountId,
    required this.cityName,
    this.civilStatus,
    required this.countryId,
    required this.countryName,
    required this.createCityLedgerAccount,
    required this.createdBy,
    this.creditLimit,
    this.dateOfBirth,
    this.designation,
    required this.email,
    this.expiryDate,
    required this.fax,
    required this.firstName,
    required this.formOfCommunication,
    this.fullAddress,
    required this.fullNameWithTitle,
    required this.gender,
    required this.guestId,
    this.guestIdentityImage,
    required this.guestIncidents,
    required this.guestPhoneNumbers,
    required this.homeTel,
    required this.identityIssuingCityId,
    required this.identityIssuingCountryId,
    required this.identityNumber,
    required this.identityType,
    this.imagePath,
    required this.isAdult,
    required this.isBlackListed,
    required this.isMainGuest,
    required this.lastModifiedBy,
    required this.lastName,
    required this.mobile,
    required this.nationalityId,
    required this.pickUpDropOffDataModel,
    this.remark,
    required this.rowVersion,
    this.specialReq,
    this.spouseDateOfBirth,
    required this.state,
    required this.status,
    this.swipeCardId,
    required this.sysDateCreated,
    required this.sysDateLastModified,
    required this.sysVersion,
    required this.titleId,
    required this.vipStatusId,
    required this.workPlace,
    required this.zipCode,
  });

  factory SharerInfo.fromJson(Map<String, dynamic> json) {
    return SharerInfo(
      address1: json['address1'],
      address2: json['address2'],
      allergies: json['alllergies'],
      anniversaryDate: json['anniversaryDate'] != null
          ? DateTime.parse(json['anniversaryDate'])
          : null,
      birthCityId: json['birthCityId'] ?? 0,
      birthCountryId: json['birthCountryId'] ?? 0,
      blackListedReason: json['blackListedReason'] ?? "",
      cityId: json['cityId'],
      cityLedgerAccountId: json['cityLedgerAccountId'] ?? 0,
      cityName: json['cityName'] ?? "",
      civilStatus: json['civilStatus'],
      countryId: json['countryId'] ?? 0,
      countryName: json['countryName'] ?? "",
      createCityLedgerAccount: json['createCityLedgerAccount'] ?? false,
      createdBy: json['createdBy'] ?? 0,
      creditLimit: json['creditLimit']?.toDouble(),
      dateOfBirth:
          json['dateofBirth'] != null ? DateTime.parse(json['dateofBirth']) : null,
      designation: json['designation'],
      email: json['email'] ?? "",
      expiryDate:
          json['expiryDate'] != null ? DateTime.parse(json['expiryDate']) : null,
      fax: json['fax'] ?? "",
      firstName: json['firstName'] ?? "",
      formOfCommunication: json['formOfCommunication'] ?? 0,
      fullAddress: json['fullAddress'],
      fullNameWithTitle: json['fullNameWithTitle'] ?? "",
      gender: json['gender'] ?? "",
      guestId: json['guestId'] ?? 0,
      guestIdentityImage: json['guestIdentityImage'],
      guestIncidents: json['guestIncidents'] ?? [],
      guestPhoneNumbers: (json['guestPhoneNumbers'] as List<dynamic>)
          .map((e) => GuestPhoneInfo.fromJson(e))
          .toList(),
      homeTel: json['homeTel'] ?? "",
      identityIssuingCityId: json['identityIssuingCityId'] ?? 0,
      identityIssuingCountryId: json['identityIssuingCountryId'] ?? 0,
      identityNumber: json['identityNumber'] ?? "",
      identityType: json['identityType'] ?? 0,
      imagePath: json['imagePath'],
      isAdult: json['isAdult'] ?? true,
      isBlackListed: json['isBlackListed'] ?? false,
      isMainGuest: json['isMainGuest'] ?? true,
      lastModifiedBy: json['lastModifiedBy'] ?? 0,
      lastName: json['lastName'] ?? "",
      mobile: json['mobile'] ?? "",
      nationalityId: json['nationalityId'] ?? 0,
      pickUpDropOffDataModel:
          PickDropInfo.fromJson(json['pickUpDropOffDataModel']),
      remark: json['remark'],
      rowVersion: json['rowVersion'] ?? "",
      specialReq: json['specialReq'],
      spouseDateOfBirth: json['spouseDateofBirth'] != null
          ? DateTime.parse(json['spouseDateofBirth'])
          : null,
      state: json['state'] ?? "",
      status: json['status'] ?? 0,
      swipeCardId: json['swipeCardId'],
      sysDateCreated: DateTime.parse(json['sysDateCreated']),
      sysDateLastModified: DateTime.parse(json['sysDateLastModified']),
      sysVersion: json['sysVersion'] ?? 0,
      titleId: json['titleId'] ?? 0,
      vipStatusId: json['vipStatusId'] ?? 0,
      workPlace: json['workPlace'] ?? "",
      zipCode: json['zipCode'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address1': address1,
      'address2': address2,
      'alllergies': allergies,
      'anniversaryDate': anniversaryDate?.toIso8601String(),
      'birthCityId': birthCityId,
      'birthCountryId': birthCountryId,
      'blackListedReason': blackListedReason,
      'cityId': cityId,
      'cityLedgerAccountId': cityLedgerAccountId,
      'cityName': cityName,
      'civilStatus': civilStatus,
      'countryId': countryId,
      'countryName': countryName,
      'createCityLedgerAccount': createCityLedgerAccount,
      'createdBy': createdBy,
      'creditLimit': creditLimit,
      'dateofBirth': dateOfBirth?.toIso8601String(),
      'designation': designation,
      'email': email,
      'expiryDate': expiryDate?.toIso8601String(),
      'fax': fax,
      'firstName': firstName,
      'formOfCommunication': formOfCommunication,
      'fullAddress': fullAddress,
      'fullNameWithTitle': fullNameWithTitle,
      'gender': gender,
      'guestId': guestId,
      'guestIdentityImage': guestIdentityImage,
      'guestIncidents': guestIncidents,
      'guestPhoneNumbers':
          guestPhoneNumbers.map((e) => e.toJson()).toList(),
      'homeTel': homeTel,
      'identityIssuingCityId': identityIssuingCityId,
      'identityIssuingCountryId': identityIssuingCountryId,
      'identityNumber': identityNumber,
      'identityType': identityType,
      'imagePath': imagePath,
      'isAdult': isAdult,
      'isBlackListed': isBlackListed,
      'isMainGuest': isMainGuest,
      'lastModifiedBy': lastModifiedBy,
      'lastName': lastName,
      'mobile': mobile,
      'nationalityId': nationalityId,
      'pickUpDropOffDataModel': pickUpDropOffDataModel.toJson(),
      'remark': remark,
      'rowVersion': rowVersion,
      'specialReq': specialReq,
      'spouseDateofBirth': spouseDateOfBirth?.toIso8601String(),
      'state': state,
      'status': status,
      'swipeCardId': swipeCardId,
      'sysDateCreated': sysDateCreated.toIso8601String(),
      'sysDateLastModified': sysDateLastModified.toIso8601String(),
      'sysVersion': sysVersion,
      'titleId': titleId,
      'vipStatusId': vipStatusId,
      'workPlace': workPlace,
      'zipCode': zipCode,
    };
  }
}
