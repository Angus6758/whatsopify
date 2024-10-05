
import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/content/campaign_models.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';

class CampaignDetails {
  CampaignDetails({
    required this.campaign,
    required this.products,
  });

  factory CampaignDetails.fromMap(Map<String, dynamic> map) {
    if (!map.containsKey('campaign') || map['campaign'] == null || !map['campaign'].containsKey('uid') || map['campaign']['uid'] == null) {
      print('Warning: Campaign UID is missing or null');
    } else {
      print('Campaign UID: ${map['campaign']['uid']}'); // For debugging
    }
    return CampaignDetails(
      campaign: CampaignModel.fromMap(map['campaign']),
      products: ItemListWithPageData<ProductsData>.fromMap(
          map['products'], (x) => ProductsData.fromMap(x)),
    );
  }
  final CampaignModel campaign;
  final ItemListWithPageData<ProductsData> products;

  CampaignDetails copyWith({
    CampaignModel? campaign,
    ItemListWithPageData<ProductsData>? products,
  }) {
    return CampaignDetails(
      campaign: campaign ?? this.campaign,
      products: products ?? this.products,
    );
  }

  CampaignDetails updateList(List<ProductsData> products) {
    return CampaignDetails(
      campaign: campaign,
      products: this.products.copyWith(listData: products),
    );
  }
}
