import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef FromJsonT<T> = T Function(QMap obj);
typedef QMap = Map<String, dynamic>;
typedef FormBuilderTextState
    = FormBuilderFieldState<FormBuilderField<String>, String>;
