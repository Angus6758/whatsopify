class KNavDestination {
  KNavDestination({
    required this.icon,
    this.isDrawerButton = false,
    this.title = '',
    this.isHighlight,
  });

  final String icon;
  final bool isDrawerButton;
  final String title;
  final bool? isHighlight;
}
