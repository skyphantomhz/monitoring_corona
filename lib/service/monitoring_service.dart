import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:monitoring_corona/model/data.dart';
import 'package:monitoring_corona/model/response.dart';

class MonitoringService {
  final http.Client client = GetIt.I<http.Client>();
  final _decoder = GetIt.I<JsonDecoder>();
  final baseRequest = "https://corona-api.kompa.ai/graphql";

  String queryMonitoringWorld;

  Future<Data> fetchWorldData(String query) async {
    final headers = Map<String, String>();
    headers["Content-Type"] = "application/json";
    try {
      final response = await client.post(
        baseRequest,
        body: query,
        headers: headers
      );
      if (response.statusCode == 200) {
        final responseObject =
            Response.fromJson(_decoder.convert(response.body));
        return responseObject.data;
      } else {
        throw Exception("Failed to load route");
      }
    } catch (ex) {
      print("exception ${ex.toString()}");
      throw ex;
    }
  }
}
