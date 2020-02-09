class TrendlineGlobalCase {
  String date;
  String confirmed;
  String sTypename;

  TrendlineGlobalCase({this.date, this.confirmed, this.sTypename});

  TrendlineGlobalCase.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    confirmed = json['confirmed'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['confirmed'] = this.confirmed;
    data['__typename'] = this.sTypename;
    return data;
  }
}