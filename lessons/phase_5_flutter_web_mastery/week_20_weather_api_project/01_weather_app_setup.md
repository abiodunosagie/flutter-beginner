# Weather Web App Part 1: Setup & API Integration

## What You'll Learn

In this complete tutorial, you'll build a beautiful weather web app with:
- Real API integration (OpenWeatherMap API)
- HTTP requests in Flutter web
- JSON parsing and data models
- Loading states and error handling
- Search for any city
- Display current weather and 5-day forecast
- Weather animations and icons
- Responsive design

By the end, you'll know exactly how to integrate ANY API into your Flutter web apps!

## Understanding APIs

**API** stands for "Application Programming Interface". Think of it like a waiter at a restaurant:

1. **You (App)** → Ask waiter for menu item
2. **Waiter (API)** → Takes request to kitchen
3. **Kitchen (Server)** → Prepares the food
4. **Waiter (API)** → Brings food back to you
5. **You (App)** → Enjoy the food!

For weather:
1. **Your App** → "What's the weather in London?"
2. **Weather API** → Asks weather service
3. **Weather Service** → Checks database
4. **Weather API** → Returns JSON data
5. **Your App** → Shows beautiful weather info!

## Step 1: Get Your Free API Key

We'll use OpenWeatherMap because:
- ✅ Free tier (1000 calls/day)
- ✅ Current weather + forecasts
- ✅ Great documentation
- ✅ No credit card required

**How to get API key:**

1. Go to [https://openweathermap.org/api](https://openweathermap.org/api)
2. Click "Sign Up" (top right)
3. Create a free account
4. Go to "API Keys" tab
5. Copy your API key (looks like: `a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`)

**Important:** Your API key takes about 10-15 minutes to activate. Don't worry if it doesn't work immediately!

## Step 2: Create New Flutter Project

Let's create a dedicated weather app:

```bash
flutter create weather_web_app
cd weather_web_app
```

## Step 3: Add Dependencies

Update `pubspec.yaml`:

```yaml
name: weather_web_app
description: A weather web app with real API integration
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  intl: ^0.18.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

Install dependencies:

```bash
flutter pub get
```

## Step 4: Create Environment Configuration

**IMPORTANT:** Never hardcode API keys in your code! Use environment variables.

Create `.env` file in the project root (this won't be committed to git):

```
OPENWEATHER_API_KEY=your_api_key_here
```

Create `.gitignore` to protect your API key:

```
# Environment files
.env

# Flutter
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
build/
```

Create `lib/core/config/api_config.dart`:

```dart
class ApiConfig {
  // In production, load this from environment variables
  // For now, paste your API key here temporarily
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // API Endpoints
  static String currentWeatherUrl(String city) {
    return '$baseUrl/weather?q=$city&appid=$apiKey&units=metric';
  }

  static String forecastUrl(String city) {
    return '$baseUrl/forecast?q=$city&appid=$apiKey&units=metric';
  }

  static String weatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
```

**Replace `YOUR_API_KEY_HERE` with your actual API key!**

## Step 5: Create Weather Data Models

Understanding the JSON response from OpenWeatherMap:

```json
{
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "main": {
    "temp": 25.5,
    "feels_like": 25.3,
    "temp_min": 24.0,
    "temp_max": 27.0,
    "pressure": 1013,
    "humidity": 65
  },
  "wind": {
    "speed": 3.5,
    "deg": 180
  },
  "clouds": {
    "all": 20
  },
  "name": "London"
}
```

Create `lib/core/models/weather.dart`:

```dart
class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int windDegree;
  final int cloudiness;
  final String mainCondition;
  final String description;
  final String icon;
  final DateTime timestamp;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windDegree,
    required this.cloudiness,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.timestamp,
  });

  // Parse from JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] as String,
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      pressure: json['main']['pressure'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      windDegree: json['wind']['deg'] as int,
      cloudiness: json['clouds']['all'] as int,
      mainCondition: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      timestamp: DateTime.now(),
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'temp_min': tempMin,
        'temp_max': tempMax,
        'humidity': humidity,
        'pressure': pressure,
      },
      'wind': {
        'speed': windSpeed,
        'deg': windDegree,
      },
      'clouds': {
        'all': cloudiness,
      },
      'weather': [
        {
          'main': mainCondition,
          'description': description,
          'icon': icon,
        }
      ],
    };
  }
}
```

**What's happening here?**

1. **Model Class**: Represents weather data in our app
2. **fromJson**: Converts API response (Map) to Weather object
3. **json['main']['temp']**: Navigate nested JSON structure
4. **as num).toDouble()**: Handle both int and double from API
5. **json['weather'][0]**: Get first item from weather array
6. **toJson**: Convert back to JSON (for caching later)

Create `lib/core/models/forecast.dart`:

```dart
class ForecastItem {
  final DateTime dateTime;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final String mainCondition;
  final String description;
  final String icon;
  final double windSpeed;
  final int cloudiness;

  const ForecastItem({
    required this.dateTime,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.windSpeed,
    required this.cloudiness,
  });

  factory ForecastItem.fromJson(Map<String, dynamic> json) {
    return ForecastItem(
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        (json['dt'] as int) * 1000,
      ),
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      mainCondition: json['weather'][0]['main'] as String,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      cloudiness: json['clouds']['all'] as int,
    );
  }
}

class Forecast {
  final String cityName;
  final List<ForecastItem> items;

  const Forecast({
    required this.cityName,
    required this.items,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['list'] as List<dynamic>;

    final items = list.map((item) {
      return ForecastItem.fromJson(item as Map<String, dynamic>);
    }).toList();

    return Forecast(
      cityName: json['city']['name'] as String,
      items: items,
    );
  }

  // Get daily forecasts (one per day at noon)
  List<ForecastItem> getDailyForecasts() {
    final Map<String, ForecastItem> dailyMap = {};

    for (var item in items) {
      final dateKey = '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';

      // Keep the forecast closest to noon (12:00)
      if (!dailyMap.containsKey(dateKey)) {
        dailyMap[dateKey] = item;
      } else {
        final existingHour = dailyMap[dateKey]!.dateTime.hour;
        final currentHour = item.dateTime.hour;

        if ((currentHour - 12).abs() < (existingHour - 12).abs()) {
          dailyMap[dateKey] = item;
        }
      }
    }

    return dailyMap.values.toList()..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}
```

## Step 6: Create API Service

This is the heart of our API integration!

Create `lib/core/services/weather_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';
import '../config/api_config.dart';

class WeatherService {
  // Fetch current weather for a city
  Future<Weather> getCurrentWeather(String city) async {
    try {
      // 1. Build the URL
      final url = Uri.parse(ApiConfig.currentWeatherUrl(city));

      // 2. Make HTTP GET request
      final response = await http.get(url);

      // 3. Check if request was successful
      if (response.statusCode == 200) {
        // 4. Decode JSON response
        final Map<String, dynamic> json = jsonDecode(response.body);

        // 5. Convert JSON to Weather object
        return Weather.fromJson(json);
      } else if (response.statusCode == 404) {
        throw WeatherException('City not found. Please check the spelling.');
      } else if (response.statusCode == 401) {
        throw WeatherException('Invalid API key. Please check your configuration.');
      } else {
        throw WeatherException('Failed to load weather data. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException('Network error: ${e.toString()}');
    }
  }

  // Fetch 5-day forecast
  Future<Forecast> getForecast(String city) async {
    try {
      final url = Uri.parse(ApiConfig.forecastUrl(city));
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Forecast.fromJson(json);
      } else if (response.statusCode == 404) {
        throw WeatherException('City not found. Please check the spelling.');
      } else if (response.statusCode == 401) {
        throw WeatherException('Invalid API key. Please check your configuration.');
      } else {
        throw WeatherException('Failed to load forecast data. Status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is WeatherException) {
        rethrow;
      }
      throw WeatherException('Network error: ${e.toString()}');
    }
  }
}

// Custom exception for weather errors
class WeatherException implements Exception {
  final String message;

  WeatherException(this.message);

  @override
  String toString() => message;
}
```

**Understanding HTTP Requests:**

```dart
// 1. Create URL
final url = Uri.parse('https://api.example.com/data?key=value');

// 2. Make request
final response = await http.get(url);

// 3. Check status code
// 200 = Success
// 404 = Not Found
// 401 = Unauthorized (bad API key)
// 500 = Server Error

// 4. Parse JSON
final data = jsonDecode(response.body);

// 5. Convert to model
final weather = Weather.fromJson(data);
```

## Step 7: Create Color Theme

Create `lib/core/theme/weather_colors.dart`:

```dart
import 'package:flutter/material.dart';

class WeatherColors {
  // Background gradients based on weather
  static const LinearGradient clearSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4A90E2),
      Color(0xFF50C9FF),
    ],
  );

  static const LinearGradient cloudy = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF5F6F81),
      Color(0xFF8B95A5),
    ],
  );

  static const LinearGradient rainy = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4A5568),
      Color(0xFF718096),
    ],
  );

  static const LinearGradient snowy = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFB0C4DE),
      Color(0xFFE0E7EF),
    ],
  );

  static const LinearGradient thunderstorm = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2C3E50),
      Color(0xFF4A5F7F),
    ],
  );

  // Get gradient based on weather condition
  static LinearGradient getGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return clearSky;
      case 'clouds':
        return cloudy;
      case 'rain':
      case 'drizzle':
        return rainy;
      case 'snow':
        return snowy;
      case 'thunderstorm':
        return thunderstorm;
      default:
        return clearSky;
    }
  }

  // Text colors
  static const Color textLight = Colors.white;
  static const Color textDark = Color(0xFF2D3748);

  // Card colors
  static const Color cardLight = Colors.white;
  static final Color cardOverlay = Colors.white.withOpacity(0.2);
}
```

## Step 8: Test API Connection

Before building the UI, let's test if our API works!

Create a simple test in `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'core/services/weather_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Web App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: const ApiTestPage(),
    );
  }
}

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({Key? key}) : super(key: key);

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  final _weatherService = WeatherService();
  String _result = 'Click button to test API';
  bool _isLoading = false;

  Future<void> _testApi() async {
    setState(() {
      _isLoading = true;
      _result = 'Loading...';
    });

    try {
      final weather = await _weatherService.getCurrentWeather('London');

      setState(() {
        _result = '''
API Test Successful! ✅

City: ${weather.cityName}
Temperature: ${weather.temperature}°C
Feels Like: ${weather.feelsLike}°C
Condition: ${weather.mainCondition}
Description: ${weather.description}
Humidity: ${weather.humidity}%
Wind Speed: ${weather.windSpeed} m/s
''';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e\n\nCheck:\n1. API key is correct\n2. API key is activated (wait 10-15 min)\n3. Internet connection works';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Connection Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Weather API Test',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _testApi,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Test API Connection'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Step 9: Test It!

Run the app:

```bash
flutter run -d chrome
```

**Click "Test API Connection"**

✅ **If successful**, you'll see:
```
API Test Successful! ✅
City: London
Temperature: 15.5°C
Condition: Clear
...
```

❌ **If you see errors:**

1. **"Invalid API key"**
   - Check you copied the key correctly
   - Wait 10-15 minutes for activation

2. **"City not found"**
   - API works! (The city is wrong, not the API)

3. **"Network error"**
   - Check internet connection
   - Check URL in browser: `https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_KEY&units=metric`

## Understanding What We Built

### 1. API Configuration
```dart
// Centralized API settings
class ApiConfig {
  static const apiKey = 'your_key';
  static const baseUrl = 'https://api...';
}
```

### 2. Data Models
```dart
// Convert JSON ↔ Dart objects
Weather.fromJson(json) // JSON → Weather
weather.toJson()       // Weather → JSON
```

### 3. HTTP Service
```dart
// 1. Build URL
final url = Uri.parse('https://...');

// 2. Make request
final response = await http.get(url);

// 3. Check status
if (response.statusCode == 200) { ... }

// 4. Parse JSON
final data = jsonDecode(response.body);

// 5. Create model
return Weather.fromJson(data);
```

### 4. Error Handling
```dart
try {
  // Make request
} catch (e) {
  // Handle error
  throw WeatherException(message);
}
```

## Exercises

### Exercise 1: Test Different Cities
Modify the test to try different cities: "Paris", "Tokyo", "New York".

### Exercise 2: Add Temperature Conversion
Add a method to Weather class:
```dart
double get temperatureFahrenheit {
  return (temperature * 9/5) + 32;
}
```

### Exercise 3: Handle Invalid City Names
What happens if you search for "XYZ123"? Improve error message.

### Exercise 4: Log API Responses
Print the raw JSON response to understand the structure:
```dart
print('Raw JSON: ${response.body}');
```

### Exercise 5: Test Forecast Endpoint
Create a button to test the forecast API:
```dart
final forecast = await _weatherService.getForecast('London');
print('5-day forecast has ${forecast.items.length} data points');
```

## What You've Learned

✅ How APIs work (request → response cycle)
✅ Getting and using API keys
✅ Making HTTP GET requests in Flutter
✅ Parsing JSON responses
✅ Creating data models with fromJson/toJson
✅ Handling different HTTP status codes
✅ Error handling with try/catch
✅ Organizing API code in services

## Next Steps

In Part 2, we'll build:
- Beautiful weather UI
- Search functionality
- Loading states
- Weather animations
- 5-day forecast display
- Responsive design

You now understand API integration! The next part is just making it look amazing. 🌤️
