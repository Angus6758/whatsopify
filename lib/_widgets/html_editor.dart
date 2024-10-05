import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:html_editor_enhanced_plus/html_editor.dart';
import 'package:seller_management/main.export.dart';

class HtmlEditorView extends StatefulWidget {
  const HtmlEditorView({
    super.key,
    required this.name,
    this.initialValue,
    this.hint,
    this.onChange,
    this.onSave,
    this.validators = const [],
    this.fieldKey,
  });

  final String name;
  final String? initialValue;
  final String? hint;
  final void Function(String?)? onChange;
  final void Function(String?)? onSave;
  final List<FormFieldValidator> validators;
  final GlobalKey? fieldKey;

  @override
  HtmlEditorViewState createState() => HtmlEditorViewState();
}

class HtmlEditorViewState extends State<HtmlEditorView> {
  final controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      key: widget.fieldKey,
      name: widget.name,
      initialValue: widget.initialValue,
      validator: FormBuilderValidators.compose(widget.validators),
      onSaved: widget.onSave,
      onChanged: widget.onChange,
      builder: (state) {
        // if (state.hasError) controller.setFocus();
        return HtmlEditor(
          controller: controller,
          htmlEditorOptions: HtmlEditorOptions(
            hint: widget.hint,
            shouldEnsureVisible: true,
            initialText: state.value,
          ),
          htmlToolbarOptions: HtmlToolbarOptions(
            toolbarType: ToolbarType.nativeGrid,
            gridViewHorizontalSpacing: 0,
            gridViewVerticalSpacing: 0,
            separatorWidget: Container(
              width: 1,
              height: 20,
              margin: const EdgeInsets.all(5),
            ),
            mediaUploadInterceptor: (file, type) async => true,
            defaultToolbarButtons: [
              const StyleButtons(),
              const FontSettingButtons(fontSizeUnit: false, fontName: false),
              const FontButtons(
                clearAll: false,
                subscript: false,
                superscript: false,
                strikethrough: false,
              ),
              const ColorButtons(),
              const ListButtons(listStyles: false),
              const ParagraphButtons(
                textDirection: false,
                lineHeight: false,
                caseConverter: false,
              ),
              const InsertButtons(
                video: false,
                audio: false,
                table: false,
                hr: false,
                otherFile: false,
              ),
            ],
          ),
          otherOptions: OtherOptions(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.fromBorderSide(
                BorderSide(color: context.colorTheme.outline),
              ),
            ).copyWith(
              border: state.hasError
                  ? Border.fromBorderSide(
                      BorderSide(color: context.colorTheme.error, width: 1.5),
                    )
                  : null,
            ),
          ),
          callbacks: Callbacks(
            onChangeContent: (String? changed) {
              state.didChange(changed);
            },
            onNavigationRequestMobile: (String url) {
              return NavigationActionPolicy.ALLOW;
            },
          ),
        );
      },
    );
  }
}
