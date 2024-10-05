import 'dart:io' as io;
import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';

import '../controller/ticket_massage_ctrl.dart';
import 'local/local.dart';

class TicketView extends HookConsumerWidget {
  const TicketView(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final massageCtrl = useTextEditingController();
    final massage = ref.watch(ticketMassageCtrlProvider(id));
    final files = useState<List<io.File>>([]);
    final ticketCtrl =
        useCallback(() => ref.read(ticketMassageCtrlProvider(id).notifier));

    return Scaffold(
      appBar: AppBar(
        title: massage.maybeWhen(
          orElse: () => const SizedBox(),
          data: (data) => Text(
            data.ticket.subject,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(ticketMassageCtrlProvider(id).notifier).reload(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: massage.when(
        error: (error, stackTrace) => ErrorView(error, stackTrace),
        loading: () => Loader.list(),
        data: (ticket) {
          final messages = ticket.massages.reversed.toList();
          return Column(
            children: [
              Expanded(
                flex: 9,
                child: RefreshIndicator(
                  onRefresh: () => ref
                      .watch(ticketMassageCtrlProvider(id).notifier)
                      .reload(),
                  child: GroupedListView<TicketMassage, DateTime>(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    elements: messages,
                    groupBy: (element) => DateTime(
                      element.createdAt.year,
                      element.createdAt.month,
                      element.createdAt.day,
                      element.createdAt.hour,
                    ),
                    itemBuilder: (context, element) => Padding(
                      padding: Insets.padH,
                      child: ChatBubble(
                        massage: element,
                        ticketId: id,
                      ),
                    ),
                    order: GroupedListOrder.DESC,
                    groupSeparatorBuilder: (value) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          value.formatDate('dd:MM:yyyy'),
                          style: context.textTheme.labelMedium!.copyWith(
                            color: context.colorTheme.onSurface.withOpacity(.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (ticket.ticket.status == TicketStatus.closed)
                DecoratedContainer(
                  width: context.width,
                  padding: const EdgeInsets.all(10),
                  color: context.colorTheme.error,
                  child: Center(
                    child: Text(
                      LocaleKeys.this_ticket_is_closed.tr(),
                      style: TextStyle(color: context.colorTheme.onError),
                    ),
                  ),
                )
              else
                Padding(
                  padding: Insets.padH.copyWith(bottom: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          if (files.value.isEmpty) {
                            files.value = await ticketCtrl().pickFiles();
                          } else {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              isScrollControlled: true,
                              builder: (_) => SelectedFilesSheet(
                                files: files,
                              ),
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              context.colorTheme.onSurface.withOpacity(.05),
                          child: files.value.isEmpty
                              ? const RotationTransition(
                                  turns: AlwaysStoppedAnimation(30 / 360),
                                  child: Icon(Icons.attach_file),
                                )
                              : CircleAvatar(
                                  backgroundColor: context.colorTheme.primary,
                                  foregroundColor:
                                      context.colorTheme.onSecondaryContainer,
                                  radius: 12,
                                  child: Text(
                                    files.value.length.toString(),
                                  ),
                                ),
                        ),
                      ),
                      const Gap(Insets.med),
                      Expanded(
                        child: TextFormField(
                          controller: massageCtrl,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.write_massage.tr(),
                          ),
                        ),
                      ),
                      const Gap(Insets.med),
                      IconButton.filled(
                        onPressed: () {
                          ref
                              .read(ticketMassageCtrlProvider(id).notifier)
                              .ticketReply(
                                massageCtrl.text,
                                files.value,
                              );
                          massageCtrl.clear();

                          files.value = [];
                        },
                        icon: Transform.rotate(
                          angle: -math.pi / 5,
                          child: const Icon(
                            Icons.send_rounded,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
