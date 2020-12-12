import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_charts/chart.dart';

import '../widgets/bar_chart.dart';

class BarChartScreen extends StatefulWidget {
  BarChartScreen({Key key}) : super(key: key);

  @override
  _BarChartScreenState createState() => _BarChartScreenState();
}

class _BarChartScreenState extends State<BarChartScreen> {
  final _values = <BarValue>[];
  double targetMax;
  bool _showValues = false;
  int minItems = 6;

  @override
  void initState() {
    super.initState();
    _updateValues();
  }

  void _updateValues() {
    final Random _rand = Random();
    final double _difference = _rand.nextDouble() * 15;

    targetMax = 3 + ((_rand.nextDouble() * _difference * 0.75) - (_difference * 0.25)).roundToDouble();
    _values.addAll(List.generate(minItems, (index) {
      return BarValue(2 + _rand.nextDouble() * _difference);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bar chart',
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BarChart(
                data: _values,
                height: MediaQuery.of(context).size.height * 0.5,
                dataToValue: (BarValue value) => value.max,
                itemOptions: ChartItemOptions(
                  itemPainter: barItemPainter,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  targetMax: targetMax + 2,
                  targetMin: targetMax,
                  minBarWidth: 6.0,
                  // isTargetInclusive: true,
                  color: Theme.of(context).colorScheme.primary,
                  targetOverColor: Theme.of(context).colorScheme.error,
                  radius: const BorderRadius.vertical(
                    top: Radius.circular(24.0),
                  ),
                ),
                chartOptions: ChartOptions(
                  valueAxisMax: max(
                      _values.fold<double>(
                              0,
                              (double previousValue, BarValue element) =>
                                  previousValue = max(previousValue, element?.max ?? 0)) +
                          1,
                      targetMax + 3),
                  padding: _showValues ? EdgeInsets.only(right: 12.0) : null,
                ),
                backgroundDecorations: [
                  HorizontalAxisDecoration(
                    gridWidth: 2.0,
                    valueAxisStep: 2,
                    gridColor: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.2),
                  ),
                  VerticalAxisDecoration(
                    gridWidth: 2.0,
                    itemAxisStep: 3,
                    gridColor: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.2),
                  ),
                  GridDecoration(
                    showVerticalGrid: true,
                    showHorizontalValues: _showValues,
                    showVerticalValues: _showValues,
                    showTopHorizontalValue: _showValues,
                    valueAxisStep: 1,
                    itemAxisStep: 1,
                    textStyle: Theme.of(context).textTheme.caption,
                    gridColor: Theme.of(context).colorScheme.primaryVariant.withOpacity(0.2),
                  ),
                  TargetAreaDecoration(
                    targetAreaFillColor: Theme.of(context).colorScheme.error.withOpacity(0.2),
                    targetColor: Theme.of(context).colorScheme.error,
                    targetAreaRadius: BorderRadius.circular(12.0),
                  ),
                ],
                foregroundDecorations: [],
              ),
            ),
          ),
          Flexible(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3),
              children: [
                ListTile(
                  leading: Icon(timeDilation == 10 ? Icons.play_arrow : Icons.slow_motion_video),
                  title: Text(timeDilation == 10 ? 'Faster animations' : 'Slower animations'),
                  onTap: () {
                    setState(() {
                      timeDilation = timeDilation == 10 ? 1 : 10;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Refresh dataset'),
                  onTap: () {
                    setState(() {
                      _values.clear();
                      _updateValues();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(_showValues ? Icons.visibility_off : Icons.visibility),
                  title: Text('${_showValues ? 'Hide' : 'Show'} axis values'),
                  onTap: () {
                    setState(() {
                      _showValues = !_showValues;
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add data'),
                  onTap: () {
                    setState(() {
                      _values.clear();
                      minItems += 4;
                      _updateValues();
                    });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.remove),
                  title: Text('Remove data'),
                  onTap: () {
                    setState(() {
                      _values.clear();
                      minItems -= 4;
                      _updateValues();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
