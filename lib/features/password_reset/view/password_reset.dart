import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/routes.dart';

import '../../auth/controller/password_reset_ctrl.dart';

class PasswordResetView extends HookConsumerWidget {
  const PasswordResetView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldKey = useMemoized(() => GlobalKey<FormBuilderTextState>());
    final resetCtrl =
        useCallback(() => ref.read(passwordResetCtrlProvider.notifier));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              height: 80,
            ),
            const Gap(Insets.med),
            Text(
              LocaleKeys.reset_password.tr(),
              style: context.textTheme.headlineMedium,
            ),
            const Gap(Insets.sm),
            Text(
              LocaleKeys.regain_access.tr(),
              style: context.textTheme.bodyLarge,
            ),
            const Gap(Insets.offset),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.email.tr(),
                  style: context.textTheme.bodyLarge,
                ),
                const Gap(Insets.med),
                FormBuilderTextField(
                  key: fieldKey,
                  name: 'email',
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.enter_gmail_account.tr(),
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
              ],
            ),
            const Gap(Insets.xl),
            SizedBox(
              height: 50,
              width: context.width / 1.6,
              child: SubmitButton(
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                ),
                onPressed: (l) async {
                  final state = fieldKey.currentState!;
                  final value = state.value;

                  if (!state.validate() || value == null) return;

                  l.value = true;
                  resetCtrl().setEmail(value);
                  final result = await resetCtrl().verifyEmail();

                  l.value = false;
                  if (context.mounted) {
                    if (result) {
                      RouteNames.otpScreen.pushNamed(context);
                    } else {
                      RouteNames.passwordReset.goNamed(context);
                      state.reset();
                    }
                  }
                },
                child: Text(
                  LocaleKeys.verify_mail.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
