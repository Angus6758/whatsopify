import 'package:flutter/material.dart';

class _PreferredAppBarSize extends Size {
  const _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight(
          (toolbarHeight ?? (bottomHeight == null ? kToolbarHeight : 94)) +
              (bottomHeight ?? 0),
        );

  final double? toolbarHeight;
  final double? bottomHeight;
}

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  KAppBar({
    super.key,
    this.title,
    this.actions,
    this.bottom,
    this.leading,
    this.leadingWidth,
    this.toolbarHeight,
    this.color,
  })  : showLeading = leading != null,
        preferredSize =
            _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height);

  final Widget? title;
  final List<Widget>? actions;
  final bool showLeading;
  final PreferredSizeWidget? bottom;
  final Widget? leading;
  final double? leadingWidth;
  final double? toolbarHeight;
  final Color? color;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    double defLeadingWidth = showLeading ? 70 : 0;
    return AppBar(
      elevation: 0,
      backgroundColor: color,
      automaticallyImplyLeading: false,
      leadingWidth: leadingWidth ?? defLeadingWidth,
      leading: showLeading ? leading : null,
      title: title,
      actions: actions,
      bottom: bottom,
    );
  }
}
