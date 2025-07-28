import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_data_provider.dart';
import '../widgets/status_cards.dart';
import '../widgets/battery_chart.dart';
import '../widgets/accelerometer_chart.dart';
import '../routes/app_routes.dart';

class DeviceMonitorScreen extends StatelessWidget {
  const DeviceMonitorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: Consumer<DeviceDataProvider>(
        builder: (context, provider, child) {
          if (provider.currentData == null) {
            return _buildEmptyState(provider);
          }

          return _buildDataView(provider);
        },
      ),
      floatingActionButton: _buildFloatingButtons(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue.shade300],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.devices,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: 16),
                Text(
                  'Equipment monitor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Device Monitor',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('monitor'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('history'),
            onTap: () {
              Navigator.pop(context);
              AppRoutes.pushNamed(context, AppRoutes.history);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('settings'),
            onTap: () {
              Navigator.pop(context);
              AppRoutes.pushNamed(context, AppRoutes.setting);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('about'),
            onTap: () {
              Navigator.pop(context);
              AppRoutes.pushNamed(context, AppRoutes.about);
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.devices),
          SizedBox(width: 8),
          Text('equipment condition monitoring'),
        ],
      ),
      actions: [
        Consumer<DeviceDataProvider>(
          builder: (context, provider, child) {
            return Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.isMonitoring ? Colors.green : Colors.grey,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  provider.isMonitoring ? "Under monitoring" : "Has stopped",
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(width: 16),
                // 开始/停止按钮
                IconButton(
                  icon: Icon(
                    provider.isMonitoring ? Icons.stop : Icons.play_arrow,
                    size: 28,
                  ),
                  onPressed: () => _toggleMonitoring(provider),
                  tooltip: provider.isMonitoring ? "Stop monitoring" : "Start monitoring",
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(DeviceDataProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.devices,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 24),
          Text(
            'Equipment Monitor',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Click the play button to start real-time monitoring of the device status.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _toggleMonitoring(provider),
            icon: Icon(Icons.play_arrow),
            label: Text('Start monitoring'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataView(DeviceDataProvider provider) {
    return RefreshIndicator(
      onRefresh: () async {
        if (!provider.isMonitoring) {
          await provider.startMonitoring();
        }
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 实时数据概览
            _buildSectionHeader('real time data', Icons.dashboard),
            SizedBox(height: 12),
            StatusCards(data: provider.currentData!),
            SizedBox(height: 24),

            // 电池趋势图
            _buildSectionHeader('Battery Trends', Icons.battery_full),
            SizedBox(height: 12),
            BatteryChart(data: provider.dataHistory),
            SizedBox(height: 24),

            // 加速度计数据图
            _buildSectionHeader('sensor data', Icons.sensors),
            SizedBox(height: 12),
            AccelerometerChart(data: provider.dataHistory),
            SizedBox(height: 24),

            // 数据统计信息
            _buildDataStats(provider),

            // 底部空白，避免被悬浮按钮遮挡
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            margin: EdgeInsets.only(left: 16),
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildDataStats(DeviceDataProvider provider) {
    final dataCount = provider.dataHistory.length;
    final duration = dataCount > 0
        ? DateTime.now().difference(provider.dataHistory.first.timestamp)
        : Duration.zero;

    return Card(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(
                  'Monitoring and statistics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Data points', '$dataCount', Icons.timeline),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Monitoring duration',
                    '${duration.inMinutes} minutes',
                    Icons.timer,
                  ),
                ),
              ],
            ),
            if (provider.currentData != null) ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'last update',
                      _formatLastUpdate(provider.currentData!.timestamp),
                      Icons.update,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'refresh rate',
                      '2 times per second',
                      Icons.refresh,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Consumer<DeviceDataProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 清空历史数据按钮
            if (provider.dataHistory.isNotEmpty)
              FloatingActionButton(
                heroTag: "clear",
                mini: true,
                onPressed: () => _showClearDialog(context, provider),
                child: Icon(Icons.clear_all),
                backgroundColor: Colors.orange,
                tooltip: 'Clear historical data',
              ),

            SizedBox(height: 8),

            // 主控制按钮
            FloatingActionButton(
              heroTag: "main",
              onPressed: () => _toggleMonitoring(provider),
              child: Icon(
                provider.isMonitoring ? Icons.stop : Icons.play_arrow,
                size: 28,
              ),
              backgroundColor: provider.isMonitoring ? Colors.red : Colors.green,
              tooltip: provider.isMonitoring ? 'Stop monitoring' : 'Start monitoring'
            )
          ],
        );
      },
    );
  }

  void _toggleMonitoring(DeviceDataProvider provider) {
    if (provider.isMonitoring) {
      provider.stopMonitoring();
    } else {
      provider.startMonitoring();
    }
  }


  void _showClearDialog(BuildContext context, DeviceDataProvider provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Confirm to clear up'),
            ],
          ),
          content: Text('Are you sure you want to clear all historical monitoring data? This operation cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                provider.clearHistory();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('The historical data has been cleared.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: Text('Confirm to clear'),
            ),
          ],
        );
      },
    );
  }


  String _formatLastUpdate(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} second ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return '${timestamp.hour.toString().padLeft(2, '0')}:'
          '${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}