
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/check_out/providers/provider.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/gen/assets.gen.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/payment/controller/payment_ctrl.dart';
import 'package:seller_management/features/product/view/spaced_text.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

class OrderPlacedPage extends ConsumerWidget {
  const OrderPlacedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(checkoutStateProvider);

    final from = context.query('from');

    final isFromPayNow = from == 'payNow';

    return Scaffold(
      appBar: KAppBar(title: Text(TR.completePayment(context))),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPadding,
        child: Column(
          children: [
            Assets.lottie.readyForPayment.lottie(
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    ['**', 'Group 2', '**'],
                    value: context.colors.errorContainer,
                  ),
                  ValueDelegate.color(
                    ['**', 'plane Outlines', '**'],
                    value: context.colors.errorContainer,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (order == null)
              Text(
                TR.somethingWentWrong(context),
                style: context.textTheme.titleLarge,
              )
            else ...[
              Text(
                isFromPayNow
                    ? TR.readyForPayment(context)
                    : TR.orderSuccessful(context),
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                isFromPayNow
                    ? TR.yourOrderReadyPayment(context)
                    : TR.yourOderPWSuccessful(context),
                textAlign: TextAlign.center,
                style: context.textTheme.titleMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${TR.orderId(context)}: ',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    order.order.orderId,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Clipboard.setData(
                        ClipboardData(text: order.order.orderId)),
                    icon: const Icon(Icons.copy, size: 16),
                  ),
                ],
              ),
              if (!ref.watch(authCtrlProvider))
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: context.width,
                  decoration: BoxDecoration(
                    borderRadius: defaultRadius,
                    border: Border.all(color: context.colors.error),
                    color: context.colors.error.withOpacity(.1),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: context.colors.error,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          TR.notLoggedInOrderWarn(context),
                          style: context.textTheme.titleMedium?.copyWith(
                            color: context.colors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              if (!order.paymentLog.method.isCOD) ...[
                SpacedText(
                  leftText: TR.total(context),
                  rightText: order.paymentLog.amount.formate(),
                  style: context.textTheme.titleMedium,
                ),
                SpacedText(
                  leftText: TR.charge(context),
                  rightText: order.paymentLog.charge.formate(),
                  style: context.textTheme.titleMedium,
                ),
                SpacedText(
                  leftText: TR.payable(context),
                  rightText: order.paymentLog.payable.formate(),
                  style: context.textTheme.titleMedium,
                ),
                const Divider(),
                SpacedText(
                  leftText: 'In ${order.paymentLog.method.currency.name}',
                  rightText: order.paymentLog.finalAmount
                      .currency(order.paymentLog.method.currency),
                  style: context.textTheme.titleLarge,
                ),
              ],
              if (!order.paymentLog.method.isCOD) ...[
                const SizedBox(height: 50),
                FilledButton(
                  style: FilledButton.styleFrom(
                    fixedSize: Size(context.width, 50),
                  ),
                  onPressed: () {
                    final ctrl = ref.read(paymentCtrlProvider.notifier);
                    final method = order.paymentLog.method;
                    ctrl.initializePaymentWithMethod(context, method: method);
                  },
                  child: Text(
                    '${TR.payNow(context)} - ${order.paymentLog.method.name}',
                  ),
                ),
              ],
            ],
            const SizedBox(height: 20),
            FilledButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 50),
                backgroundColor: context.colors.secondary.withOpacity(.05),
                foregroundColor: context.colors.secondary,
                side:
                    BorderSide(color: context.colors.secondary.withOpacity(.4)),
              ),
              onPressed: () {
                RouteNames.trackOrder.goNamed(
                  context,
                  query: {'id': order?.order.orderId ?? ''},
                );
              },
              child: Text(TR.trackNow(context)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 50),
                backgroundColor: context.colors.secondary.withOpacity(.05),
                foregroundColor: context.colors.secondary,
                side:
                    BorderSide(color: context.colors.secondary.withOpacity(.4)),
              ),
              onPressed: () => RouteNames.home.goNamed(context),
              child: Text(TR.backToHome(context)),
            ),
            const SizedBox(height: 150)
          ],
        ),
      ),
    );
  }
}
