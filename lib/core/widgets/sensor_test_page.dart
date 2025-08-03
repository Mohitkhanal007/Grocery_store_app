import 'package:flutter/material.dart';
import '../sensors/sensor_manager.dart';

class SensorTestPage extends StatefulWidget {
  const SensorTestPage({super.key});

  @override
  State<SensorTestPage> createState() => _SensorTestPageState();
}

class _SensorTestPageState extends State<SensorTestPage> {
  final SensorManager _sensorManager = SensorManager();
  bool _isDarkMode = false;
  int _refreshCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeSensors();
  }

  Future<void> _initializeSensors() async {
    await _sensorManager.initialize();

    _sensorManager.startListening(
      onThemeChanged: (bool isDarkMode) {
        setState(() {
          _isDarkMode = isDarkMode;
        });
        _showSnackBar(
          'Theme changed to: ${isDarkMode ? "Dark" : "Light"} mode',
        );
      },
      onRefreshRequested: () {
        setState(() {
          _refreshCount++;
        });
        _showSnackBar('Page refreshed! (Count: $_refreshCount)');
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  void dispose() {
    _sensorManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: const Text('Sensor Test Page'),
        backgroundColor: _isDarkMode ? Colors.grey[800] : Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: _isDarkMode ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      size: 48,
                      color: _isDarkMode ? Colors.yellow : Colors.orange,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isDarkMode ? 'Dark Mode' : 'Light Mode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Refresh Count: $_refreshCount',
                      style: TextStyle(
                        fontSize: 16,
                        color: _isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            Card(
              color: _isDarkMode ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sensor Instructions:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInstruction(
                      '📱 Shake your phone',
                      'Triggers page refresh',
                      Icons.vibration,
                    ),
                    const SizedBox(height: 8),
                    _buildInstruction(
                      '🤚 Put hand near camera',
                      'Switches to dark mode',
                      Icons.visibility,
                    ),
                    const SizedBox(height: 8),
                    _buildInstruction(
                      '👋 Move hand away',
                      'Switches to light mode',
                      Icons.visibility_off,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Manual Controls
            Card(
              color: _isDarkMode ? Colors.grey[800] : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manual Controls (for testing):',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _sensorManager.triggerDarkMode();
                            },
                            icon: const Icon(Icons.dark_mode),
                            label: const Text('Dark Mode'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[700],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _sensorManager.triggerLightMode();
                            },
                            icon: const Icon(Icons.light_mode),
                            label: const Text('Light Mode'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _sensorManager.triggerRefresh();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Trigger Refresh'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _isDarkMode ? Colors.grey[800] : Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'This is a simulation. In a real app, these would be actual sensor events.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstruction(String title, String description, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: _isDarkMode ? Colors.grey[300] : Colors.grey[600],
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
