class Province {
  String provinceName;
  String confirmed;
  String deaths;
  String recovered;
  String sTypename;
  String lat;
  String long;

  Province(
      {this.provinceName,
      this.confirmed,
      this.deaths,
      this.lat,
      this.long,
      this.recovered,
      this.sTypename});

  Province.fromJson(Map<String, dynamic> json) {
    provinceName = json['Province_Name'];
    confirmed = json['Confirmed'];
    deaths = json['Deaths'];
    lat = json['Lat'];
    long = json['Long'];
    recovered = json['Recovered'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Province_Name'] = this.provinceName;
    data['Confirmed'] = this.confirmed;
    data['Deaths'] = this.deaths;
    data['Lat'] = this.lat;
    data['Long'] = this.long;
    data['Recovered'] = this.recovered;
    data['__typename'] = this.sTypename;
    return data;
  }
}
