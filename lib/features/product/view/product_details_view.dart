// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:seller_management/_core/lang/locale_keys.g.dart';
// import 'package:seller_management/features/product/controller/product_ctrl.dart';
// import 'package:seller_management/main.export.dart';
// import 'package:seller_management/routes/go_route_config.dart';
// import 'package:seller_management/routes/go_route_name.dart';
//
// import 'local/add_attribute_value.dart';
// import 'local/add_digital_product_attribute.dart';
// import 'local/digital_attribute_table.dart';
// import 'local/tax_dialog.dart';
// import 'local/top_button.dart';
//
// class ProductDetailsView extends HookConsumerWidget {
//   const ProductDetailsView(this.id, {super.key});
//      print("we are in the ProductDetailsView original");
//   final String id;
//
//   Future<dynamic> _showTaxDialog(BuildContext context, List<Tax> taxes) {
//     return showDialog(
//       context: context,
//       builder: (context) => TaxDialog(taxes: taxes),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final productDetails = ref.watch(productDetailsCtrlProvider(id));
//     final productCtrl =
//         useCallback(() => ref.read(productDetailsCtrlProvider(id).notifier));
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           LocaleKeys.product_details.tr(),
//         ),
//         actions: [
//           productDetails.maybeWhen(
//             orElse: () => const SizedBox.shrink(),
//             data: (data) => TextButton.icon(
//               onPressed: () {
//                 if (data.isPhysical) {
//                   RouteNames.addProduct.pushNamed(context, extra: data);
//                 } else {
//                   RouteNames.addDigitalProduct.pushNamed(context, extra: data);
//                 }
//               },
//               icon: Icon(
//                 Icons.edit,
//                 size: 20,
//                 color: context.colorTheme.onPrimary,
//               ),
//               label: Text(
//                 LocaleKeys.edit.tr(),
//                 style: TextStyle(
//                   color: context.colorTheme.onPrimary,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: productDetails.when(
//         loading: Loader.new,
//         error: ErrorView.new,
//         data: (product) => RefreshIndicator(
//           onRefresh: () async => productCtrl().reload(),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: Insets.padH.copyWith(top: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CarouselSlider.builder(
//                     options: CarouselOptions(
//                       enlargeFactor: 0,
//                       clipBehavior: Clip.none,
//                       viewportFraction: 1,
//                       initialPage: 0,
//                       height: 250,
//                       autoPlay: true,
//                     ),
//                     itemCount: product.featuredImage.length,
//                     itemBuilder: (context, index, realIndex) {
//                       return ClipRRect(
//                         borderRadius: Corners.smBorder,
//                         child: HostedImage(product.featuredImage),
//                       );
//                     },
//                   ),
//                   const Gap(Insets.lg),
//                   Text(
//                     product.name,
//                     style: context.textTheme.titleLarge,
//                   ),
//                   const Gap(Insets.sm),
//                   if (product.isPhysical) ...[
//                     const Gap(Insets.sm),
//                     Text(
//                       'Price : ${product.price}',
//                       style: context.textTheme.titleMedium?.copyWith(
//                         color: context.colorTheme.primary,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Gap(Insets.sm),
//                     Text(
//                       'Discount price : ${product.discount} (${product.discountPercentage}%)',
//                       style: context.textTheme.bodyLarge,
//                     ),
//                   ],
//                   const Gap(Insets.sm),
//                   if (product.tax.isNotEmpty)
//                     GestureDetector(
//                       onTap: () => _showTaxDialog(context, product.tax),
//                       child: DecoratedContainer(
//                         borderColor: context.colorTheme.primary,
//                         borderWidth: 1,
//                         borderRadius: Corners.sm,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 5,
//                           vertical: 3,
//                         ),
//                         child: Text(
//                           'Tax info',
//                           style: context.textTheme.titleMedium?.copyWith(
//                             color: context.colorTheme.primary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   const Gap(Insets.sm),
//                   Text(
//                     'Weight : ${product.weight}',
//                     style: context.textTheme.bodyLarge,
//                   ),
//                   const Gap(Insets.sm),
//                   Text(
//                     'Shipping Fee : ${product.shippingFee}',
//                     style: context.textTheme.bodyLarge,
//                   ),
//                   const Gap(Insets.sm),
//                   if (product.category.name.isNotEmpty)
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 5),
//                             decoration: BoxDecoration(
//                               color:
//                                   context.colorTheme.onSurface.withOpacity(.1),
//                               borderRadius: Corners.smBorder,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10.0, vertical: 5),
//                               child: Text(
//                                 product.category.name,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   if (product.subCategory != null)
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           Container(
//                             margin: const EdgeInsets.symmetric(vertical: 5),
//                             decoration: BoxDecoration(
//                               color:
//                                   context.colorTheme.onSurface.withOpacity(.1),
//                               borderRadius: Corners.smBorder,
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10.0, vertical: 5),
//                               child: Text(
//                                 product.subCategory!.name,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   const Gap(Insets.med),
//                   if (product.stock.isNotEmpty)
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               LocaleKeys.product_attribute.tr(),
//                               style: context.textTheme.bodyLarge!.copyWith(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Gap(Insets.med),
//                         ShadowContainer(
//                           child: Padding(
//                             padding: Insets.padAll,
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             LocaleKeys.attribute.tr(),
//                                             style: context.textTheme.bodyLarge,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             LocaleKeys.stock.tr(),
//                                             style: context.textTheme.bodyLarge,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             LocaleKeys.price.tr(),
//                                             style: context.textTheme.bodyLarge,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(),
//                                 ListView.builder(
//                                   physics: const NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemCount: product.stock.length,
//                                   itemBuilder: (context, index) {
//                                     final stock = product.stock[index];
//                                     return Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 5.0),
//                                       child: Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Column(
//                                                   children: [
//                                                     Text(
//                                                       stock.attribute,
//                                                       textAlign:
//                                                           TextAlign.center,
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Text(
//                                                   stock.qty,
//                                                   textAlign: TextAlign.center,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Center(
//                                                   child: Text(
//                                                     stock.price.formate(),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   const Gap(Insets.lg),
//                   Row(
//                     children: [
//                       TopButton(
//                         title: LocaleKeys.total_order.tr(),
//                         count: product.totalOrderCount.toString(),
//                         color: context.colorTheme.primary,
//                         onTap: () {},
//                       ),
//                       const Gap(Insets.sm),
//                       TopButton(
//                         title: LocaleKeys.placed_order.tr(),
//                         count: product.totalPlacedOrder.toString(),
//                         color: context.colorTheme.secondary,
//                         onTap: () {},
//                       ),
//                       const Gap(Insets.sm),
//                       TopButton(
//                         title: LocaleKeys.delivered_order.tr(),
//                         count: product.totalDeliveredOrder.toString(),
//                         color: context.colorTheme.errorContainer,
//                         onTap: () {},
//                       ),
//                     ],
//                   ),
//                   if (product.digitalAttributes.isNotEmpty) ...[
//                     const Gap(Insets.lg),
//                     DigitalAttributeList(product: product),
//                     const Gap(Insets.lg),
//                   ],
//                   const Gap(Insets.lg),
//                   if (product.shortDescription.isNotEmpty) ...[
//                     Text(
//                       LocaleKeys.short_description.tr(),
//                       style: context.textTheme.bodyLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Divider(),
//                     Html(
//                       data: product.shortDescription,
//                       style: {
//                         "*": Style(
//                           fontSize: FontSize(16),
//                           lineHeight: const LineHeight(1.3),
//                           fontWeight: FontWeight.w400,
//                           color: context.colorTheme.onSurface,
//                           backgroundColor: context.colorTheme.surface,
//                         ),
//                       },
//                     ),
//                   ],
//                   if (product.metaTitle.isNotEmpty) ...[
//                     const Gap(Insets.lg),
//                     Text(
//                       LocaleKeys.meta_title.tr(),
//                       style: context.textTheme.bodyLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Divider(),
//                     Text(product.metaTitle),
//                   ],
//                   if (product.metaKeywords.isNotEmpty) ...[
//                     const Gap(Insets.lg),
//                     Text(
//                       LocaleKeys.meta_keyword.tr(),
//                       style: context.textTheme.bodyLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Divider(),
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: product.metaKeywords.length,
//                       itemBuilder: (context, index) => Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 2.0),
//                         child: Wrap(
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: Corners.smBorder,
//                                 color: context.colorTheme.onSurface
//                                     .withOpacity(.1),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10.0,
//                                   vertical: 5,
//                                 ),
//                                 child: Text(
//                                   product.metaKeywords[index].titleCaseSingle,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                   ],
//                   if (product.description.isNotEmpty) ...[
//                     const Gap(Insets.lg),
//                     Text(
//                       LocaleKeys.description.tr(),
//                       style: context.textTheme.bodyLarge!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const Divider(),
//                     Html(
//                       data: product.description,
//                       style: {
//                         "*": Style(
//                           fontSize: FontSize(16),
//                           lineHeight: const LineHeight(1.3),
//                           fontWeight: FontWeight.w400,
//                           color: context.colorTheme.onSurface,
//                           backgroundColor: context.colorTheme.surface,
//                         ),
//                       },
//                     ),
//                   ],
//                   const Gap(Insets.lg),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DigitalAttributeList extends HookConsumerWidget {
//   const DigitalAttributeList({
//     super.key,
//     required this.product,
//   });
//
//   final ProductModel product;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final productCtrl = useCallback(
//         () => ref.read(productDetailsCtrlProvider(product.uid).notifier));
//
//     return Column(
//       children: [
//         Row(
//           children: [
//             Text(
//               LocaleKeys.digital_product_attribute_list.tr(),
//               style: context.textTheme.bodyLarge!.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Spacer(),
//             GestureDetector(
//               onTap: () {
//                 showModalBottomSheet(
//                   showDragHandle: true,
//                   context: Get.context!,
//                   isScrollControlled: true,
//                   builder: (BuildContext context) {
//                     return AddDigitalProductAttribute(
//                       product: product,
//                     );
//                   },
//                 );
//               },
//               child: Text(
//                 LocaleKeys.add_attribute.tr(),
//                 style: context.textTheme.bodyLarge!.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: context.colorTheme.primary,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const Gap(Insets.med),
//         ShadowContainer(
//           child: Padding(
//             padding: Insets.padAll,
//             child: Column(
//               children: [
//                 DigitalAttributeTable(
//                   name: LocaleKeys.name.tr(),
//                   price: LocaleKeys.price.tr(),
//                   status: LocaleKeys.status.tr(),
//                   action: [Text(LocaleKeys.action.tr())],
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: product.digitalAttributes.length,
//                   itemBuilder: (context, index) {
//                     final digitalAttribute = product.digitalAttributes[index];
//                     return Column(
//                       children: [
//                         const Divider(),
//                         DigitalAttributeTable(
//                           name: digitalAttribute.name,
//                           price: digitalAttribute.price.formate(),
//                           status: digitalAttribute.status,
//                           action: [
//                             GestureDetector(
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => DeleteAlert(
//                                     title: LocaleKeys
//                                         .really_want_to_delete_this_attribute
//                                         .tr(),
//                                     onDelete: () async {
//                                       await productCtrl().deleteAttribute(
//                                         digitalAttribute.uid,
//                                       );
//                                       if (context.mounted) context.nPop();
//                                     },
//                                   ),
//                                 );
//                               },
//                               child: CircleAvatar(
//                                 radius: 15,
//                                 backgroundColor:
//                                     context.colorTheme.error.withOpacity(.1),
//                                 child: Icon(
//                                   Icons.delete,
//                                   size: 18,
//                                   color: context.colorTheme.error,
//                                 ),
//                               ),
//                             ),
//                             const Gap(Insets.sm),
//                             GestureDetector(
//                               onTap: () {
//                                 showModalBottomSheet(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(0),
//                                   ),
//                                   showDragHandle: false,
//                                   context: Get.context!,
//                                   isScrollControlled: true,
//                                   builder: (BuildContext context) {
//                                     return AddAttributeValueView(
//                                       attribute: digitalAttribute,
//                                       products: product,
//                                     );
//                                   },
//                                 );
//                               },
//                               child: CircleAvatar(
//                                 radius: 15,
//                                 backgroundColor: context
//                                     .colorTheme.errorContainer
//                                     .withOpacity(.1),
//                                 child: Icon(
//                                   Icons.visibility,
//                                   size: 18,
//                                   color: context.colorTheme.errorContainer,
//                                 ),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
