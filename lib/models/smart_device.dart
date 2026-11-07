abstract interface class ActionableDevice {
  void performAction();
}

mixin Switchable {
  bool _isOn = false;

  bool get isOn => _isOn;

  void togglePower() {
    _isOn = !_isOn;
  }
}

abstract class SmartDevice {
  static int _totalDevices = 0;

  static int get totalDevices => _totalDevices;

  final String name;
  final String room;

  SmartDevice(this.name, this.room) {
    _totalDevices++;
  }

  String getStatus();
}

class SmartLight extends SmartDevice
    with Switchable
    implements ActionableDevice {
  final int brightnessWhenOn;

  SmartLight(String room, {this.brightnessWhenOn = 75})
    : super('Smart Light', room);

  int get brightness => isOn ? brightnessWhenOn : 0;

  @override
  void performAction() => togglePower();

  @override
  String getStatus() => isOn ? 'On' : 'Off';
}

class Thermostat extends SmartDevice implements ActionableDevice {
  static const int minTarget = 16;
  static const int maxTarget = 30;

  final int roomTemperature;
  int _target;

  Thermostat(String room, {this.roomTemperature = 20, int target = 22})
    : _target = target.clamp(minTarget, maxTarget),
      super('Thermostat', room);

  int get target => _target;

  void adjustTemperature(int step) {
    _target = (_target + step).clamp(minTarget, maxTarget);
  }

  @override
  void performAction() => adjustTemperature(1);

  @override
  String getStatus() {
    if (_target > roomTemperature) return 'Heating';
    if (_target < roomTemperature) return 'Cooling';
    return 'Idle';
  }
}

class SmartSpeaker extends SmartDevice implements ActionableDevice {
  final int volume;
  bool _isPlaying = false;

  SmartSpeaker(String room, {this.volume = 40}) : super('Smart Speaker', room);

  SmartSpeaker.kitchen() : this('Kitchen');

  bool get isPlaying => _isPlaying;

  @override
  void performAction() {
    _isPlaying = !_isPlaying;
  }

  @override
  String getStatus() => isPlaying ? 'Playing' : 'Paused';
}
