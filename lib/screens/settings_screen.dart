import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_data_provider.dart';
import '../routes/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _enableNotifications = true;
  bool _autoStart = false;
  double _refreshInterval = 2.0;
  bool _showAccelerometer = true;
  bool _showBattery = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => AppRoutes.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Monitoring Settings', Icons.settings),
          _buildSwitchTile(
            title: 'Auto Start Monitoring',
            subtitle: 'Automatically start monitoring on app launch',
            value: _autoStart,
            onChanged: (value) {
              setState(() {
                _autoStart = value;
              });
            },
            icon: Icons.play_circle_outline,
          ),
          _buildSliderTile(
            title: 'Refresh Interval',
            subtitle: 'Data refresh rate: ${_refreshInterval.toStringAsFixed(1)} seconds',
            value: _refreshInterval,
            min: 1.0,
            max: 10.0,
            divisions: 9,
            onChanged: (value) {
              setState(() {
                _refreshInterval = value;
              });
            },
            icon: Icons.refresh,
          ),

          Divider(height: 32),

          _buildSectionHeader('Display Settings', Icons.visibility),
          _buildSwitchTile(
            title: 'Show Battery Chart',
            subtitle: 'Display battery trend chart on the home screen',
            value: _showBattery,
            onChanged: (value) {
              setState(() {
                _showBattery = value;
              });
            },
            icon: Icons.battery_full,
          ),
          _buildSwitchTile(
            title: 'Show Accelerometer',
            subtitle: 'Display sensor data on the home screen',
            value: _showAccelerometer,
            onChanged: (value) {
              setState(() {
                _showAccelerometer = value;
              });
            },
            icon: Icons.sensors,
          ),

          Divider(height: 32),

          _buildSectionHeader('Notification Settings', Icons.notifications),
          _buildSwitchTile(
            title: 'Enable Notifications',
            subtitle: 'Receive notifications for low battery or abnormal status',
            value: _enableNotifications,
            onChanged: (value) {
              setState(() {
                _enableNotifications = value;
              });
            },
            icon: Icons.notifications_active,
          ),

          Divider(height: 32),

          _buildSectionHeader('Others', Icons.more_horiz),
          _buildNavigationTile(
            title: 'History Data',
            subtitle: 'View monitoring history records',
            icon: Icons.history,
            onTap: () => AppRoutes.pushNamed(context, AppRoutes.history),
          ),
          _buildNavigationTile(
            title: 'About App',
            subtitle: 'Version info and help',
            icon: Icons.info_outline,
            onTap: () => AppRoutes.pushNamed(context, AppRoutes.about),
          ),

          SizedBox(height: 32),

          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16, top: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 20),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        secondary: Icon(icon, color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget _buildSliderTile({
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            SizedBox(height: 8),
            Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildNavigationTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveSettings,
            icon: Icon(Icons.save),
            label: Text('Save Settings'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _resetSettings,
            icon: Icon(Icons.restore),
            label: Text('Restore Defaults'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _saveSettings() {
    // Save settings to local storage
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Settings saved'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore Default Settings'),
        content: Text('Are you sure you want to restore all settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _enableNotifications = true;
                _autoStart = false;
                _refreshInterval = 2.0;
                _showAccelerometer = true;
                _showBattery = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Defaults restored'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
