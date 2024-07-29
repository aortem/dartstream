import 'package:flutter/material.dart';

extension NumExtension on num {
  EdgeInsets get horizontal {
    return EdgeInsets.symmetric(horizontal: toDouble());
  }

  EdgeInsets get vertical {
    return EdgeInsets.symmetric(vertical: toDouble());
  }

  EdgeInsets get all {
    return EdgeInsets.symmetric(
      horizontal: toDouble(),
      vertical: toDouble(),
    );
  }

  SizedBox get hSpace {
    return SizedBox(
      width: toDouble(),
    );
  }

  SizedBox get vSpace {
    return SizedBox(
      height: toDouble(),
    );
  }
}
