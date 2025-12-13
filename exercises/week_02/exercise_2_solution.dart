// Exercise 2: Temperature Converter (SOLUTION)

double celsiusToFahrenheit({required double celsius}) {
  return (celsius * 9 / 5) + 32;
}

double fahrenheitToCelsius({required double fahrenheit}) {
  return (fahrenheit - 32) * 5 / 9;
}

void main() {
  // Test conversions
  print('100°C = ${celsiusToFahrenheit(celsius: 100).toStringAsFixed(2)}°F');
  print('32°F = ${fahrenheitToCelsius(fahrenheit: 32).toStringAsFixed(2)}°C');
  print('0°C = ${celsiusToFahrenheit(celsius: 0).toStringAsFixed(2)}°F');
  print('98.6°F = ${fahrenheitToCelsius(fahrenheit: 98.6).toStringAsFixed(2)}°C');

  // Additional examples
  print('\nMore conversions:');
  print('25°C (Room temp) = ${celsiusToFahrenheit(celsius: 25).toStringAsFixed(2)}°F');
  print('72°F (Nice day) = ${fahrenheitToCelsius(fahrenheit: 72).toStringAsFixed(2)}°C');
}
