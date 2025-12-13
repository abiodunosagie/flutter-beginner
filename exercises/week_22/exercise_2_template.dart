/// Exercise 2: Test a Temperature Converter
///
/// Level: Beginner-Intermediate
///
/// Task:
/// Create a TemperatureConverter class that converts between
/// Celsius, Fahrenheit, and Kelvin, then write comprehensive tests.
///
/// Requirements:
/// 1. Create TemperatureConverter class with methods:
///    - double celsiusToFahrenheit(double celsius)
///    - double fahrenheitToCelsius(double fahrenheit)
///    - double celsiusToKelvin(double celsius)
///    - double kelvinToCelsius(double kelvin)
///    - double fahrenheitToKelvin(double fahrenheit)
///    - double kelvinToFahrenheit(double kelvin)
///
/// 2. Write tests covering:
///    - Normal values (e.g., 0°C = 32°F = 273.15K)
///    - Negative values
///    - Boundary values (absolute zero: -273.15°C = 0K)
///    - Freezing and boiling points of water
///    - Round-trip conversions (C→F→C should equal original)
///
/// Formulas:
/// - F = C × 9/5 + 32
/// - K = C + 273.15
/// - C = (F - 32) × 5/9
/// - C = K - 273.15

class TemperatureConverter {
  // TODO: Implement celsiusToFahrenheit
  double celsiusToFahrenheit(double celsius) {
    throw UnimplementedError();
  }

  // TODO: Implement fahrenheitToCelsius
  double fahrenheitToCelsius(double fahrenheit) {
    throw UnimplementedError();
  }

  // TODO: Implement celsiusToKelvin
  double celsiusToKelvin(double celsius) {
    throw UnimplementedError();
  }

  // TODO: Implement kelvinToCelsius
  double kelvinToCelsius(double kelvin) {
    throw UnimplementedError();
  }

  // TODO: Implement fahrenheitToKelvin
  double fahrenheitToKelvin(double fahrenheit) {
    throw UnimplementedError();
  }

  // TODO: Implement kelvinToFahrenheit
  double kelvinToFahrenheit(double kelvin) {
    throw UnimplementedError();
  }
}

// Example usage:
void main() {
  final converter = TemperatureConverter();

  print('0°C = ${converter.celsiusToFahrenheit(0)}°F'); // 32
  print('32°F = ${converter.fahrenheitToCelsius(32)}°C'); // 0
  print('0°C = ${converter.celsiusToKelvin(0)}K'); // 273.15
}
