# Project D: Weather App

## Overview

Build a weather app that displays current weather conditions and forecasts using a weather API.

```
┌─────────────────────────────────────────────────────────┐
│                    WEATHER APP                           │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  "Your daily weather companion"                          │
│                                                          │
│  Features:                                               │
│  ├── Current weather for any city                       │
│  ├── 5-day forecast                                     │
│  ├── Save favorite locations                            │
│  ├── Weather details (humidity, wind, etc.)            │
│  └── Beautiful weather icons                            │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Core Features (Required)

### 1. Current Weather

```
MUST HAVE:
□ Search for a city
□ Display current temperature
□ Display weather condition (sunny, rainy, etc.)
□ Display weather icon
□ Display high/low temperatures
```

### 2. Weather Details

```
Each location should show:
├── Current temperature
├── Weather condition
├── Feels like temperature
├── Humidity
├── Wind speed
├── High/Low for today
└── Weather icon
```

### 3. Saved Locations

```
MUST HAVE:
□ Save favorite cities
□ View list of saved cities
□ Quick weather summary for each
□ Remove saved cities
□ Persist saved locations
```

---

## Screens

### Screen 1: Home Screen

```
┌─────────────────────────────────────┐
│                     [🔍] [⚙️]       │
├─────────────────────────────────────┤
│                                     │
│          New York City              │
│          United States              │
│                                     │
│              ☀️                      │
│           (sun icon)                │
│                                     │
│            72°F                     │
│                                     │
│           Sunny                     │
│         H: 78° L: 65°               │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  ┌─────┬─────┬─────┬─────┬─────┐   │
│  │ Mon │ Tue │ Wed │ Thu │ Fri │   │
│  │ ☀️  │ ⛅  │ 🌧️  │ 🌧️  │ ☀️  │   │
│  │ 75° │ 72° │ 68° │ 65° │ 70° │   │
│  └─────┴─────┴─────┴─────┴─────┘   │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  Details                            │
│  ┌─────────────┬─────────────┐     │
│  │ 💨 Wind     │ 🌡️ Feels    │     │
│  │ 12 mph      │ 74°F        │     │
│  └─────────────┴─────────────┘     │
│  ┌─────────────┬─────────────┐     │
│  │ 💧 Humidity │ 👁️ Visibility│     │
│  │ 45%         │ 10 mi       │     │
│  └─────────────┴─────────────┘     │
│                                     │
└─────────────────────────────────────┘
```

### Screen 2: Search Screen

```
┌─────────────────────────────────────┐
│  [←]  Search Location               │
├─────────────────────────────────────┤
│  ┌─────────────────────────────┐   │
│  │ 🔍 Enter city name...       │   │
│  └─────────────────────────────┘   │
│                                     │
│  Recent Searches                    │
│  ┌─────────────────────────────┐   │
│  │ 📍 New York City, US        │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 📍 Los Angeles, US          │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 📍 London, UK               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────────  │
│                                     │
│  Search Results                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 Paris, France            │   │
│  │    ☀️ 68°F - Sunny          │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ 📍 Paris, Texas, US         │   │
│  │    ⛅ 82°F - Partly Cloudy  │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Screen 3: Saved Locations

```
┌─────────────────────────────────────┐
│  [←]  My Locations         [+]     │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 New York City            │   │
│  │ ☀️ 72°F - Sunny        [⭐] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 Los Angeles              │   │
│  │ ⛅ 78°F - Partly Cloudy[☆] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 London                   │   │
│  │ 🌧️ 55°F - Rainy        [☆] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📍 Tokyo                    │   │
│  │ ☀️ 68°F - Clear        [☆] │   │
│  └─────────────────────────────┘   │
│                                     │
│  Swipe left to remove               │
│                                     │
└─────────────────────────────────────┘
```

---

## API Setup

### Using OpenWeatherMap (Free Tier)

1. Sign up at [openweathermap.org](https://openweathermap.org)
2. Get your free API key
3. Free tier includes:
   - Current weather
   - 5-day forecast
   - 60 calls/minute

```dart
// config/api_config.dart
class ApiConfig {
  static const String apiKey = 'YOUR_API_KEY_HERE';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Current weather
  static String currentWeather(String city) =>
    '$baseUrl/weather?q=$city&appid=$apiKey&units=imperial';

  // 5-day forecast
  static String forecast(String city) =>
    '$baseUrl/forecast?q=$city&appid=$apiKey&units=imperial';
}
```

---

## Data Model

```dart
// models/weather.dart
class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final String icon;
  final int humidity;
  final double windSpeed;
  final DateTime dateTime;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.dateTime,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      country: json['sys']['country'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      dateTime: DateTime.now(),
    );
  }

  // Get icon URL
  String get iconUrl =>
    'https://openweathermap.org/img/wn/$icon@2x.png';
}

// models/forecast.dart
class Forecast {
  final DateTime date;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String icon;

  Forecast({
    required this.date,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.icon,
  });

  String get iconUrl =>
    'https://openweathermap.org/img/wn/$icon@2x.png';
}

// models/saved_location.dart
class SavedLocation {
  final String id;
  final String cityName;
  final String country;
  final bool isPrimary;

  SavedLocation({
    required this.id,
    required this.cityName,
    required this.country,
    this.isPrimary = false,
  });
}
```

---

## Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── models/
│   ├── weather.dart
│   ├── forecast.dart
│   └── saved_location.dart
│
├── services/
│   ├── weather_service.dart
│   └── storage_service.dart
│
├── providers/
│   └── weather_provider.dart
│
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── weather_display.dart
│   │       ├── forecast_row.dart
│   │       └── weather_details.dart
│   ├── search/
│   │   └── search_screen.dart
│   ├── locations/
│   │   └── locations_screen.dart
│   └── splash_screen.dart
│
├── widgets/
│   ├── weather_icon.dart
│   ├── location_tile.dart
│   └── loading_indicator.dart
│
├── config/
│   ├── api_config.dart
│   ├── theme.dart
│   └── routes.dart
│
└── utils/
    └── formatters.dart
```

---

## Implementation Steps

### Phase 1: Foundation

```
□ Create Flutter project
□ Set up folder structure
□ Add dependencies (http, provider)
□ Get OpenWeatherMap API key
□ Create Weather model
□ Create WeatherService
□ Test API call works
```

### Phase 2: Core Features

```
□ Create WeatherProvider
□ Implement fetchWeather(city)
□ Build HomeScreen layout
□ Display current weather
□ Add weather icon
□ Display weather details
□ Add search functionality
□ Build SearchScreen
```

### Phase 3: Saved Locations

```
□ Create SavedLocation model
□ Create StorageService (SharedPreferences)
□ Implement saveLocation()
□ Implement getSavedLocations()
□ Build LocationsScreen
□ Show weather for saved locations
□ Delete saved locations
```

### Phase 4: Forecast

```
□ Create Forecast model
□ Implement fetchForecast()
□ Parse 5-day forecast data
□ Build ForecastRow widget
□ Display forecast on HomeScreen
```

### Phase 5: Polish

```
□ Add loading states
□ Add error handling for API failures
□ Handle no internet gracefully
□ Add pull-to-refresh
□ Style with weather-appropriate colors
□ Create splash screen
□ Test all features
```

---

## Weather Service

```dart
// services/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../config/api_config.dart';

class WeatherService {
  // Get current weather
  Future<Weather> getCurrentWeather(String city) async {
    final url = ApiConfig.currentWeather(city);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('City not found');
    } else {
      throw Exception('Failed to load weather');
    }
  }

  // Get 5-day forecast
  Future<List<Forecast>> getForecast(String city) async {
    final url = ApiConfig.forecast(city);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final list = json['list'] as List;

      // Get one forecast per day (every 8th item for 3-hour intervals)
      return list
          .where((item) => list.indexOf(item) % 8 == 0)
          .take(5)
          .map((item) => Forecast.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load forecast');
    }
  }
}
```

---

## Weather Icons

Map weather conditions to icons:

```dart
// widgets/weather_icon.dart
class WeatherIcon extends StatelessWidget {
  final String condition;
  final double size;

  const WeatherIcon({
    required this.condition,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(condition),
      size: size,
      color: _getIconColor(condition),
    );
  }

  IconData _getIconData(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
      case 'drizzle':
        return Icons.water_drop;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.blur_on;
      default:
        return Icons.wb_cloudy;
    }
  }

  Color _getIconColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Colors.orange;
      case 'clouds':
        return Colors.grey;
      case 'rain':
      case 'drizzle':
        return Colors.blue;
      case 'thunderstorm':
        return Colors.purple;
      case 'snow':
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }
}
```

---

## Bonus Features (Optional)

```
NICE TO HAVE:
□ Use device location for default city
□ Hourly forecast
□ Weather animations
□ Weather-based backgrounds
□ Temperature unit toggle (F/C)
□ Weather alerts
□ Sunrise/sunset times
□ Air quality index
□ Weather widgets
□ Share weather
```

---

## Packages to Use

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  http: ^1.1.0
  shared_preferences: ^2.2.2
  intl: ^0.18.1
  geolocator: ^10.1.0  # Optional: for device location

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

---

## Grading Criteria

```
BASIC (Pass) - 60%
□ Can search for a city
□ Shows current temperature
□ Shows weather condition
□ Shows weather icon
□ Handles API errors

GOOD (B Grade) - 75%
□ All basic features
□ Weather details (humidity, wind)
□ Saved locations work
□ UI looks clean
□ Loading states

EXCELLENT (A Grade) - 90%
□ All good features
□ 5-day forecast works
□ Pull to refresh
□ Error handling is smooth
□ Weather-appropriate styling
□ Well organized code

OUTSTANDING (A+ Grade) - 100%
□ All excellent features
□ Bonus features
□ Device location
□ Unit tests
□ Exceptional polish
```

---

## Tips for Success

```
1. TEST API FIRST
   Use Postman or browser to test the API.
   Understand the JSON structure before coding.

2. HANDLE ERRORS GRACEFULLY
   No internet? Show friendly message.
   City not found? Suggest alternatives.

3. CACHE WISELY
   Don't call API on every screen visit.
   Cache results for a few minutes.

4. MIND THE RATE LIMITS
   Free tier has limits.
   Don't refresh too frequently.

5. MAKE IT BEAUTIFUL
   Weather apps should feel nice.
   Use appropriate colors and icons.
```

---

## Example API Response

```json
{
  "coord": {"lon": -74.006, "lat": 40.7143},
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "main": {
    "temp": 72.5,
    "feels_like": 74.1,
    "temp_min": 68.0,
    "temp_max": 78.0,
    "humidity": 45
  },
  "wind": {"speed": 12.5},
  "sys": {"country": "US"},
  "name": "New York"
}
```

---

Good luck with your weather app! ☀️🌧️❄️
