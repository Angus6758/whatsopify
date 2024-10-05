import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:seller_management/main.export.dart';

class ChangeAccountInformationView extends HookConsumerWidget {
  const ChangeAccountInformationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hintText = useState('cartuser.seller@example.com');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Email modification',
        ),
      ),
      body: Padding(
        padding: Insets.padH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(Insets.lg),
            Text(
              'Please Verify Your Account',
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(Insets.lg),
            ShadowContainer(
              child: Padding(
                padding: Insets.padAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Login email address',
                      style: context.textTheme.bodyLarge,
                    ),
                    const Gap(Insets.med),
                    FormBuilderTextField(
                      name: 'email',
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: hintText.value,
                      ),
                    ),
                    const Gap(Insets.lg),
                    Text(
                      'Verification Code',
                      style: context.textTheme.bodyLarge,
                    ),
                    const Gap(Insets.med),
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderTextField(
                            name: 'email',
                            decoration: const InputDecoration(
                              hintText: 'Enter Code',
                            ),
                          ),
                        ),
                        const Gap(Insets.med),
                        SizedBox(
                          height: 47,
                          child: FilledButton(
                            onPressed: () {},
                            child: const Text('Send'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(Insets.lg),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('Next'),
              ),
            ),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  hintText.value = '+8801700000000';
                },
                icon: const Icon(Icons.phone),
                label: const Text('Verify Via log-in phone number'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
