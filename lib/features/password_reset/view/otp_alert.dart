import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../auth/controller/password_reset_ctrl.dart';

class OTPScreenView extends HookConsumerWidget {
  const OTPScreenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldKey = useMemoized(() => GlobalKey<FormBuilderTextState>());

    final resetCtrl =
        useCallback(() => ref.read(passwordResetCtrlProvider.notifier));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const Gap(Insets.offset),
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: context.colorTheme.primary,
                  ),
                ),
              ],
            ),
            const Gap(Insets.offset),
            SvgPicture.asset(
              AssetsConst.passwordReset,
              height: 70,
            ),
            const Gap(Insets.med),
            Text(
              LocaleKeys.enter_otp.tr(),
              style: context.textTheme.titleLarge,
            ),
            const Gap(Insets.lg),
            FormBuilderTextField(
              key: fieldKey,
              name: 'code',
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: LocaleKeys.enter_otp.tr(),
              ),
              validator: FormBuilderValidators.required(),
            ),
            const Gap(Insets.xl),
            SubmitButton(
              onPressed: (l) async {
                final state = fieldKey.currentState!;
                final value = state.value;

                if (!state.validate() || value == null) return;
                l.value = true;

                resetCtrl().setOtp(value);

                final result = await resetCtrl().verifyOtp();

                l.value = false;
                if (context.mounted) {
                  if (result) {
                    RouteNames.newPassword.pushNamed(context);
                  } else {
                    RouteNames.otpScreen.goNamed(context);
                    state.reset();
                  }
                }
              },
              child: Text(LocaleKeys.verify.tr()),
            ),
            // const OtpInput()
          ],
        ),
      ),
    );
  }
}
