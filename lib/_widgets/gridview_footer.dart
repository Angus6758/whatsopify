import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_management/main.export.dart';

class GridViewWithFooter extends StatelessWidget {
  const GridViewWithFooter({
    super.key,
    this.pagination,
    this.onNext,
    this.onPrevious,
    required this.crossAxisCount,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    required this.builder,
    this.itemCount,
    this.shrinkWrap = false,
    this.physics,
    this.emptyListWidget,
  });

  final PaginationInfo? pagination;
  final Function(String? url)? onNext;
  final Function(String? url)? onPrevious;
  final int crossAxisCount;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final Widget? Function(BuildContext context, int index) builder;
  final int? itemCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Widget? emptyListWidget;

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
                Gap(context.height / 4),
                emptyListWidget ?? const NoItemWidget(),
              ],
            ),
          )
        else
          SliverMasonryGrid(
            mainAxisSpacing: mainAxisSpacing ?? 0,
            crossAxisSpacing: crossAxisSpacing ?? 0,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
            ),
            delegate: SliverChildBuilderDelegate(
              builder,
              childCount: itemCount,
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 10)),
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
                    onPressed: () => onPrevious?.call(pagination?.prevPageUrl),
                    icon:
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    label: const Text('Previous'),
                  ),
                const SizedBox(width: 10),
                if (pagination?.nextPageUrl != null)
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colorTheme.primary,
                    ),
                    onPressed: () => onNext?.call(pagination?.nextPageUrl),
                    icon: const Text('Next'),
                    label:
                        const Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 100))
      ],
    );
  }
}
