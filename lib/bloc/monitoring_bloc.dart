import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:monitoring_corona/model/country.dart';
import 'package:monitoring_corona/model/data.dart';
import 'package:monitoring_corona/service/monitoring_service.dart';
import 'package:rxdart/rxdart.dart';

class MonitoringBloc {
  MonitoringService _service = GetIt.I<MonitoringService>();
  Timer timer;
  final scheduleFetch = const Duration(minutes: 5);

  PublishSubject<Data> _data = PublishSubject<Data>();
  Observable<Data> get data => _data.stream;

  void dispose() {
    _data.close();
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
    _data.sink.add(data);
    print("Data here: "+data.toJson().toString());
  }
}
