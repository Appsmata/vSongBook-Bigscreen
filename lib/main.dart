import 'package:debug_mode/debug_mode.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vsongbook/helpers/AppSettings.dart';
import 'package:vsongbook/screens/AppSplash.dart';
import 'package:vsongbook/screens/AppStart.dart';
import 'package:vsongbook/utils/Themes.dart';

void main() {
  Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApplication());
}

class MyApplication extends StatelessWidget {
  const MyApplication({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) {
          return AppSplash();
        }
        return ChangeNotifierProvider<AppSettings>.value(
          value: AppSettings(snapshot.data),
          child: _MyApplication(),
        );
      },
    );
  }
}

class _MyApplication extends StatelessWidget {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'vSongBook',
      theme: Provider.of<AppSettings>(context).isDarkMode
          ? asDarkTheme
          : asLightTheme,
      home: new AppStart(),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
