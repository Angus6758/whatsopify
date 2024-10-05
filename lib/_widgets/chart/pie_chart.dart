import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class PieChartWidget extends HookConsumerWidget {
  const PieChartWidget({
    super.key,
    required this.data,
  });

  final Map<String, int> data;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(Insets.med),
                for (var MapEntry(:key, :value) in data.entries)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Indicator(
                        color: GraphData.color(key),
                        text: '$key : $value',
                        isSquare: true,
                      ),
                      const Gap(Insets.med),
                    ],
                  ),
              ],
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: context.onMobile ? 16 / 11 : 16 / 6,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections(-1, context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections(
    int touchedIndex,
    BuildContext context,
  ) {
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    final total = data.values.reduce((a, b) => a + b);
    return [
      ...data.entries.where((x) => x.value > 0).map(
        (e) {
          final percentage = (e.value / total) * 100;
          return PieChartSectionData(
            color: GraphData.color(e.key),
            value: percentage,
            title: '${percentage.toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.colorTheme.onPrimary,
              shadows: shadows,
            ),
          );
        },
      ),
    ];
  }
}
