import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

// final filePickerProvider = Provider<FilePickerRepo>((ref) => FilePickerRepo());

@Singleton(order: 3)
class FilePickerRepo {
  final _picker = FilePicker.platform;

  FutureReport<File> pickImage([ImageSource? source]) async {
    return captureImage(source ?? ImageSource.gallery);
  }

  FutureReport<File> pickImageFromGallery() async {
    FilePickerResult? result = await _picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'jfif', 'webp', 'heif'],
    );

    try {
      if (result == null) {
        return left(const Failure('No img selected'));
      }
      final file = File(result.files.single.path!);

      Logger(file.path);
      return right(file);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureReport<File> captureImage(ImageSource source) async {
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

  FutureReport<List<File>> pickFiles({
    List<String>? allowedExtensions,
    FileType type = FileType.any,
  }) async {
    try {
      FilePickerResult? result = await _picker.pickFiles(
        type: allowedExtensions == null ? type : FileType.custom,
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
