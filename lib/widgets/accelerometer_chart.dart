import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/device_data.dart';
import '../utils/formatters.dart';

class AccelerometerChart extends StatelessWidget {
  final List<DeviceData> data;

  const AccelerometerChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.length < 2) {
      return Card(
        child: Container(
          height: 260,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sensors, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'Waiting for sensor data...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentData = data.last;
    final magnitude = DeviceFormatters.calculateAccelerometerMagnitude(
      currentData.accelerometerX,
      currentData.accelerometerY,
      currentData.accelerometerZ,
    );

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Accelerometer Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  '${magnitude.toStringAsFixed(1)} m/s²',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (data.length / 5).ceilToDouble(),
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < data.length) {
                            final timestamp = data[value.toInt()].timestamp;
                            return Text(
                              '${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 8),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  lineBarsData: [
                    // X-axis data
                    LineChartBarData(
                      spots: data
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                          entry.key.toDouble(), entry.value.accelerometerX))
                          .toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                    ),
                    // Y-axis data
                    LineChartBarData(
                      spots: data
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                          entry.key.toDouble(), entry.value.accelerometerY))
                          .toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                    ),
                    // Z-axis data
                    LineChartBarData(
                      spots: data
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                          entry.key.toDouble(), entry.value.accelerometerZ))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            _buildLegendRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('X Axis', Colors.red),
        _buildLegendItem('Y Axis', Colors.green),
        _buildLegendItem('Z Axis', Colors.blue),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
