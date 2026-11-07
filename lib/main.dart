import 'package:flutter/material.dart';

import 'models/smart_device.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    const ink = Color(0xFF17283C);
    final colors = ColorScheme.fromSeed(seedColor: const Color(0xFF305CA8));

    return MaterialApp(
      title: 'Smart Home Controller',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colors,
        scaffoldBackgroundColor: const Color(0xFFF2F5FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: ink,
          foregroundColor: Colors.white,
        ),
      ),
      home: const DeviceDashboard(),
    );
  }
}

class DeviceDashboard extends StatefulWidget {
  const DeviceDashboard({super.key});

  @override
  State<DeviceDashboard> createState() => _DeviceDashboardState();
}

class _DeviceDashboardState extends State<DeviceDashboard> {
  // Create the devices once. Updating the controls only rebuilds their cards.
  final List<SmartDevice> _devices = [
    SmartLight('Living Room'),
    Thermostat('Bedroom'),
    SmartSpeaker.kitchen(),
  ];

  Widget _buildDeviceCard(SmartDevice device) {
    return switch (device) {
      SmartLight light => _DeviceCard(
        device: light,
        icon: light.isOn ? Icons.lightbulb : Icons.lightbulb_outline,
        accent: const Color(0xFF805100),
        tint: const Color(0xFFFFF1D4),
        property: 'Brightness · ${light.brightness}%',
        active: light.isOn,
        control: Semantics(
          label: 'Light power',
          child: Switch(
            value: light.isOn,
            onChanged: (_) => setState(light.performAction),
          ),
        ),
      ),
      Thermostat thermostat => _DeviceCard(
        device: thermostat,
        icon: Icons.thermostat,
        accent: const Color(0xFF21538D),
        tint: const Color(0xFFE7F1FC),
        property: 'Target · ${thermostat.target} °C',
        active: thermostat.target != thermostat.roomTemperature,
        control: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.outlined(
              tooltip: 'Decrease temperature',
              onPressed: thermostat.target > Thermostat.minTarget
                  ? () => setState(() => thermostat.adjustTemperature(-1))
                  : null,
              icon: const Icon(Icons.remove),
            ),
            const SizedBox(width: 4),
            IconButton.outlined(
              tooltip: 'Increase temperature',
              onPressed: thermostat.target < Thermostat.maxTarget
                  ? () => setState(thermostat.performAction)
                  : null,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
      SmartSpeaker speaker => _DeviceCard(
        device: speaker,
        icon: Icons.speaker_outlined,
        accent: const Color(0xFF594194),
        tint: const Color(0xFFF0E9FC),
        property: 'Volume · ${speaker.volume}%',
        active: speaker.isPlaying,
        control: IconButton.filledTonal(
          tooltip: speaker.isPlaying ? 'Pause speaker' : 'Play speaker',
          onPressed: () => setState(speaker.performAction),
          icon: Icon(speaker.isPlaying ? Icons.pause : Icons.play_arrow),
        ),
      ),
      _ => throw StateError('Unsupported device: ${device.runtimeType}'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Home Controller'),
        leading: const Icon(Icons.home_outlined),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              children: [
                Text('My devices', style: text.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  'Manage lighting, temperature, and audio.',
                  style: text.bodyMedium,
                ),
                const SizedBox(height: 16),
                for (final device in _devices) _buildDeviceCard(device),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        elevation: 3,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              'Total Devices: ${SmartDevice.totalDevices}',
              textAlign: TextAlign.center,
              style: text.titleSmall,
            ),
          ),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({
    required this.device,
    required this.icon,
    required this.accent,
    required this.tint,
    required this.property,
    required this.active,
    required this.control,
  });

  final SmartDevice device;
  final IconData icon;
  final Color accent;
  final Color tint;
  final String property;
  final bool active;
  final Widget control;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFDDE5EF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: tint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(icon, color: accent),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(device.name, style: text.titleMedium),
                      Text(device.room, style: text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(property, style: text.bodyMedium),
                      const SizedBox(height: 2),
                      Text(
                        'Status: ${device.getStatus()}',
                        style: text.bodySmall?.copyWith(
                          color: active ? accent : const Color(0xFF525E6D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                control,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
