import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_corona/bloc/monitoring_bloc.dart';
import 'package:monitoring_corona/model/history_confirmed.dart';
import 'package:monitoring_corona/widget/chart_fragment.dart';

import 'map.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.bannerAd}) : super(key: key);
  final BannerAd bannerAd;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
MonitoringBloc _monitoringBloc;
List<HistoryConfirmed> historyConfirmeds;
@override
  void initState() {
    super.initState();
    _monitoringBloc = BlocProvider.of<MonitoringBloc>(context);
    _setListener();
  }

  void _setListener(){
    _monitoringBloc.data.listen((data){
      setState(() {
        historyConfirmeds = data.historyConfirmeds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height: 150,
              decoration: BoxDecoration(color: Colors.amber),
              child: Center(
                child: _headerView(),
              )),
          Expanded(child: MapSample()),
        ],
      ),
    );
  }

  Widget _headerView() {
    if(historyConfirmeds == null || historyConfirmeds.length == 0){
      return Center(child: Text("No data"),);
    }else{
      return ChartFragment( historyConfirmeds, animate: true,);
    }
  }
}
