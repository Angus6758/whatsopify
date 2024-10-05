import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:seller_management/features/chat/controller/chat_file_downloader.dart';
import 'package:seller_management/main.export.dart';

class CustomerChatBubble extends HookConsumerWidget {
  const CustomerChatBubble({super.key, required this.msg});
  final CustomerMessage msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showTime = useState(false);

    final downloadQueue = ref.watch(chatFileDownloaderProvider);
    final downloader =
        useCallback(() => ref.read(chatFileDownloaderProvider.notifier));
    return Column(
      crossAxisAlignment:
          msg.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => showTime.value = !showTime.value,
          child: Container(
            decoration: BoxDecoration(
              color: context.colorTheme.primary.withOpacity(0.07),
              borderRadius: BorderRadius.circular(10).copyWith(
                bottomRight: msg.isMine ? const Radius.circular(1) : null,
                bottomLeft: msg.isMine ? null : const Radius.circular(1),
              ),
            ),
            constraints: BoxConstraints(
              maxWidth: context.width * 0.7,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              msg.message,
              style: context.textTheme.bodyLarge!.copyWith(
                color: context.colorTheme.onBackground,
              ),
            ),
          ),
        ),
        const Gap(Insets.sm),
        if (msg.files.isNotEmpty)
          SizedBox(
            width: context.width * 0.7,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: msg.files.length,
              itemBuilder: (context, index) {
                final download = downloadQueue
                    .where((f) => f.url == msg.files[index].url)
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
                            onTap: () {
                              downloader().addToQueue(msg.files[index]);
                            },
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
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'File ${index + 1}',
                                    style:
                                        context.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '\n${msg.files[index].name.split('.').last}',
                                  ),
                                ],
                              ),
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
        const Gap(Insets.sm),
        Row(
          mainAxisAlignment:
              msg.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (showTime.value) ...[
              Text(
                msg.readableTime,
                style: TextStyle(
                  color: context.colorTheme.onSurface.withOpacity(
                    .7,
                  ),
                ),
              ).animate().fadeIn(),
              const Gap(Insets.med),
            ],
            if (msg.isMine && msg.isSeen)
              Icon(
                Icons.done_all_outlined,
                size: 18,
                color: context.colorTheme.primary.withOpacity(0.7),
              ),
          ],
        ),
        const Gap(Insets.med),
      ],
    );
  }
}
