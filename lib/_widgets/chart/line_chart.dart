import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class LineChartWidget extends HookConsumerWidget {
  const LineChartWidget({
    super.key,
    required this.data,
  });

  final Map<String, YearlyData> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mappedData = data.entries.indexed.toList();

    return AspectRatio(
      aspectRatio: 16 / 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: LineChart(
              LineChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 18,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    color: YearlyData.totalColor,
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                    preventCurveOverShooting: true,
                    spots: [
                      ...mappedData.map(
                        (e) => FlSpot(
                          e.$1.toDouble(),
                          e.$2.value.total.toDouble(),
                        ),
                      ),
                    ],
                  ),
                  LineChartBarData(
                    color: YearlyData.physicalColor,
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                    preventCurveOverShooting: true,
                    spots: [
                      ...mappedData.map(
                        (e) => FlSpot(
                          e.$1.toDouble(),
                          e.$2.value.physical.toDouble(),
                        ),
                      ),
                    ],
                  ),
                  LineChartBarData(
                    color: YearlyData.digitalColor,
                    isCurved: true,
                    dotData: const FlDotData(show: false),
                    preventCurveOverShooting: true,
                    spots: [
                      ...mappedData.map(
                        (e) => FlSpot(
                          e.$1.toDouble(),
                          e.$2.value.digital.toDouble(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final text = data.keys.toList()[value.toInt()];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text.substring(0, 3),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
