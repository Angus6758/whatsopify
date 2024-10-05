import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Default scroll physics for scrollable widgets
const AlwaysScrollableScrollPhysics kDefaultScrollPhysics =
    AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());

/// Default app constants string
class AppDefaults {
  const AppDefaults._();
  static const appName = 'Whatsopify';
}

String kErrorMessage([String errorOn = '']) =>
    'Something went wrong ${kDebugMode ? '[$errorOn]' : ''}';

class AppLayout {
  const AppLayout._();

  static const double maxMobile = 600.0;
  static const double maxDesktop = 1200.0;
  static const double maxTab = 800.0;
}

/// Default durations for animations
class Times {
  const Times._();

  /// 250 ms
  static const Duration def = fast;

  /// 250 ms
  static const Duration fast = Duration(milliseconds: 250);

  /// 150 ms
  static const Duration fastest = Duration(milliseconds: 150);

  /// 350 ms
  static const Duration medium = Duration(milliseconds: 350);

  /// 500 ms
  static const Duration slow = Duration(milliseconds: 700);

  /// 1000 ms
  static const Duration slower = Duration(milliseconds: 1000);

  /// 2000 ms
  static const Duration extraSlow = Duration(milliseconds: 2000);

  /// easeInOutCubic
  static const Curve defaultCurve = Curves.easeInOutCubic;
}

class Insets {
  const Insets._();

  /// 10px
  static const double def = med;

  /// 3 px
  static const double xs = 3;

  /// 5 px
  static const double sm = 5;

  /// 10 px
  static const double med = 10;

  /// 15 px
  static const double lg = 15;

  /// 20 px
  static const double xl = 20;

  /// 40 px
  static const double offset = 40;

  /// uses [med] as default padding (10 px)
  static const padAll = EdgeInsets.all(med);

  /// uses [med] as horizontal padding (10 px)
  static const padH = EdgeInsets.symmetric(horizontal: med);

  /// uses [med] as vertical padding (10 px)
  static const padV = EdgeInsets.symmetric(vertical: med);

  /// uses [med] as vertical padding (10 px)
  static padSym([double v = med, double h = med]) =>
      EdgeInsets.symmetric(vertical: v, horizontal: h);

  static padOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      );
}

class Corners {
  const Corners._();

  /// 13 px
  static const double lg = 13;

  /// 13 px radius
  static const Radius lgRadius = Radius.circular(lg);

  /// 13 px border radius
  static const BorderRadius lgBorder = BorderRadius.all(lgRadius);

  /// 8 px
  static const double med = 8;

  /// 8 px radius
  static const Radius medRadius = Radius.circular(med);

  /// 8 px border radius
  static const BorderRadius medBorder = BorderRadius.all(medRadius);

  /// 5 px
  static const double sm = 5;

  /// 5 px radius
  static const Radius smRadius = Radius.circular(sm);

  /// 5 px border radius
  static const BorderRadius smBorder = BorderRadius.all(smRadius);

  static const BorderRadius circle = BorderRadius.all(Radius.circular(180));
}
