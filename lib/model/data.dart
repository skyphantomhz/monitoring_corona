import 'package:monitoring_corona/model/TrendlineGlobalCase.dart';
import 'package:monitoring_corona/model/country.dart';
import 'package:monitoring_corona/model/province.dart';

class Data {
  List<Country> countries;
  List<Province> provinces;
  int totalConfirmedLast;
  List<TrendlineGlobalCase> trendlineGlobalCases;

  Data(
      {this.countries,
      this.provinces,
      this.totalConfirmedLast,
      this.trendlineGlobalCases});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      countries = new List<Country>();
      json['countries'].forEach((v) {
        countries.add(new Country.fromJson(v));
      });
    }
    if (json['provinces'] != null) {
      provinces = new List<Province>();
      json['provinces'].forEach((v) {
        provinces.add(new Province.fromJson(v));
      });
    }
    totalConfirmedLast = json['totalConfirmedLast'];
    if (json['trendlineGlobalCases'] != null) {
      trendlineGlobalCases = new List<TrendlineGlobalCase>();
      json['trendlineGlobalCases'].forEach((v) {
        trendlineGlobalCases.add(new TrendlineGlobalCase.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.countries != null) {
      data['countries'] = this.countries.map((v) => v.toJson()).toList();
    }
    if (this.provinces != null) {
      data['provinces'] = this.provinces.map((v) => v.toJson()).toList();
    }
    data['totalConfirmedLast'] = this.totalConfirmedLast;
    if (this.trendlineGlobalCases != null) {
      data['trendlineGlobalCases'] =
          this.trendlineGlobalCases.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
