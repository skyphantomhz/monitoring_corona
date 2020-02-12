import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_corona/model/history_confirmed.dart';

class ChartFragment extends StatelessWidget {
  ChartFragment(List<HistoryConfirmed> historyConfirmeds, {Key key, this.animate, }) : super(key: key){
    _convertData(historyConfirmeds);
  }

  List<Series> seriesList;
  final bool animate;


  @override
  Widget build(BuildContext context) {
    return LineChart(
      seriesList,
      defaultRenderer: LineRendererConfig(includeArea: true, stacked: true),
      animate: animate,
    );
  }

  List<Series<LinearConfimed, int>> _convertData(List<HistoryConfirmed> historyConfirmeds) {
    final mainlandChinaData = historyConfirmeds.map((historyConfirmed){
      LinearConfimed(int.parse(historyConfirmed.mainlandChina), int.parse(historyConfirmed.reportDate));
    }).toList();

    var otherLocationsData = historyConfirmeds.map((historyConfirmed){
      LinearConfimed(int.parse(historyConfirmed.otherLocations), int.parse(historyConfirmed.reportDate));
    }).toList();

    return [
      Series<LinearConfimed, int>(
        id: 'Other Locations',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (LinearConfimed data, _) => data.date,
        measureFn: (LinearConfimed data, _) => data.comfirmed,
        data: otherLocationsData,
      ),
      Series<LinearConfimed, int>(
        id: 'Mainland China',
        colorFn: (_, __) => MaterialPalette.red.shadeDefault,
        domainFn: (LinearConfimed data, _) => data.date,
        measureFn: (LinearConfimed data, _) => data.comfirmed,
        data: mainlandChinaData,
      ),
    ];
  }
}

class LinearConfimed {
  final int comfirmed;
  final int date;

  LinearConfimed(this.comfirmed, this.date);
}
