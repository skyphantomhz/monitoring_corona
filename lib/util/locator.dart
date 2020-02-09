import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:monitoring_corona/service/monitoring_service.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerLazySingleton<Client>(() => Client());
  getIt.registerLazySingleton<JsonDecoder>(() => JsonDecoder());
  getIt.registerLazySingleton<MonitoringService>(() => MonitoringService());
}