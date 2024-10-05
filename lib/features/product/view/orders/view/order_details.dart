
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_styled_widgets/decorated_container.dart';
import 'package:seller_management/_widgets/app_image.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/gen/assets.gen.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/orders/controller/order_tracking_ctrl.dart';
import 'package:seller_management/features/product/view/orders/view/local/order_loader.dart';
import 'package:seller_management/features/product/view/orders/view/pay_now_bottom_sheet_view.dart';
import 'package:seller_management/features/product/view/spaced_text.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

class OrderDetailsView extends ConsumerWidget {
  const OrderDetailsView({super.key, this.orderId});

  final String? orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderData = ref.watch(orderDetailsProvider(orderId));

    final borderColor =
        context.colors.secondary.withOpacity(context.isDark ? 0.8 : 0.2);
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
    final fromTracking = context.query('from') == 'tracking';

    return Scaffold(
      appBar: KAppBar(
        title: Text(TR.orderDetails(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: orderData.when(
        error: (e, s) => ErrorView1.reload(
          e,
          s,
          () => ref.refresh(orderDetailsProvider(orderId)),
        ),
        loading: () => const OrderLoader(),
        data: (order) {
          final billing = order.billingAddress;

          return Padding(
            padding: defaultPadding.copyWith(top: 20),
            child: RefreshIndicator(
              onRefresh: () async {
                return ref.refresh(orderDetailsProvider(orderId));
              },
              child: SingleChildScrollView(
                physics: defaultScrollPhysics,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //!Ship & Bill Section---------------------------------------------
                    if (billing != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: padding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TR.shipNBill(context),
                              style: context.textTheme.bodyLarge!.copyWith(
                                color:
                                    context.colors.onSurface.withOpacity(0.8),
                              ),
                            ),
                            if (!billing.isNamesEmpty)
                              Text(
                                billing.fullName,
                                style: context.textTheme.titleMedium,
                              ),
                            if (billing.phone != null)
                              Text(
                                '${TR.phone(context)} : ${billing.phone}',
                                style: context.textTheme.titleMedium,
                              ),
                            if (billing.email.isNotEmpty)
                              Text(
                                '${TR.email(context)} : ${billing.email}',
                                style: context.textTheme.titleMedium,
                              ),
                            if (billing.city.isNotEmpty)
                              Text(
                                'City: ${billing.city}',
                                style: context.textTheme.bodyLarge,
                              ),
                            if (billing.state.isNotEmpty)
                              Text(
                                'State: ${billing.state}',
                                style: context.textTheme.bodyLarge,
                              ),
                            if (billing.country.isNotEmpty)
                              Text(
                                'Country: ${billing.country}',
                                style: context.textTheme.bodyLarge,
                              ),
                            if (billing.address.isNotEmpty)
                              Text(
                                '${TR.street(context)} : ${billing.address}',
                                style: context.textTheme.titleMedium,
                              ),
                          ],
                        ),
                      ),

                    //! Custom info Section ---------------------------------------------
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: defaultRadius,
                        border: Border.all(color: borderColor),
                      ),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Custom Information',
                            style: context.textTheme.bodyLarge!.copyWith(
                              color: context.colors.onSurface.withOpacity(0.8),
                            ),
                          ),
                          ...order.customInfo.entries.map((e) {
                            var MapEntry(:key, :value) = e;
                            if (value is List) value = value.join(', ');
                            if (value == null) return const SizedBox.shrink();
                            return Text('$key : $value');
                          }),
                        ],
                      ),
                    ),

                    if (order.paymentDetails.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: defaultRadius,
                          border: Border.all(color: borderColor),
                        ),
                        width: double.infinity,
                        padding: padding,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment information',
                              style: context.textTheme.bodyLarge!.copyWith(
                                color:
                                    context.colors.onSurface.withOpacity(0.8),
                              ),
                            ),
                            for (var MapEntry(:key, :value)
                                in order.paymentDetails.entries)
                              Text(
                                '$key : $value',
                                style: context.textTheme.titleMedium,
                              ),
                          ],
                        ),
                      ),

                    //! Product Package Section ---------------------------------------------

                    ...List.generate(
                      order.orderDetails.length,
                      (i) {
                        var orderDetail = order.orderDetails[i];
                        final price = orderDetail.isRegular
                            ? orderDetail.product!.price
                            : orderDetail.digitalProduct!.price;

                        final shop = orderDetail.product?.store ??
                            orderDetail.digitalProduct?.store;

                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            border: Border.all(color: borderColor),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: padding,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_shipping_outlined),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${TR.package(context)} [${i + 1}]',
                                  ),
                                  const Spacer(),
                                  Text(
                                    order.status.name,
                                    style:
                                        context.textTheme.titleLarge!.copyWith(
                                      color: context.colors.errorContainer,
                                    ),
                                  ),
                                ],
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: HostedImage(
                                    orderDetail.isRegular
                                        ? orderDetail.product!.featuredImage
                                        : orderDetail
                                            .digitalProduct!.featuredImage,
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                isThreeLine: true,
                                trailing: shop == null
                                    ? null
                                    : InkWell(
                                        onTap: () {
                                          RouteNames.sellerChatDetails
                                              .pushNamed(
                                            context,
                                            pathParams: {
                                              'id': '${shop.storeId}',
                                            },
                                          );
                                        },
                                        child:
                                            Assets.logo.chat.image(height: 30),
                                      ),
                                title: Text(
                                  orderDetail.isRegular
                                      ? orderDetail.product!.name
                                      : order
                                          .orderDetails[i].digitalProduct!.name,
                                  style: context.textTheme.titleMedium,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: price.formate(),
                                          ),
                                          TextSpan(
                                            text: ' x ${orderDetail.quantity}',
                                          ),
                                          TextSpan(
                                            text: ' (${orderDetail.attribute})',
                                          ),
                                        ],
                                        style: context.textTheme.bodyLarge!
                                            .copyWith(
                                          color: context.colors.outlineVariant,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Original: ${orderDetail.originalTotalPrice.formate()}',
                                          style: context.textTheme.bodyLarge!,
                                        ),
                                        DecoratedContainer(
                                          height: 10,
                                          width: 1,
                                          color: context.colors.primary,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                        ),
                                        Text(
                                          'Tax: ${orderDetail.totalTax.formate()}',
                                          style: context.textTheme.bodyLarge!,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Total: ${orderDetail.totalPrice.formate()}',
                                      style:
                                          context.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (order.status.name == 'delivered')
                                if (orderDetail.isRegular) ...[
                                  const SizedBox(height: 20),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: FilledButton(
                                      onPressed: () {
                                        RouteNames.productDetails.pushNamed(
                                          context,
                                          pathParams: {
                                            'id': order
                                                .orderDetails[i].product!.uid,
                                          },
                                          query: {
                                            'isRegular': orderDetail.isRegular
                                                ? 'true'
                                                : 'false',
                                            'toReview': 'true',
                                          },
                                        );
                                      },
                                      child: Text(TR.writeReview(context)),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                            ],
                          ),
                        );
                      },
                    ),

                    const Gap(Insets.med),

                    const Gap(Insets.med),
                    if (!fromTracking)
                      Align(
                        alignment: Alignment.centerRight,
                        child: FilledButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              context.colors.primary.withOpacity(.05),
                            ),
                          ),
                          onPressed: () {
                            RouteNames.trackOrder.pushNamed(
                              context,
                              query: {'id': order.orderId},
                            );
                          },
                          child: Text(
                            TR.trackOrder(context),
                            style: TextStyle(color: context.colors.primary),
                          ),
                        ),
                      ),
                    const Gap(Insets.med),
                    //! Order id----------------------------------------------
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: defaultRadius,
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${TR.orderId(context)}: ${order.orderId}',
                                style: context.textTheme.titleLarge!
                                    .copyWith(color: context.colors.primary),
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: order.orderId),
                                  );
                                },
                                icon: const Icon(Icons.copy),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${TR.orderPlacement(context)}: ',
                                style: context.textTheme.titleMedium!.copyWith(
                                  color:
                                      context.colors.onSurface.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                order.orderDate
                                    .formatDate(context, 'dd MMM yyyy'),
                                style: context.textTheme.titleMedium!.copyWith(
                                  color:
                                      context.colors.onSurface.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: defaultRadius,
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      padding: padding,
                      child: Column(
                        children: [
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: '${TR.paymentMethod(context)}:',
                            rightText: order.paymentType ?? 'N/A',
                          ),
                          const SizedBox(height: 10),
                          SpacedText.diffStyle(
                            styleLeft: context.textTheme.titleMedium,
                            styleRight: context.textTheme.titleMedium?.copyWith(
                              color: order.paymentStatus == 'Paid'
                                  ? context.colors.errorContainer
                                  : null,
                            ),
                            leftText: '${TR.paymentStatus(context)}:',
                            rightText: order.paymentStatus,
                          ),
                          const Divider(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: 'Original Amount:',
                            rightText: order.originalAmount.formate(),
                          ),
                          const SizedBox(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: 'Tax amount:',
                            rightText: order.totalTax.formate(),
                          ),
                          const SizedBox(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: 'Shipping Cost:',
                            rightText: order.shippingCharge.formate(),
                          ),
                          const SizedBox(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: '${TR.discount(context)}:',
                            rightText: order.discount.formate(),
                          ),
                          const SizedBox(height: 10),
                          SpacedText(
                            style: context.textTheme.titleMedium,
                            leftText: '${TR.total(context)}:',
                            rightText: order.amount.formate(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (!order.isPaid && !order.isCOD)
                      Center(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              shape: const StadiumBorder()),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              scrollControlDisabledMaxHeightRatio: 0.9,
                              builder: (ctx) => PayNowBottomSheetView(order),
                            );
                          },
                          child: Text(TR.payNow(context)),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
