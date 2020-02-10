class HistoryConfirmed {
  String reportDate;
  String mainlandChina;
  String otherLocations;
  String sTypename;

  HistoryConfirmed(
      {this.reportDate,
      this.mainlandChina,
      this.otherLocations,
      this.sTypename});

  HistoryConfirmed.fromJson(Map<String, dynamic> json) {
    reportDate = json['Report_Date'];
    mainlandChina = json['Mainland_China'];
    otherLocations = json['Other_Locations'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Report_Date'] = this.reportDate;
    data['Mainland_China'] = this.mainlandChina;
    data['Other_Locations'] = this.otherLocations;
    data['__typename'] = this.sTypename;
    return data;
  }
}