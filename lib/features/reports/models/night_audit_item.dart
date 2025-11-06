class NightAuditItem {
  final String? description;
  final String? sysDateCreated;
  final String? transactionType;
  final int? userId;
  final String? userName;
  final String? transactionTypeName;
  final int? hotelId;

  NightAuditItem({
    this.description,
    this.sysDateCreated,
    this.transactionType,
    this.userId,
    this.userName,
    this.transactionTypeName,
    this.hotelId,
  });

  factory NightAuditItem.fromJson(Map<String, dynamic> json) {
    return NightAuditItem(
      description: json['description'],
      sysDateCreated: json['sys_DateCreated'],
      transactionType: json['transactionType'],
      userId: json['userId'],
      userName: json['userName'],
      transactionTypeName: json['transactionTypeName'],
      hotelId: json['hotelId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'sys_DateCreated': sysDateCreated,
      'transactionType': transactionType,
      'userId': userId,
      'userName': userName,
      'transactionTypeName': transactionTypeName,
      'hotelId': hotelId,
    };
  }

  @override
  String toString() {
    return 'NightAuditItem('
        'description: $description, '
        'sysDateCreated: $sysDateCreated, '
        'transactionType: $transactionType, '
        'userId: $userId, '
        'userName: $userName, '
        'transactionTypeName: $transactionTypeName, '
        'hotelId: $hotelId'
        ')';
  }
}
