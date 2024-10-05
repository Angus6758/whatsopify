import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/main.export.dart';

class PasswordChangeView extends HookConsumerWidget {
  const PasswordChangeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final hideOld = useState(true);
    final hideNow = useState(true);
    final hideConfirm = useState(true);
    final newPass = useState('');

    return Scaffold(
      appBar: KAppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: formKey,
          child: ShadowContainer(
            padding: Insets.padAll,
            margin: Insets.padAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Password', style: context.textTheme.labelLarge),
                FormBuilderTextField(
                  name: 'current_password',
                  textInputAction: TextInputAction.next,
                  obscureText: hideOld.value,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => hideOld.value = !hideOld.value,
                      icon: hideOld.value
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('New Password', style: context.textTheme.labelLarge),
                FormBuilderTextField(
                  name: 'password',
                  obscureText: hideNow.value,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => newPass.value = value ?? '',
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => hideNow.value = !hideNow.value,
                      icon: hideNow.value
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Confirm Password', style: context.textTheme.labelLarge),
                FormBuilderTextField(
                  name: 'password_confirmation',
                  obscureText: hideConfirm.value,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () => hideConfirm.value = !hideConfirm.value,
                      icon: hideConfirm.value
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                      FormBuilderValidators.equal(
                        newPass.value,
                        errorText: 'Passwords do not match',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SubmitButton(
                  width: context.width,
                  onPressed: (l) async {
                    final state = formKey.currentState!;
                    if (!state.saveAndValidate()) return;

                    l.value = true;
                    await ref
                        .read(authCtrlProvider.notifier)
                        .updatePassword(state.value);
                    l.value = false;
                    state.reset();
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
