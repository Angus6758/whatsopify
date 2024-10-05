import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';

class ChooseButton extends StatelessWidget {
  const ChooseButton({
    super.key,
    this.multiPick = false,
    required this.name,
    required this.onTap,
    this.validators,
    this.imageDimension,
  });

  final bool multiPick;
  final String name;
  final String? imageDimension;
  final Function(List<File> files) onTap;
  final List<FormFieldValidator>? validators;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<File>>(
      name: name,
      validator: FormBuilderValidators.compose([...?validators]),
      builder: (state) {
        return InputDecorator(
          decoration: InputDecoration(
            contentPadding: state.hasError ? null : EdgeInsets.zero,
            filled: false,
            enabled: true,
            errorText: state.errorText,
            helperText: imageDimension == null
                ? null
                : '${LocaleKeys.image_size_should_be.tr()} $imageDimension',
            helperStyle: context.textTheme.labelMedium
                ?.copyWith(color: Colors.orange.shade800),
          ),
          child: InkWell(
            onTap: () async {
              final picker = locate<FilePickerRepo>();

              if (multiPick) {
                final img = await picker.pickFiles(type: FileType.image);
                img.fold((l) => l.log(), (r) => onTap(r));
                return;
              }
              final img = await picker.pickImage();
              img.fold((l) => l.log(), (r) => onTap([r]));
            },
            child: ShadowContainer(
              child: Column(
                children: [
                  const Gap(Insets.med),
                  SvgPicture.asset(
                    AssetsConst.addImage,
                    height: 50,
                  ),
                  const Gap(Insets.med),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsConst.upload,
                        height: 20,
                      ),
                      const Gap(Insets.sm),
                      Text(
                        LocaleKeys.upload_your_file.tr(),
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const Gap(Insets.med),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
