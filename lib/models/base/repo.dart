import 'package:flutter/foundation.dart';
import 'package:seller_management/main.export.dart';

abstract class Repo {
  @protected
  final ldb = locate<LocalDB>();

  @protected
  final rdb = locate<RemoteDB>();
}
