import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class ProductPackageCard extends StatelessWidget {
  const ProductPackageCard({
    super.key,
    required this.product,
    required this.orderInfo,
  });
  final OrderDetails product;
  final OrderModel orderInfo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            border: Border.all(
              width: 0,
              color: context.colorTheme.primary,
            ),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: Insets.padAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: HostedImage(
                    product.productImage,
                    height: 60,
                    width: 60,
                  ),
                ),
                isThreeLine: true,
                title: Text(
                  product.productName,
                  style: context.textTheme.titleMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: Corners.medBorder,
                        color: context.colorTheme.onSurface.withOpacity(0.07),
                      ),
                      child: Text(
                        product.attribute,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: product.price.formate(),
                          ),
                          TextSpan(
                            text: ' x${product.quantity}',
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Container(
                              height: 10,
                              width: 1,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              color: context.colorTheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: 'Total : ${product.total.formate()}',
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Text(
            orderInfo.deliveryStatus,
            style: context.textTheme.bodyLarge!.copyWith(
              color: context.colorTheme.errorContainer,
            ),
          ),
        )
      ],
    );
  }
}
