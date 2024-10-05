import 'dart:math' as m;

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_management/features/product/view/common/helper.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';

import 'local.dart';

class ProductDesc extends StatefulWidget {
  const ProductDesc({
    super.key,
    required this.relatedProduct,
    required this.isRegular,
    required this.description,
  });

  final String description;
  final List relatedProduct;
  final bool isRegular;

  @override
  _ProductDescState createState() => _ProductDescState();
}

class _ProductDescState extends State<ProductDesc> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<String> paragraphs = widget.description.split('<br>');
    bool hasMoreThanTwoParagraphs = paragraphs.length > 2;
    String displayedDescription = isExpanded
        ? widget.description
        : paragraphs.take(2).join('<br>');

    return Container(
      color: context.colors.secondaryContainer.withOpacity(0.01),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: displayedDescription.replaceAll('<br>', ''),
                onLinkTap: (url, attributes, element) =>
                url != null ? URLHelper.url(url) : null,
                style: {
                  "*": Style(
                    fontSize: FontSize(16),
                    lineHeight: const LineHeight(1.3),
                    fontWeight: FontWeight.w400,
                    color: context.colors.onSurface,
                    backgroundColor: context.colors.surface,
                  ),
                },
              ),
              if (hasMoreThanTwoParagraphs)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      isExpanded ? 'See Less' : 'See More',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Copy Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Implement copy functionality here
                      },
                      icon: const Icon(Icons.copy, color: Colors.green),
                      label: const Text(
                        'Copy Detail',
                        style: TextStyle(color: Colors.green),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[100],
                        side: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  // Vertical Divider
                  const SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  // Download Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {

                      },
                      icon: const Icon(Icons.download, color: Colors.green),
                      label: const Text(
                        'Download',
                        style: TextStyle(color: Colors.green),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen[100],
                        side: const BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                TR.relatedProduct(context),
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.onMobile ? 2 : 3,
                ),
                clipBehavior: Clip.none,
                itemCount: widget.relatedProduct.length,
                itemBuilder: (context, index) {
                  final relatedData = widget.relatedProduct[index];
                  return widget.isRegular
                      ? Padding(
                    padding: const EdgeInsets.all(5),
                    child: ProductCard(
                      product: relatedData,
                      // to stop hero animation when pushing to related product
                      type: 'related${m.Random().nextInt(300)}',
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.all(5),
                    child: DigitalProductCard(product: relatedData),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
