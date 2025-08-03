import 'package:flutter/material.dart';
import '../sensors/sensor_manager.dart';

class SensorAwareWidget extends StatefulWidget {
  final Widget child;
  final bool enableProximitySensor;
  final bool enableShakeSensor;
  final Function(bool isDarkMode)? onThemeChanged;
  final Function()? onRefreshRequested;

  const SensorAwareWidget({
    super.key,
    required this.child,
    this.enableProximitySensor = true,
    this.enableShakeSensor = true,
    this.onThemeChanged,
    this.onRefreshRequested,
  });

  @override
  State<SensorAwareWidget> createState() => _SensorAwareWidgetState();
}

class _SensorAwareWidgetState extends State<SensorAwareWidget> {
  final SensorManager _sensorManager = SensorManager();
  bool _isDarkMode = false;
  bool _sensorsAvailable = false;

  @override
  void initState() {
    super.initState();
    _initializeSensors();
  }

  Future<void> _initializeSensors() async {
    try {
      // Initialize sensors
      await _sensorManager.initialize();

      // Check sensor availability
      final availability = await _sensorManager.checkSensorAvailability();
      _sensorsAvailable =
          availability['proximity'] == true || availability['shake'] == true;

      if (_sensorsAvailable) {
        // Start listening to sensors
        _sensorManager.startListening(
          onThemeChanged: (bool isDarkMode) {
            setState(() {
              _isDarkMode = isDarkMode;
            });
            widget.onThemeChanged?.call(isDarkMode);
          },
          onRefreshRequested: () {
            widget.onRefreshRequested?.call();
          },
        );

        print('✅ Sensors initialized and listening');
      } else {
        print('⚠️ No sensors available on this device');
      }
    } catch (e) {
      print('❌ Error initializing sensors: $e');
    }
  }

  @override
  void dispose() {
    _sensorManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: Stack(
          children: [
            // Main content
            widget.child,

            // Sensor status indicator (for debugging)
            if (_sensorsAvailable)
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _isDarkMode ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        size: 16,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isDarkMode ? 'Dark' : 'Light',
                        style: TextStyle(
                          fontSize: 12,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Shake hint (for debugging)
            if (_sensorsAvailable)
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _isDarkMode ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Shake to refresh • Hand near camera for dark mode',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
