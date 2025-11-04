class MasterData {
        String userName;
        String userId;
        String clientId;
        String menus;
        String privileges;

  MasterData({
    required this.userName,
    required this.userId,
    required this.clientId,
    required this.menus,
    required this.privileges,
  });

  factory MasterData.fromJson(Map<String, dynamic> json) {
    return MasterData(
      userName: json['userName'] ?? '',
      userId: json['userId'] ?? '',
      clientId: json['clientId'] ?? '',
      menus: json['menus'] ?? '',
      privileges: json['privileges'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userId': userId,
      'clientId': clientId,
      'menus': menus,
      'privileges': privileges,
    };
  }
}