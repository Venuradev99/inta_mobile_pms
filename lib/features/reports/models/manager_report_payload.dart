class ManagerReportPayload {
  final int currency;
  final int reportId;
  final String selectedDate;
  final String hotelIdsList;

  ManagerReportPayload({
    required this.currency,
    required this.reportId,
    required this.selectedDate,
    required this.hotelIdsList,
  });

  // Factory constructor to create an instance from JSON
  factory ManagerReportPayload.fromJson(Map<String, dynamic> json) {
    return ManagerReportPayload(
      currency: json['Currency'] ?? 0,
      reportId: json['ReportId'] ?? 0,
      selectedDate: json['SelectedDate'] ?? '',
      hotelIdsList: json['hotelIdsList'] ?? '',
    );
  }

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Currency': currency,
      'ReportId': reportId,
      'SelectedDate': selectedDate,
      'hotelIdsList': hotelIdsList,
    };
  }

  // Override toString for easy debugging
  @override
  String toString() {
    return 'ManagerReportPayload(currency: $currency, reportId: $reportId, selectedDate: $selectedDate, hotelIdsList: $hotelIdsList)';
  }
}
