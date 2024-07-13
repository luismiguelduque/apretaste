import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashMonitoringService {
  init() async {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
}
