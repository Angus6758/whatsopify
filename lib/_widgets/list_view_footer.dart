import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class ListViewWithFooter extends StatelessWidget {
  const ListViewWithFooter({
    super.key,
    this.pagination,
    this.onNext,
    this.onPrevious,
    required this.itemBuilder,
    this.emptyListWidget,
    this.itemCount,
    this.shrinkWrap = false,
    this.physics,
  });

  final PaginationInfo? pagination;
  final Function(String? url)? onNext;
  final Function(String? url)? onPrevious;
  final Widget? Function(BuildContext context, int index) itemBuilder;
  final Widget? emptyListWidget;
  final int? itemCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      shrinkWrap: shrinkWrap,
      clipBehavior: Clip.none,
      physics: physics,
      slivers: [
        if (itemCount == 0)
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(context.height / 3),
                emptyListWidget ?? const NoItemWidget(),
              ],
            ),
          )
        else
          SliverList.builder(
            itemBuilder: itemBuilder,
            itemCount: itemCount,
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
        if (itemCount != 0)
          if (pagination != null)
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (pagination?.prevPageUrl != null)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colorTheme.primary,
                      ),
                      onPressed: () =>
                          onPrevious?.call(pagination!.prevPageUrl),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                      ),
                      label: const Text('Previous'),
                    ),
                  const SizedBox(width: 10),
                  if (pagination?.nextPageUrl != null)
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colorTheme.primary,
                      ),
                      onPressed: () => onNext?.call(pagination!.nextPageUrl),
                      icon: const Text('Next'),
                      label:
                          const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                    ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
}
