import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

import '../../controller/ticket_file_downloader.dart';

class ChatBubble extends HookConsumerWidget {
  const ChatBubble({
    super.key,
    required this.massage,
    required this.ticketId,
  });

  final TicketMassage massage;
  final String ticketId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileDownload = ref.watch(fileDownloaderProvider);
    final fileDownloadCtrl =
        useCallback(() => ref.read(fileDownloaderProvider.notifier));
    return Column(
      crossAxisAlignment: massage.isAdminReply == false
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: massage.isAdminReply == false
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Container(
                constraints: BoxConstraints(maxWidth: context.width / 1.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: context.colorTheme.onSurface.withOpacity(.05),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Text(
                    massage.message!,
                    style: context.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (massage.files.isNotEmpty)
          SizedBox(
            width: context.width / 2.5,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: massage.files.length,
              itemBuilder: (context, index) {
                final download = fileDownload
                    .where((f) => f.id == massage.files[index].id)
                    .firstOrNull;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorTheme.onSurface.withOpacity(.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => fileDownloadCtrl().addToQueue(
                              massage.files[index],
                              ticketId,
                              massage.id.toString(),
                            ),
                            child: CircleAvatar(
                              backgroundColor: context.colorTheme.primary,
                              child: download == null
                                  ? Icon(
                                      Icons.download_rounded,
                                      color: context.colorTheme.onPrimary,
                                    )
                                  : (download.progress?.isNegative ?? false)
                                      ? Icon(
                                          Icons.file_open_rounded,
                                          color: context.colorTheme.onPrimary,
                                        )
                                      : CircularProgressIndicator(
                                          value: download.progress,
                                          color: context.colorTheme.onPrimary,
                                        ),
                            ),
                          ),
                          const Gap(Insets.med),
                          SizedBox(
                            width: context.width / 5.5,
                            child: Text(
                              'file ${massage.files[index].toString()}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
