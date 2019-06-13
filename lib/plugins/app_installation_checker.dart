import 'dart:io';

import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'plugins.dart';

class AppInstallationChecker {
  static const _platform = const MethodChannel(kMethodChannelName);

  Future<bool> isInstalled(String packageName) async {
    if (Platform.isIOS) {
      return canLaunch('$packageName://');
    }
    if (Platform.isAndroid) {
      return _platform.invokeMethod(
        'installation_checker/is_installed',
        {
          'package_name': packageName,
        },
      );
    }
    return null;
  }
}