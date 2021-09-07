import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

/*
Source:https://gist.github.com/recycledhumanoid/9d27fd81d1baa52aa817fb40c29ffd83
 */

enum PlatformType { iOS, android, web, Null }

class PlatformService {
  static bool isIOS() {
    bool result = false;
    if (kIsWeb) {
      _iOSTypes.forEach((name) {
        if (html.window.navigator.platform!.contains(name) ||
            html.window.navigator.userAgent.contains(name)) {
          result = true;
        }
      });
    } else if (Platform.isIOS) {
      result = true;
    }
    return result;
  }

  static bool isAndroid() {
    bool result = false;
    if (kIsWeb) {
      result = html.window.navigator.platform == 'Android' ||
          html.window.navigator.userAgent.contains('Android');
    } else if (Platform.isAndroid) {
      result = true;
    }
    return result;
  }

  static bool isWeb() {
    return !isIOS() && !isAndroid();
  }

  static PlatformType platformType() {
    if (isIOS()) {
      return PlatformType.iOS;
    }
    if (isAndroid()) {
      return PlatformType.android;
    }
    if (isWeb()) {
      return PlatformType.web;
    }
    return PlatformType.Null;
  }

  static const List<String> _iOSTypes = [
    'iPad Simulator',
    'iPhone Simulator',
    'iPod Simulator',
    'iPad',
    'iPhone',
    'iPod',
  ];
}
