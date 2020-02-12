import 'dart:async';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:monitoring_corona/bloc/monitoring_bloc.dart';
import 'package:monitoring_corona/util/locator.dart';
import 'package:monitoring_corona/widget/homepage.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  setupLocator();

  runZoned(() {
    runApp(BlocProvider<MonitoringBloc>(
        creator: (_context, _bag) => MonitoringBloc(), child: MyApp()));
  }, onError: Crashlytics.instance.recordError);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'flutter',
      'great app',
      'food',
      'drink',
      'corona',
      'china'
    ],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );
  BannerAd _bannerAd;

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-7567000157197488~3332660956");
    _bannerAd = createBannerAd()..load();
    super.initState();
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: "ca-app-pub-7567000157197488/4377955790",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: HomePage(bannerAd: _bannerAd),
      ),
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}
