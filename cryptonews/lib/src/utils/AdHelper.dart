import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-5737865687071695/4470911365';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw new UnsupportedError("Unsupported platform");
  }

  static String get interAdUnitId {
    if (Platform.isAndroid) {
      //return "ca-app-pub-5737865687071695/4571440563";
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_NATIVE_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5737865687071695/6693109390";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_NATIVE_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
