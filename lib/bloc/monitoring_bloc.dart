import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:monitoring_corona/model/country.dart';
import 'package:monitoring_corona/service/monitoring_service.dart';
import 'package:rxdart/rxdart.dart';

class MonitoringBloc {
  MonitoringService _service = GetIt.I<MonitoringService>();
  Timer timer;
  final scheduleFetch = const Duration(minutes: 5);

  PublishSubject<List<Country>> _countries = PublishSubject<List<Country>>();
  Observable<List<Country>> get countries => _countries.stream;

  void dispose() {
    _countries.close();
    timer?.cancel();
  }

  void monitoringWordData(String query) {
    _fetchWorldData(query);
    timer?.cancel();
    timer =
        new Timer.periodic(scheduleFetch, (Timer t) => _fetchWorldData(query));
  }

  void _fetchWorldData(String query) async {
    final data = await _service.fetchWorldData(query);
    _countries.sink.add(data.countries);
    print("Data here: "+data.toJson().toString());
  }
}
