class Country {
  String countryRegion;
  String lat;
  String long;
  String confirmed;
  String deaths;
  String recovered;
  String sTypename;

  Country(
      {this.countryRegion,
      this.lat,
      this.long,
      this.confirmed,
      this.deaths,
      this.recovered,
      this.sTypename});

  Country.fromJson(Map<String, dynamic> json) {
    countryRegion = json['Country_Region'];
    lat = json['Lat'];
    long = json['Long_'];
    confirmed = json['Confirmed'];
    deaths = json['Deaths'];
    recovered = json['Recovered'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Country_Region'] = this.countryRegion;
    data['Lat'] = this.lat;
    data['Long_'] = this.long;
    data['Confirmed'] = this.confirmed;
    data['Deaths'] = this.deaths;
    data['Recovered'] = this.recovered;
    data['__typename'] = this.sTypename;
    return data;
  }
}