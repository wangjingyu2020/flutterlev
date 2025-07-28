import 'package:flutter/material.dart';
import '../models/device_data.dart';
import '../utils/formatters.dart';

class StatusCards extends StatelessWidget {
  final DeviceData data;

  const StatusCards({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Battery Level',
                '${data.batteryLevel}%',
                DeviceFormatters.getBatteryIcon(data.batteryLevel, data.batteryState),
                DeviceFormatters.getBatteryColor(data.batteryLevel),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildInfoCard(
                'Charging Status',
                DeviceFormatters.getBatteryStateText(data.batteryState),
                Icons.power,
                Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Network Status',
                DeviceFormatters.getConnectivityText(data.connectivityResult),
                DeviceFormatters.getConnectivityIcon(data.connectivityResult),
                Colors.blue,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildInfoCard(
                'Device Model',
                data.deviceModel,
                Icons.phone_android,
                Colors.purple,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        _buildInfoCard(
          'OS Version',
          data.osVersion,
          Icons.info,
          Colors.orange,
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Accelerometer X',
                DeviceFormatters.formatAccelerometerValue(data.accelerometerX),
                Icons.swap_horiz,
                Colors.red,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildInfoCard(
                'Accelerometer Y',
                DeviceFormatters.formatAccelerometerValue(data.accelerometerY),
                Icons.swap_vert,
                Colors.green,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildInfoCard(
                'Accelerometer Z',
                DeviceFormatters.formatAccelerometerValue(data.accelerometerZ),
                Icons.threed_rotation,
                Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
