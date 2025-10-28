class CountryResponse {
  final int countryId;
  final int regionId;
  final String countryName;
  final String? regDate;
  final int userId;
  final String? sortId;
  final String deviceId;
  final String? dtVersion;
  final List<CityResponse> cities;

  CountryResponse({
    required this.countryId,
    required this.regionId,
    required this.countryName,
    this.regDate,
    required this.userId,
    this.sortId,
    required this.deviceId,
    this.dtVersion,
    required this.cities,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      countryId: json['countryId'] ?? 0,
      regionId: json['regionId'] ?? 0,
      countryName: json['countryName'] ?? '',
      regDate: json['regDate'],
      userId: json['userId'] ?? 0,
      sortId: json['sortId']?.toString(),
      deviceId: json['deviceId'] ?? '',
      dtVersion: json['dt_Version'],
      cities: (json['cities'] as List<dynamic>?)
              ?.map((e) => CityResponse.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryId': countryId,
      'regionId': regionId,
      'countryName': countryName,
      'regDate': regDate,
      'userId': userId,
      'sortId': sortId,
      'deviceId': deviceId,
      'dt_Version': dtVersion,
      'cities': cities.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'CountryResponse(countryId: $countryId, regionId: $regionId, countryName: $countryName, '
        'regDate: $regDate, userId: $userId, sortId: $sortId, deviceId: $deviceId, '
        'dtVersion: $dtVersion, cities: $cities)';
  }
}

class CityResponse {
  final int cityId;
  final int countryId;
  final String cityName;
  final String? regDate;
  final int userId;
  final int? indexId;
  final String? deviceId;
  final String? dtVersion;
  final String? sysDateCreated;
  final String? sysDateLastModified;
  final int? sysVersion;
  final int? createdBy;
  final int? lastModifiedBy;
  final String? rowVersion;
  final int status;

  CityResponse({
    required this.cityId,
    required this.countryId,
    required this.cityName,
    this.regDate,
    required this.userId,
    this.indexId,
    this.deviceId,
    this.dtVersion,
    this.sysDateCreated,
    this.sysDateLastModified,
    this.sysVersion,
    this.createdBy,
    this.lastModifiedBy,
    this.rowVersion,
    required this.status,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      cityId: json['cityId'] ?? 0,
      countryId: json['countryId'] ?? 0,
      cityName: json['cityName'] ?? '',
      regDate: json['regDate'],
      userId: json['userId'] ?? 0,
      indexId: json['indexId'],
      deviceId: json['deviceId'],
      dtVersion: json['dt_Version'],
      sysDateCreated: json['sysDateCreated'],
      sysDateLastModified: json['sysDateLastModified'],
      sysVersion: json['sysVersion'],
      createdBy: json['createdBy'],
      lastModifiedBy: json['lastModifiedBy'],
      rowVersion: json['rowVersion'],
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'countryId': countryId,
      'cityName': cityName,
      'regDate': regDate,
      'userId': userId,
      'indexId': indexId,
      'deviceId': deviceId,
      'dt_Version': dtVersion,
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
    return 'CityResponse(cityId: $cityId, countryId: $countryId, cityName: $cityName, '
        'regDate: $regDate, userId: $userId, indexId: $indexId, deviceId: $deviceId, '
        'dtVersion: $dtVersion, sysDateCreated: $sysDateCreated, sysDateLastModified: $sysDateLastModified, '
        'sysVersion: $sysVersion, createdBy: $createdBy, lastModifiedBy: $lastModifiedBy, '
        'rowVersion: $rowVersion, status: $status)';
  }
}
