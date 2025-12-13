/// Exercise 2 Solution: Test a Temperature Converter
///
/// This solution demonstrates:
/// - Accurate temperature conversion formulas
/// - Validation for absolute zero
/// - Precise calculations with proper rounding

class TemperatureConverter {
  static const double absoluteZeroCelsius = -273.15;
  static const double absoluteZeroFahrenheit = -459.67;

  double celsiusToFahrenheit(double celsius) {
    if (celsius < absoluteZeroCelsius) {
      throw ArgumentError(
        'Temperature cannot be below absolute zero (-273.15°C)',
      );
    }
    return celsius * 9 / 5 + 32;
  }

  double fahrenheitToCelsius(double fahrenheit) {
    if (fahrenheit < absoluteZeroFahrenheit) {
      throw ArgumentError(
        'Temperature cannot be below absolute zero (-459.67°F)',
      );
    }
    return (fahrenheit - 32) * 5 / 9;
  }

  double celsiusToKelvin(double celsius) {
    if (celsius < absoluteZeroCelsius) {
      throw ArgumentError(
        'Temperature cannot be below absolute zero (-273.15°C)',
      );
    }
    return celsius + 273.15;
  }

  double kelvinToCelsius(double kelvin) {
    if (kelvin < 0) {
      throw ArgumentError('Kelvin cannot be negative');
    }
    return kelvin - 273.15;
  }

  double fahrenheitToKelvin(double fahrenheit) {
    final celsius = fahrenheitToCelsius(fahrenheit);
    return celsiusToKelvin(celsius);
  }

  double kelvinToFahrenheit(double kelvin) {
    final celsius = kelvinToCelsius(kelvin);
    return celsiusToFahrenheit(celsius);
  }

  // Helper method for rounding to specified decimal places
  double roundTo(double value, int places) {
    final mod = 10.0.pow(places);
    return (value * mod).round() / mod;
  }
}

// Example usage:
void main() {
  final converter = TemperatureConverter();

  // Freezing point of water
  print('Water freezing point:');
  print('  0°C = ${converter.celsiusToFahrenheit(0)}°F'); // 32
  print('  0°C = ${converter.celsiusToKelvin(0)}K'); // 273.15

  // Boiling point of water
  print('\nWater boiling point:');
  print('  100°C = ${converter.celsiusToFahrenheit(100)}°F'); // 212
  print('  100°C = ${converter.celsiusToKelvin(100)}K'); // 373.15

  // Absolute zero
  print('\nAbsolute zero:');
  print('  -273.15°C = ${converter.celsiusToKelvin(-273.15)}K'); // 0
  print('  0K = ${converter.kelvinToCelsius(0)}°C'); // -273.15

  // Round-trip conversion
  print('\nRound-trip test:');
  final original = 25.0;
  final toF = converter.celsiusToFahrenheit(original);
  final backToC = converter.fahrenheitToCelsius(toF);
  print('  $original°C → $toF°F → $backToC°C'); // Should be 25.0

  // Error handling
  try {
    converter.celsiusToFahrenheit(-300); // Below absolute zero
  } catch (e) {
    print('\nError caught: $e');
  }
}

import 'dart:math';
