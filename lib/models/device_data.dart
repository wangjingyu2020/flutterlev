import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DeviceData {
  final int batteryLevel;
  final BatteryState batteryState;
  final ConnectivityResult connectivityResult;
  final String deviceModel;
  final String osVersion;
  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;
  final DateTime timestamp;

  DeviceData({
    required this.batteryLevel,
    required this.batteryState,
    required this.connectivityResult,
    required this.deviceModel,
    required this.osVersion,
    required this.accelerometerX,
    required this.accelerometerY,
    required this.accelerometerZ,
    required this.timestamp,
  });

  // 复制对象并更新某些字段
  DeviceData copyWith({
    int? batteryLevel,
    BatteryState? batteryState,
    ConnectivityResult? connectivityResult,
    String? deviceModel,
    String? osVersion,
    double? accelerometerX,
    double? accelerometerY,
    double? accelerometerZ,
    DateTime? timestamp,
  }) {
    return DeviceData(
      batteryLevel: batteryLevel ?? this.batteryLevel,
      batteryState: batteryState ?? this.batteryState,
      connectivityResult: connectivityResult ?? this.connectivityResult,
      deviceModel: deviceModel ?? this.deviceModel,
      osVersion: osVersion ?? this.osVersion,
      accelerometerX: accelerometerX ?? this.accelerometerX,
      accelerometerY: accelerometerY ?? this.accelerometerY,
      accelerometerZ: accelerometerZ ?? this.accelerometerZ,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'DeviceData{batteryLevel: $batteryLevel, batteryState: $batteryState, timestamp: $timestamp}';
  }
}