import 'package:flutter/widgets.dart';

extension Sizes on num {
  SizedBox get width => SizedBox(width: toDouble());
  SizedBox get height => SizedBox(height: toDouble());
}
