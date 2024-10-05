import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seller_management/features/product/view/common/failure.dart';

final filePickerProvider = Provider<FilePickerRepo>((ref) => FilePickerRepo());

class FilePickerRepo {
  final picker = FilePicker.platform;

  FutureEither<File> pickImage([ImageSource? source]) async {
    return captureImage(source ?? ImageSource.gallery);
  }

  FutureEither<File> pickImageFromGallery() async {
    FilePickerResult? result = await picker.pickFiles(type: FileType.image);

    try {
      if (result == null) {
        return left(const Failure('No img selected'));
      }
      final file = File(result.files.single.path!);
      return right(file);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<File> captureImage(ImageSource source) async {
    final imgPicker = ImagePicker();

    final result = await imgPicker.pickImage(source: source);

    try {
      if (result == null) return left(const Failure('No img selected'));
      final file = File(result.path);

      return right(file);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<File>> pickFiles({List<String>? allowedExtensions}) async {
    try {
      FilePickerResult? result = await picker.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: allowedExtensions,
      );

      if (result == null) {
        return left(const Failure('No file selected'));
      }

      final file = result.files.map((e) => File(e.path!)).toList();
      return right(file);
    } on PlatformException catch (e) {
      return left(Failure(e.message.toString()));
    } on Exception catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

extension ImageSourceEx on ImageSource {
  IconData get icon {
    switch (this) {
      case ImageSource.camera:
        return Icons.camera_alt_outlined;
      case ImageSource.gallery:
        return Icons.image_outlined;
    }
  }
}
