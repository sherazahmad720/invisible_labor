import 'package:flutter/widgets.dart';

extension Sizes on num {
  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get horizontalSpace => SizedBox(height: toDouble());
}
