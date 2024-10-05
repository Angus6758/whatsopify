import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/network/local_db.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';
import 'package:seller_management/main.export.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'locator.config.dart';

final locate = GetIt.instance;

@module
abstract class RegisterModule {
  // @preResolve
  // Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

}

@InjectableInit()
configureDependencies() async {
  locate.registerSingleton<EventStreamer>(EventStreamer());
  await locate.init();
  locate.registerSingleton<PDFCtrl>(PDFCtrl());
}
