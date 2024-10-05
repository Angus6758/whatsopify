
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_widgets/app_image.dart';
import 'package:seller_management/features/product/view/buttons/submit_button.dart';
import 'package:seller_management/features/product/view/check_out/view/checkout_payment_view.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/payment/controller/payment_ctrl.dart';
import 'package:seller_management/features/product/view/settings/controller/settings_ctrl.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/spaced_text.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/user_content/order_model.dart';

class PayNowBottomSheetView extends HookConsumerWidget {
  const PayNowBottomSheetView(this.order, {super.key});

  final OrderModel order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configData = ref.watch(settingsCtrlProvider);

    final paymentCtrl =
        useCallback(() => ref.read(paymentCtrlProvider.notifier));
    final selectedPayment = useState<PaymentData?>(null);
    final ctrl = useAnimationController();

    return SizedBox(
      height: context.height * .8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(TR.payNow(context)),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ),
        body: BottomSheet(
          animationController: ctrl,
          onClosing: () {},
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: configData.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: ErrorView1.errorMethod,
                data: (config) {
                  return SingleChildScrollView(
                    physics: defaultScrollPhysics,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TR.paymentMethod(context),
                          style: context.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: config.paymentMethods.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SelectableCheckCard(
                                header: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: HostedImage(
                                    config.paymentMethods[index].image,
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                                title: Text(
                                  config.paymentMethods[index].name,
                                  textAlign: TextAlign.center,
                                ),
                                isSelected: selectedPayment.value?.uniqueCode ==
                                    config.paymentMethods[index].uniqueCode,
                                onTap: () => selectedPayment.value =
                                    config.paymentMethods[index],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              SpacedText(
                rightText: order.amount.formate(),
                leftText: '${TR.total(context)} :',
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 5),
              SubmitButton(
                width: context.width,
                onPressed: () async {
                  if (selectedPayment.value == null) {
                    return Toaster.showError(
                      TR.selectPaymentMethod(context),
                    );
                  }
                  await paymentCtrl()
                      .payNow(context, order.uid, selectedPayment.value!);

                  if (context.mounted) context.pop();
                },
                child: Text(TR.payNow(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
