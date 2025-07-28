import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_data_provider.dart';
import '../models/device_data.dart';
import '../utils/formatters.dart';
import '../routes/app_routes.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'all';
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Records'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onFilterSelected,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'all', child: Text('All Data')),
              PopupMenuItem(value: 'battery', child: Text('Battery Data')),
              PopupMenuItem(value: 'network', child: Text('Network Data')),
              PopupMenuItem(value: 'sensor', child: Text('Sensor Data')),
            ],
            child: Icon(Icons.filter_list),
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: Consumer<DeviceDataProvider>(
        builder: (context, provider, child) {
          final filteredData = _getFilteredData(provider.dataHistory);

          if (filteredData.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              _buildFilterChips(),
              _buildSummaryCard(filteredData),
              Expanded(
                child: _buildHistoryList(filteredData),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text('No History Available',
              style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          SizedBox(height: 8),
          Text('Start monitoring to generate history',
              style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildFilterChip('all', 'All', Icons.all_inclusive),
          _buildFilterChip('battery', 'Battery', Icons.battery_full),
          _buildFilterChip('network', 'Network', Icons.wifi),
          _buildFilterChip('sensor', 'Sensor', Icons.sensors),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            SizedBox(width: 4),
            Text(label),
          ],
        ),
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedFilter = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildSummaryCard(List<DeviceData> data) {
    if (data.isEmpty) return SizedBox.shrink();

    final latest = data.last;
    final oldest = data.first;
    final duration = latest.timestamp.difference(oldest.timestamp);

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child:
                  _buildSummaryItem('Total Records', '${data.length}', Icons.timeline),
                ),
                Expanded(
                  child: _buildSummaryItem('Time Span',
                      '${duration.inMinutes} minutes', Icons.timer),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                      'Latest Battery', '${latest.batteryLevel}%', Icons.battery_full),
                ),
                Expanded(
                  child: _buildSummaryItem('Network Status',
                      DeviceFormatters.getConnectivityText(latest.connectivityResult),
                      Icons.wifi),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryList(List<DeviceData> data) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[data.length - 1 - index];
        return _buildHistoryItem(item, index);
      },
    );
  }

  Widget _buildHistoryItem(DeviceData data, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: DeviceFormatters.getBatteryColor(data.batteryLevel),
          child: Text(
            '${data.batteryLevel}%',
            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(DeviceFormatters.formatTimestamp(data.timestamp),
            style: TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          '${DeviceFormatters.getBatteryStateText(data.batteryState)} · '
              '${DeviceFormatters.getConnectivityText(data.connectivityResult)}',
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Device Model', data.deviceModel, Icons.phone_android),
                _buildDetailRow('OS Version', data.osVersion, Icons.info),
                _buildDetailRow('Battery State',
                    DeviceFormatters.getBatteryStateText(data.batteryState), Icons.battery_full),
                _buildDetailRow('Network Connection',
                    DeviceFormatters.getConnectivityText(data.connectivityResult), Icons.wifi),
                Divider(),
                Text('Accelerometer Data', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildAccelItem('X Axis', data.accelerometerX, Colors.red)),
                    Expanded(child: _buildAccelItem('Y Axis', data.accelerometerY, Colors.green)),
                    Expanded(child: _buildAccelItem('Z Axis', data.accelerometerZ, Colors.blue)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, style: TextStyle(color: Colors.grey[700]))),
        ],
      ),
    );
  }

  Widget _buildAccelItem(String axis, double value, Color color) {
    return Column(
      children: [
        Text(axis,
            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        Text(DeviceFormatters.formatAccelerometerValue(value),
            style: TextStyle(fontSize: 14)),
      ],
    );
  }

  List<DeviceData> _getFilteredData(List<DeviceData> data) {
    var filtered = data;

    if (_dateRange != null) {
      filtered = filtered.where((item) {
        return item.timestamp.isAfter(_dateRange!.start) &&
            item.timestamp.isBefore(_dateRange!.end.add(Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

  void _onFilterSelected(String value) {
    setState(() {
      _selectedFilter = value;
    });
  }

  void _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 30)),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
    }
  }
}
