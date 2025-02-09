
import 'package:flutter/material.dart';
import 'package:seller_management/features/product/view/buttons/selectable_chip.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';


class VariantSelection extends StatelessWidget {
  const VariantSelection({
    super.key,
    required this.product,
    required this.selectedVariant,
    required this.onVariantChange,
  });

  final ProductsData product;
  final Function(String variantName, String variant) onVariantChange;
  final Map<String, String> selectedVariant;

  @override
  Widget build(BuildContext context) {
    bool isSelected(String variantName, String variant) {
      return selectedVariant[variantName] != null &&
          selectedVariant[variantName] == variant;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...product.variantTypes.map(
          (variantName) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                variantName,
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children: [
                  ...product
                      .variantsByType(variantName)
                      .map((variant) => SelectableChip(
                            isSelected: isSelected(variantName, variant),
                            child: Text(
                              variant,
                              style: context.textTheme.bodyLarge,
                            ),
                            onTap: () => onVariantChange(variantName, variant),
                          )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
