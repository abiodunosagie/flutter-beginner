// Exercise 2: Temperature Converter (Beginner-Intermediate)
// TODO: Create functions to convert temperatures

// TODO: Create celsiusToFahrenheit function with named parameters
double celsiusToFahrenheit({required double celsius}) {
  // Formula: (celsius * 9/5) + 32
  // Your code here
  return 0.0;
}

// TODO: Create fahrenheitToCelsius function with named parameters
double fahrenheitToCelsius({required double fahrenheit}) {
  // Formula: (fahrenheit - 32) * 5/9
  // Your code here
  return 0.0;
}

void main() {
  // Test conversions
  print('100°C = ${celsiusToFahrenheit(celsius: 100).toStringAsFixed(2)}°F');
  print('32°F = ${fahrenheitToCelsius(fahrenheit: 32).toStringAsFixed(2)}°C');
  print('0°C = ${celsiusToFahrenheit(celsius: 0).toStringAsFixed(2)}°F');
  print('98.6°F = ${fahrenheitToCelsius(fahrenheit: 98.6).toStringAsFixed(2)}°C');
}
