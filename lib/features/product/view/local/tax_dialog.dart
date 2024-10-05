import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class TaxDialog extends StatelessWidget {
  const TaxDialog({
    super.key,
    required this.taxes,
  });

  final List<Tax> taxes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text('Tax information'),
      content: SizedBox(
        width: context.width * .9,
        child: SingleChildScrollView(
          child: SeparatedColumn(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            separatorBuilder: () => const Divider(),
            children: [
              for (final tax in taxes)
                SpacedText(
                  left: tax.name,
                  right: tax.amountFormatted(),
                  style: context.textTheme.bodyLarge,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
