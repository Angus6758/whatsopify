import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seller_management/features/support_ticket/view/local/local.dart';
import 'package:seller_management/main.export.dart';

import '../controller/chat_ctrl.dart';
import 'local/customer_chat_bubble.dart';

class CustomerChatView extends HookConsumerWidget {
  const CustomerChatView({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageData = ref.watch(chatMessageCtrlProvider(id));
    final chatCtrl =
        useCallback(() => ref.read(chatMessageCtrlProvider(id).notifier));

    final msgCtrl = useTextEditingController();

    final files = useState<List<File>>([]);

    final refreshCtrl = RefreshController();

    return messageData.when(
      error: (e, s) => Scaffold(body: ErrorView(e, s)),
      loading: () => Scaffold(body: Loader.list()),
      data: (messagesData) => Scaffold(
        appBar: AppBar(
          title: Text(messagesData.customer?.name ?? ''),
        ),
        body: Padding(
          padding: Insets.padH,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: SmartRefresher(
                  controller: refreshCtrl,
                  enablePullUp: true,
                  reverse: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  onRefresh: () async {
                    await chatCtrl().reload();
                    refreshCtrl.refreshCompleted();
                  },
                  onLoading: () async {
                    final load = await chatCtrl().loadMore();
                    if (load case LoadStatus.failed) {
                      refreshCtrl.loadFailed();
                    }
                    if (load case LoadStatus.noMore) {
                      refreshCtrl.loadNoData();
                    }

                    await Future.delayed(1.seconds);
                    refreshCtrl.loadComplete();
                  },
                  child: CustomScrollView(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverGroupedListView<CustomerMessage, DateTime>(
                        elements: messagesData.messages.listData,
                        groupBy: (e) => DateTime(
                          e.dateTime.year,
                          e.dateTime.month,
                          e.dateTime.day,
                          e.dateTime.hour,
                        ),
                        itemBuilder: (context, element) => Padding(
                          padding: Insets.padH,
                          child: CustomerChatBubble(msg: element),
                        ),
                        order: GroupedListOrder.DESC,
                        groupComparator: (v1, v2) => v1.compareTo(v2),
                        itemComparator: (e1, e2) =>
                            e1.dateTime.compareTo(e2.dateTime),
                        groupSeparatorBuilder: (value) => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              value.formatDate('dd:MM:yyyy'),
                              style: context.textTheme.labelMedium!.copyWith(
                                color: context.colorTheme.onSurface
                                    .withOpacity(.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: Insets.padH.copyWith(bottom: 10),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (files.value.isEmpty) {
                          files.value = await chatCtrl().pickFiles();
                        } else {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            isScrollControlled: true,
                            builder: (_) => SelectedFilesSheet(files: files),
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: files.value.isEmpty
                            ? context.colorTheme.outline.withOpacity(.6)
                            : context.colorTheme.primary,
                        foregroundColor: files.value.isEmpty
                            ? context.colorTheme.onSurface
                            : context.colorTheme.onPrimary,
                        child: files.value.isEmpty
                            ? const RotationTransition(
                                turns: AlwaysStoppedAnimation(30 / 360),
                                child: Icon(Icons.attach_file),
                              )
                            : Text('${files.value.length}'),
                      ),
                    ),
                    const Gap(Insets.med),
                    Expanded(
                      child: TextFormField(
                        controller: msgCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Write something...',
                        ),
                      ),
                    ),
                    const Gap(Insets.med),
                    IconButton.filled(
                      onPressed: () {
                        chatCtrl().reply(msgCtrl.text, files.value);
                        msgCtrl.clear();
                        files.value = [];
                      },
                      icon: const RotationTransition(
                        turns: AlwaysStoppedAnimation(-30 / 360),
                        child: Icon(Icons.send_rounded),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
