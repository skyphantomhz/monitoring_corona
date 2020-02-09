class Province {
  String confirmed;
  String deaths;
  String recovered;
  String sTypename;

  Province({this.confirmed, this.deaths, this.recovered, this.sTypename});

  Province.fromJson(Map<String, dynamic> json) {
    confirmed = json['Confirmed'];
    deaths = json['Deaths'];
    recovered = json['Recovered'];
    sTypename = json['__typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Confirmed'] = this.confirmed;
    data['Deaths'] = this.deaths;
    data['Recovered'] = this.recovered;
    data['__typename'] = this.sTypename;
    return data;
  }
}