# Smart Home Controller

BIM493 Mobile Programming I · Assignment 2

## Group Members

- Fatma Bakır
- Muhammed Medenioğlu

A Flutter dashboard for three simulated devices. The light switch changes power and displayed brightness, the thermostat buttons adjust the target between 16 °C and 30 °C, and the speaker button toggles playback status. The thermostat status compares the target with a simulated room temperature of 20 °C.

## Run locally

Open this folder in VS Code or Android Studio with Flutter 3.44.4 or later. Start an Android emulator or use Chrome for the web target.

```sh
flutter pub get
flutter run
```

For Chrome, use `flutter run -d chrome`. Run `flutter analyze` for static analysis and `flutter test` for the dashboard interaction test.

## Assignment requirements

| Concept | Implementation |
| --- | --- |
| Class and objects | The dashboard creates one `SmartLight`, one `Thermostat`, and one `SmartSpeaker` and displays all three. |
| Constructors | The light and thermostat use unnamed constructors. The speaker uses the named constructor `SmartSpeaker.kitchen()`. |
| Inheritance and abstraction | All devices extend the abstract class `SmartDevice` and override `getStatus()`. Each card calls that method through its `SmartDevice` reference. |
| Interface | Each device implements `ActionableDevice.performAction()` for its primary action. |
| Mixin | `SmartLight` uses `Switchable` for on/off state and power toggling. |
| `static`, `super`, and `this` | The base constructor increments a static counter. Device constructors call `super` and use `this` for field initialization or constructor redirection. |
| Total devices | The footer reads `SmartDevice.totalDevices`, which exposes the static counter. |
