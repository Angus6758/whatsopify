
import 'package:get_it/get_it.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/network/local_db.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final locate = GetIt.instance;

Future<void> locatorSetUp() async {
  final pref = await SharedPreferences.getInstance();

  locate.registerSingleton<SharedPreferences>(pref);
  locate.registerSingleton<TalkerConfig>(TalkerConfig());
  locate.registerSingleton<LocalDB1>(LocalDB1());
  locate.registerSingleton<RegionRepoEx1>(RegionRepoEx1());
}
