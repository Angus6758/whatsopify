import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

import '../controller/chat_ctrl.dart';
import 'customer_chat_card.dart';

class CustomerChatListView extends HookConsumerWidget {
  const CustomerChatListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatData = ref.watch(chatCtrlProvider);

    final chatCtrl = useCallback(() => ref.read(chatCtrlProvider.notifier));

    return Scaffold(
      body: Padding(
        padding: Insets.padH.copyWith(),
        child: chatData.when(
          loading: Loader.list,
          error: ErrorView.new,
          data: (chats) {
            return RefreshIndicator(
              onRefresh: () async => chatCtrl().reload(),
              child: ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    // onTap: () => context.push(RoutePaths.chatDetails),
                    child: CustomerChatCard(customer: chats[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
