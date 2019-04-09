import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class Analytics {
  final FirebaseAnalytics analytics = FirebaseAnalytics();
  RouteObserver get observer => FirebaseAnalyticsObserver(analytics: analytics);
}
