import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceFormatters {
  /// Get color based on battery level
  static Color getBatteryColor(int level) {
    if (level > 50) return Colors.green;
    if (level > 20) return Colors.orange;
    return Colors.red;
  }

  /// Get battery state text
  static String getBatteryStateText(BatteryState state) {
    switch (state) {
      case BatteryState.charging:
        return 'Charging';
      case BatteryState.discharging:
        return 'Discharging';
      case BatteryState.full:
        return 'Fully Charged';
      case BatteryState.unknown:
      default:
        return 'Unknown';
    }
  }

  /// Get connectivity status text
  static String getConnectivityText(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      return 'WiFi';
    } else if (result == ConnectivityResult.mobile) {
      return 'Mobile Network';
    } else if (result == ConnectivityResult.ethernet) {
      return 'Ethernet';
    } else {
      return 'No Connection';
    }
  }

  /// Get battery icon based on level and state
  static IconData getBatteryIcon(int level, BatteryState state) {
    if (state == BatteryState.charging) {
      return Icons.battery_charging_full;
    }

    if (level > 80) return Icons.battery_full;
    if (level > 60) return Icons.battery_6_bar;
    if (level > 40) return Icons.battery_4_bar;
    if (level > 20) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  /// Get connectivity icon based on connection type
  static IconData getConnectivityIcon(ConnectivityResult result) {
    if (result == ConnectivityResult.wifi) {
      return Icons.wifi;
    } else if (result == ConnectivityResult.mobile) {
      return Icons.signal_cellular_4_bar;
    } else if (result == ConnectivityResult.ethernet) {
      return Icons.settings_ethernet;
    } else {
      return Icons.signal_wifi_off;
    }
  }

  /// Format accelerometer value to 2 decimal places
  static String formatAccelerometerValue(double value) {
    return value.toStringAsFixed(2);
  }

  /// Format timestamp as HH:mm:ss
  static String formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  /// Calculate total accelerometer magnitude
  static double calculateAccelerometerMagnitude(double x, double y, double z) {
    return (x * x + y * y + z * z).abs();
  }
}
