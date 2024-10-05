
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/buttons/submit_button.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/gen/assets.gen.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/user_dash/controller/dash_ctrl.dart';
import 'package:seller_management/routes/go_route_name.dart';

class AfterPaymentView extends HookConsumerWidget {
  const AfterPaymentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trxNo = context.query('id');
    final statusQu = context.query('status');
    final data = context.query('data');

    final status = useState(statusQu);
    final isLoading = useState(false);

    useEffect(
      () {
        Future(() {
          if (ref.read(authCtrlProvider)) {
            ref.read(userDashCtrlProvider.notifier).reload();
          }
        });
        return null;
      },
      [statusQu],
    );

    checkOrderStatus() async {
      if (trxNo == null) return;
      isLoading.value = true;

      // final payStatus =
      //     await ref.read(orderPaymentLogProvider.notifier).statusCheck(trxNo);

      isLoading.value = false;
      status.value = "paystatus";
          //payStatus;
      HapticFeedback.lightImpact();
    }

    useOnAppLifecycleStateChange(
      (_, c) {
        if (c == AppLifecycleState.resumed) checkOrderStatus();
      },
    );

    final color = switch (status.value) {
      's' || '2' => context.colors.errorContainer,
      'w' || '1' => Colors.orange,
      _ => context.colors.error,
    };
    final icon = switch (status.value) {
      's' || '2' => Icons.done,
      'w' || '1' => Icons.hourglass_bottom_rounded,
      _ => Icons.close,
    };
    final title = switch (status.value) {
      's' || '2' => TR.paymentSuccess(context),
      'w' || '1' => 'Payment Processing',
      _ => TR.paymentFailed(context),
    };
    final text = switch (status.value) {
      's' || '2' => TR.paymentSuccessMassage(context),
      'w' || '1' => 'Please wait while we process your payment',
      _ => TR.paymentFailedMassage(context),
    };

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          checkOrderStatus();
        },
        child: Stack(
          children: [
            if (isLoading.value) const LinearProgressIndicator(),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: defaultPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.illustration.payment.path,
                    height: 300,
                    width: double.infinity,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        icon,
                        size: 20,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  Text(
                    title,
                    style: context.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  if (data != null)
                    Text(
                      data,
                      style: context.textTheme.bodyLarge,
                    ),
                  if (ref.watch(authCtrlProvider))
                    GestureDetector(
                      onTap: () => RouteNames.orders.pushNamed(context),
                      child: Text(
                        TR.orderHistory(context),
                        style: context.textTheme.bodyLarge!.copyWith(
                          decorationColor: context.colors.primary,
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  SubmitButton(
                    onPressed: () => RouteNames.home.goNamed(context),
                    child: Text(TR.continueShopping(context)),
                  ),
                  const SizedBox(height: 100),
                  Text(
                    TR.haveQuestion(context),
                    style: context.textTheme.bodyLarge,
                  ),
                  GestureDetector(
                    onTap: () => RouteNames.supportTicket.pushNamed(context),
                    child: Text(
                      TR.customerSupport(context),
                      style: context.textTheme.bodyLarge?.copyWith(
                        decorationColor: context.colors.primary,
                        fontWeight: FontWeight.bold,
                        color: context.colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
