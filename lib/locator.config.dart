// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:seller_management/_core/common/file_picker.dart' as _i8;
import 'package:seller_management/_core/database/local_db.dart' as _i5;
import 'package:seller_management/_core/database/remote_db.dart' as _i4;
import 'package:seller_management/_core/network/dio_client.dart' as _i6;
import 'package:seller_management/features/add_product/repository/add_product_repo.dart'
as _i12;
import 'package:seller_management/features/auth/repository/auth_repo.dart'
as _i14;
import 'package:seller_management/features/campaign/repository/campaign_repo.dart'
as _i21;
import 'package:seller_management/features/chat/repository/chat_repo.dart'
as _i13;
import 'package:seller_management/features/dashboard/repository/dash_repo.dart'
as _i19;
import 'package:seller_management/features/order/repository/order_repo.dart'
as _i9;
import 'package:seller_management/features/product/repository/product_repo.dart'
as _i16;
import 'package:seller_management/features/product/view/network/local_db.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';
import 'package:seller_management/features/region/repository/region_repo.dart'
as _i20;
import 'package:seller_management/features/seller_info/repository/seller_info_repo.dart'
as _i11;
import 'package:seller_management/features/settings/repository/settings_repo.dart'
as _i10;
import 'package:seller_management/features/subscription/repository/subscription_repo.dart'
as _i18;
import 'package:seller_management/features/support_ticket/repository/ticket_repository.dart'
as _i15;
import 'package:seller_management/features/total_balance/repository/total_balance_repo.dart'
as _i17;
import 'package:seller_management/features/withdraw/repository/withdraw_repo.dart'
as _i22;
import 'package:seller_management/locator.dart' as _i23;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    // await gh.factoryAsync<_i3.SharedPreferences>(
    // //  () => registerModule.prefs,
    //   preResolve: true,
    // );
    gh.singleton<_i5.LocalDB>(() => _i5.LocalDB());
    gh.singleton<_i8.FilePickerRepo>(() => _i8.FilePickerRepo());
    gh.singleton<_i6.DioClient>(() => _i6.DioClient());
    gh.singleton<_i4.RemoteDB>(() => _i4.RemoteDB());
    gh.singleton<_i20.RegionRepo>(() => _i20.RegionRepo());
    gh.singleton<_i14.AuthRepo>(() => _i14.AuthRepo());
    gh.singleton<_i19.DashboardRepo>(() => _i19.DashboardRepo());
    gh.singleton<_i9.OrderRepository>(() => _i9.OrderRepository());
    gh.singleton<_i10.SettingsRepo>(() => _i10.SettingsRepo());
    gh.singleton<_i11.SellerRepo>(() => _i11.SellerRepo());
    gh.singleton<_i12.AddProductRepo>(() => _i12.AddProductRepo());
    gh.singleton<_i13.ChatRepo>(() => _i13.ChatRepo());
    gh.singleton<_i15.TicketRepo>(() => _i15.TicketRepo());
    gh.singleton<_i16.ProductRepo>(() => _i16.ProductRepo());
    gh.singleton<_i17.TransactionRepo>(() => _i17.TransactionRepo());
    gh.singleton<_i18.SubscriptionRepo>(() => _i18.SubscriptionRepo());
    gh.singleton<_i21.CampaignRepo>(() => _i21.CampaignRepo());
    gh.singleton<_i22.WithdrawRepo>(() => _i22.WithdrawRepo());
    return this;
  }
}

class _$RegisterModule extends _i23.RegisterModule {

}