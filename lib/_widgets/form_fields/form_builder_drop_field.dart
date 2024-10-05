import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:seller_management/main.export.dart';

class FormBuilderDropField<T> extends StatelessWidget {
  const FormBuilderDropField({
    super.key,
    required this.name,
    required this.itemCount,
    required this.itemBuilder,
    this.initialValue,
    this.hintText,
    this.validators,
    this.onChanged,
    this.onSaved,
    this.bottom,
    this.headerText,
    this.isRequired = false,
  });

  final void Function(T? value)? onChanged;
  final void Function(T? value)? onSaved;
  final Widget? Function()? bottom;
  final String? headerText;
  final String? hintText;
  final T? initialValue;
  final DropdownMenuItem<T> Function(BuildContext context, int index)
      itemBuilder;

  final int? itemCount;
  final String name;
  final List<FormFieldValidator<T>>? validators;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<T>(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: FormBuilderValidators.compose(validators ?? []),
      builder: (state) => DropDownField<T>(
        hintText: hintText,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        onChanged: (value) => state.didChange(value),
        errorText: state.errorText,
        value: state.value,
        bottom: bottom,
        headerText: headerText,
        isRequired: isRequired,
      ),
    );
  }
}

class DropDownField<T> extends StatelessWidget {
  const DropDownField({
    super.key,
    required this.hintText,
    required this.itemCount,
    required this.itemBuilder,
    this.value,
    this.onChanged,
    this.errorText,
    this.headerText,
    this.bottom,
    this.isRequired = false,
  });

  final void Function(T?)? onChanged;
  final Widget? Function()? bottom;
  final String? errorText;
  final String? headerText;
  final String? hintText;
  final DropdownMenuItem<T> Function(BuildContext context, int index)
      itemBuilder;

  final int? itemCount;
  final T? value;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final bottomWidget = bottom?.call();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (headerText != null) ...[
          Text(
            headerText!,
            style: context.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).markAsRequired(isRequired),
          const Gap(Insets.sm),
        ],
        DropdownButtonFormField2<T>(
          isExpanded: true,
          value: value,
          decoration: InputDecoration(
            errorText: errorText,
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onChanged: onChanged,
          items: [
            for (int i = 0; i < (itemCount ?? 0); i++) itemBuilder(context, i),
          ],
        ),
        if (bottomWidget != null) ...[
          // const Gap(Insets.sm),
          bottomWidget,
        ]
      ],
    );
  }
}
