import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:seller_management/main.export.dart';

class SelectedFilesSheet extends ConsumerWidget {
  const SelectedFilesSheet({
    super.key,
    required this.files,
  });

  final ValueNotifier<List<io.File>> files;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: context.height * 0.7,
      child: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return ValueListenableBuilder<List<io.File>>(
            valueListenable: files,
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: value.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'File',
                              style: context.textTheme.titleLarge,
                            ),
                            IconButton.filled(
                              onPressed: () async {
                                final newFiles =
                                    await locate<FilePickerRepo>().pickFiles();

                                newFiles.fold(
                                  (l) => Toaster.showError(l),
                                  (r) => files.value = [...value, ...r],
                                );
                              },
                              icon: const Icon(Icons.add_rounded),
                            ),
                          ],
                        ),
                      );
                    }
                    final file = value[index - 1];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Corners.med),
                        side: BorderSide(
                          color: context.colorTheme.primary,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        iconColor: context.colorTheme.primary,
                        leading: const Icon(Icons.file_present_rounded),
                        title: Text(file.path.split('/').last),
                        trailing: IconButton(
                          onPressed: () {
                            files.value = [
                              ...value.sublist(0, index - 1),
                              ...value.sublist(index),
                            ];
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: context.colorTheme.error,
                          ),
                        ),
                        onTap: () {
                          OpenFilex.open(file.path);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
