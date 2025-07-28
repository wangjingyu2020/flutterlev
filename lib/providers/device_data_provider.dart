import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:io';
import '../models/device_data.dart';

class DeviceDataProvider extends ChangeNotifier {
  DeviceData? _currentData;
  List<DeviceData> _dataHistory = [];
  Timer? _timer;
  bool _isMonitoring = false;

  // Hardware and sensor components
  final Battery _battery = Battery();
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  AccelerometerEvent? _lastAccelerometerEvent;

  // Getters
  DeviceData? get currentData => _currentData;
  List<DeviceData> get dataHistory => _dataHistory;
  bool get isMonitoring => _isMonitoring;

  DeviceDataProvider() {
    _initializeSensors();
  }

  /// Initialize sensor listener
  void _initializeSensors() {
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      _lastAccelerometerEvent = event;
    });
  }

  /// Start monitoring device data
  Future<void> startMonitoring() async {
    if (_isMonitoring) return;

    _isMonitoring = true;
    await _collectData();

    // Collect data every 2 seconds
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      await _collectData();
    });

    notifyListeners();
  }

  /// Stop monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _timer?.cancel();
    notifyListeners();
  }

  /// Clear history data
  void clearHistory() {
    _dataHistory.clear();
    notifyListeners();
  }

  /// Collect device data
  Future<void> _collectData() async {
    try {
      // Get battery information
      final batteryLevel = await _battery.batteryLevel;
      final batteryState = await _battery.batteryState;

      // Get network connectivity status
      final connectivityResult = await _connectivity.checkConnectivity();

      // Get device information
      final deviceInfo = await _getDeviceInfo();

      // Get accelerometer data
      final accelerometer = _lastAccelerometerEvent;
      final accelX = accelerometer?.x ?? 0.0;
      final accelY = accelerometer?.y ?? 0.0;
      final accelZ = accelerometer?.z ?? 0.0;

      final newData = DeviceData(
        batteryLevel: batteryLevel,
        batteryState: batteryState,
        connectivityResult: connectivityResult,
        deviceModel: deviceInfo['model'] ?? 'Unknown',
        osVersion: deviceInfo['version'] ?? 'Unknown',
        accelerometerX: accelX,
        accelerometerY: accelY,
        accelerometerZ: accelZ,
        timestamp: DateTime.now(),
      );

      _currentData = newData;
      _dataHistory.add(newData);

      // Keep only the latest 50 records to save memory
      if (_dataHistory.length > 50) {
        _dataHistory.removeAt(0);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Data collection error: $e');
    }
  }

  /// Get device information
  Future<Map<String, String>> _getDeviceInfo() async {
    String deviceModel = 'Unknown';
    String osVersion = 'Unknown';

    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        deviceModel = '${androidInfo.brand} ${androidInfo.model}';
        osVersion = 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        deviceModel = iosInfo.model;
        osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      }
    } catch (e) {
      debugPrint('Device info retrieval error: $e');
    }

    return {
      'model': deviceModel,
      'version': osVersion,
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }
}
