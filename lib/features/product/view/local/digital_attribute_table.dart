import 'package:flutter/cupertino.dart';

class DigitalAttributeTable extends StatelessWidget {
  const DigitalAttributeTable({
    super.key,
    required this.name,
    required this.price,
    required this.status,
    required this.action,
  });
  final String name;
  final String price;
  final String status;
  final List<Widget> action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(
          child: Center(
              child: Text(
            price,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
        ),
        Expanded(
          child: Center(
              child: Text(
            status,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          )),
        ),
        if (action.isNotEmpty)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [...action],
            ),
          ),
      ],
    );
  }
}
