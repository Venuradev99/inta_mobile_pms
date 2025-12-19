class HouseKeeper {
  final int userId;
  final String firstName;
  final String lastName;
  final String houseKeeperName;

  HouseKeeper({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.houseKeeperName,
  }) ;

  factory HouseKeeper.fromJson(Map<String, dynamic> json) {
    return HouseKeeper(
      userId: json['userId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      houseKeeperName: json['houseKeeperName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "houseKeeperName": houseKeeperName,
    };
  }
}
