# Weather Web App Part 2: Beautiful UI & Complete Integration

## What You'll Learn

In this lesson, you'll build a stunning weather UI with:
- Search bar with autocomplete
- Current weather display with animated backgrounds
- Weather details cards (humidity, wind, pressure)
- 5-day forecast with icons
- Loading states with shimmer effect
- Error handling with retry
- Smooth animations and transitions
- Fully responsive design

## Step 1: Create Responsive Utils

Create `lib/core/utils/responsive.dart`:

```dart
import 'package:flutter/material.dart';

class Breakpoints {
  static const double xs = 0;
  static const double sm = 600;
  static const double md = 900;
  static const double lg = 1200;
  static const double xl = 1600;
}

enum DeviceSize { xs, sm, md, lg, xl }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceSize deviceSize) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  static DeviceSize getDeviceSize(double width) {
    if (width < Breakpoints.sm) return DeviceSize.xs;
    if (width < Breakpoints.md) return DeviceSize.sm;
    if (width < Breakpoints.lg) return DeviceSize.md;
    if (width < Breakpoints.xl) return DeviceSize.lg;
    return DeviceSize.xl;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceSize = getDeviceSize(constraints.maxWidth);
        return builder(context, deviceSize);
      },
    );
  }
}

T responsive<T>(
  BuildContext context, {
  required T xs,
  T? sm,
  T? md,
  T? lg,
  T? xl,
}) {
  final width = MediaQuery.of(context).size.width;
  final deviceSize = ResponsiveBuilder.getDeviceSize(width);

  switch (deviceSize) {
    case DeviceSize.xl:
      return xl ?? lg ?? md ?? sm ?? xs;
    case DeviceSize.lg:
      return lg ?? md ?? sm ?? xs;
    case DeviceSize.md:
      return md ?? sm ?? xs;
    case DeviceSize.sm:
      return sm ?? xs;
    case DeviceSize.xs:
      return xs;
  }
}
```

## Step 2: Create Search Bar Widget

Create `lib/widgets/search_bar_widget.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/theme/weather_colors.dart';

class WeatherSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final bool isLoading;

  const WeatherSearchBar({
    Key? key,
    required this.onSearch,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  final _controller = TextEditingController();
  bool _isFocused = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onSearch(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      decoration: BoxDecoration(
        color: WeatherColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() => _isFocused = hasFocus);
        },
        child: TextField(
          controller: _controller,
          onSubmitted: (_) => _handleSubmit(),
          enabled: !widget.isLoading,
          decoration: InputDecoration(
            hintText: 'Search for a city...',
            hintStyle: TextStyle(
              color: WeatherColors.textDark.withOpacity(0.5),
              fontSize: 16,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: WeatherColors.textDark.withOpacity(0.7),
              size: 24,
            ),
            suffixIcon: widget.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : _controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: WeatherColors.textDark.withOpacity(0.7),
                        ),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.my_location,
                          color: WeatherColors.textDark.withOpacity(0.7),
                        ),
                        onPressed: () {
                          // In a real app, you'd get user's location here
                          widget.onSearch('London');
                        },
                        tooltip: 'Use current location',
                      ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          style: const TextStyle(
            color: WeatherColors.textDark,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
```

## Step 3: Create Current Weather Card

Create `lib/widgets/current_weather_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/models/weather.dart';
import '../core/theme/weather_colors.dart';
import '../core/config/api_config.dart';

class CurrentWeatherCard extends StatelessWidget {
  final Weather weather;

  const CurrentWeatherCard({
    Key? key,
    required this.weather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: WeatherColors.cardOverlay,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // City name and date
          Text(
            weather.cityName,
            style: const TextStyle(
              color: WeatherColors.textLight,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            DateFormat('EEEE, MMM d, yyyy').format(weather.timestamp),
            style: TextStyle(
              color: WeatherColors.textLight.withOpacity(0.8),
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 32),

          // Weather icon
          Image.network(
            ApiConfig.weatherIconUrl(weather.icon),
            width: 120,
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.cloud,
                size: 120,
                color: WeatherColors.textLight,
              );
            },
          ),

          const SizedBox(height: 16),

          // Temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weather.temperature.round().toString(),
                style: const TextStyle(
                  color: WeatherColors.textLight,
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const Text(
                '°C',
                style: TextStyle(
                  color: WeatherColors.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            weather.description.toUpperCase(),
            style: TextStyle(
              color: WeatherColors.textLight.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 8),

          // Feels like
          Text(
            'Feels like ${weather.feelsLike.round()}°C',
            style: TextStyle(
              color: WeatherColors.textLight.withOpacity(0.7),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 32),

          // Min/Max temperature
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTempRange(
                icon: Icons.arrow_downward,
                label: 'Min',
                temp: weather.tempMin,
              ),
              const SizedBox(width: 48),
              _buildTempRange(
                icon: Icons.arrow_upward,
                label: 'Max',
                temp: weather.tempMax,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTempRange({
    required IconData icon,
    required String label,
    required double temp,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: WeatherColors.textLight.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: WeatherColors.textLight.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
        Text(
          '${temp.round()}°C',
          style: const TextStyle(
            color: WeatherColors.textLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
```

## Step 4: Create Weather Details Grid

Create `lib/widgets/weather_details_grid.dart`:

```dart
import 'package:flutter/material.dart';
import '../core/models/weather.dart';
import '../core/theme/weather_colors.dart';
import '../core/utils/responsive.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final Weather weather;

  const WeatherDetailsGrid({
    Key? key,
    required this.weather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final details = [
      WeatherDetail(
        icon: Icons.water_drop,
        label: 'Humidity',
        value: '${weather.humidity}%',
        color: const Color(0xFF3B82F6),
      ),
      WeatherDetail(
        icon: Icons.air,
        label: 'Wind Speed',
        value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
        color: const Color(0xFF10B981),
      ),
      WeatherDetail(
        icon: Icons.speed,
        label: 'Pressure',
        value: '${weather.pressure} hPa',
        color: const Color(0xFFF59E0B),
      ),
      WeatherDetail(
        icon: Icons.cloud,
        label: 'Cloudiness',
        value: '${weather.cloudiness}%',
        color: const Color(0xFF8B5CF6),
      ),
    ];

    return ResponsiveBuilder(
      builder: (context, deviceSize) {
        final crossAxisCount = deviceSize.index >= DeviceSize.md.index ? 4 : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.3,
          ),
          itemCount: details.length,
          itemBuilder: (context, index) {
            return _buildDetailCard(details[index]);
          },
        );
      },
    );
  }

  Widget _buildDetailCard(WeatherDetail detail) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: WeatherColors.cardOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: detail.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              detail.icon,
              color: WeatherColors.textLight,
              size: 28,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            detail.label,
            style: TextStyle(
              color: WeatherColors.textLight.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            detail.value,
            style: const TextStyle(
              color: WeatherColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherDetail {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  WeatherDetail({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}
```

## Step 5: Create Forecast Card

Create `lib/widgets/forecast_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/models/forecast.dart';
import '../core/theme/weather_colors.dart';
import '../core/config/api_config.dart';

class ForecastCard extends StatelessWidget {
  final ForecastItem forecast;

  const ForecastCard({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: WeatherColors.cardOverlay,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Day
          Text(
            DateFormat('EEE').format(forecast.dateTime),
            style: TextStyle(
              color: WeatherColors.textLight.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 4),

          // Date
          Text(
            DateFormat('MMM d').format(forecast.dateTime),
            style: TextStyle(
              color: WeatherColors.textLight.withOpacity(0.6),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          // Icon
          Image.network(
            ApiConfig.weatherIconUrl(forecast.icon),
            width: 60,
            height: 60,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.cloud,
                size: 60,
                color: WeatherColors.textLight,
              );
            },
          ),

          const SizedBox(height: 12),

          // Temperature
          Text(
            '${forecast.temperature.round()}°',
            style: const TextStyle(
              color: WeatherColors.textLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Min/Max
          Text(
            '${forecast.tempMin.round()}° / ${forecast.tempMax.round()}°',
            style: TextStyle(
              color: WeatherColors.textLight.withOpacity(0.6),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            forecast.description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: WeatherColors.textLight.withOpacity(0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
```

## Step 6: Create Main Weather Page

Update `lib/main.dart` with the complete weather app:

```dart
import 'package:flutter/material.dart';
import 'core/services/weather_service.dart';
import 'core/models/weather.dart';
import 'core/models/forecast.dart';
import 'core/theme/weather_colors.dart';
import 'core/utils/responsive.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/weather_details_grid.dart';
import 'widgets/forecast_card.dart';

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
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService();

  Weather? _currentWeather;
  Forecast? _forecast;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Load default city on start
    _loadWeather('London');
  }

  Future<void> _loadWeather(String city) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load both current weather and forecast in parallel
      final results = await Future.wait([
        _weatherService.getCurrentWeather(city),
        _weatherService.getForecast(city),
      ]);

      setState(() {
        _currentWeather = results[0] as Weather;
        _forecast = results[1] as Forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _currentWeather != null
        ? WeatherColors.getGradient(_currentWeather!.mainCondition)
        : WeatherColors.clearSky;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: ResponsiveBuilder(
            builder: (context, deviceSize) {
              final padding = responsive<double>(
                context,
                xs: 16,
                md: 32,
                lg: 48,
              );

              return SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),

                        // Title
                        const Text(
                          'Weather App',
                          style: TextStyle(
                            color: WeatherColors.textLight,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Search bar
                        WeatherSearchBar(
                          onSearch: _loadWeather,
                          isLoading: _isLoading,
                        ),

                        const SizedBox(height: 48),

                        // Content
                        if (_isLoading && _currentWeather == null)
                          _buildLoading()
                        else if (_error != null)
                          _buildError()
                        else if (_currentWeather != null)
                          _buildWeatherContent()
                        else
                          _buildEmptyState(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 100),
          CircularProgressIndicator(
            color: WeatherColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            'Loading weather data...',
            style: TextStyle(
              color: WeatherColors.textLight,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.white,
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _loadWeather('London'),
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        children: [
          SizedBox(height: 100),
          Icon(
            Icons.cloud_outlined,
            size: 100,
            color: WeatherColors.textLight,
          ),
          SizedBox(height: 16),
          Text(
            'Search for a city to get started',
            style: TextStyle(
              color: WeatherColors.textLight,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent() {
    return Column(
      children: [
        // Current weather
        CurrentWeatherCard(weather: _currentWeather!),

        const SizedBox(height: 32),

        // Weather details
        WeatherDetailsGrid(weather: _currentWeather!),

        const SizedBox(height: 48),

        // Forecast title
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '5-Day Forecast',
            style: TextStyle(
              color: WeatherColors.textLight,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Forecast
        if (_forecast != null) _buildForecast(),
      ],
    );
  }

  Widget _buildForecast() {
    final dailyForecasts = _forecast!.getDailyForecasts();

    return ResponsiveBuilder(
      builder: (context, deviceSize) {
        if (deviceSize.index >= DeviceSize.md.index) {
          // Desktop: horizontal scroll
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: dailyForecasts.map((forecast) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: SizedBox(
                    width: 160,
                    child: ForecastCard(forecast: forecast),
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          // Mobile: grid
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: dailyForecasts.length,
            itemBuilder: (context, index) {
              return ForecastCard(forecast: dailyForecasts[index]);
            },
          );
        }
      },
    );
  }
}
```

## Step 7: Test Complete App

Run your weather app:

```bash
flutter run -d chrome
```

**Features to test:**

1. **Search cities**:
   - Try: London, Paris, Tokyo, New York, Mumbai
   - Try invalid: XYZ123 (should show error)

2. **View weather**:
   - Current temperature with icon
   - Weather description
   - Min/Max temperatures
   - Humidity, wind, pressure, cloudiness

3. **View forecast**:
   - 5-day forecast with daily temperatures
   - Weather icons for each day

4. **Responsive design**:
   - Desktop: Forecast in horizontal row
   - Mobile: Forecast in 2-column grid
   - Details grid: 4 columns on desktop, 2 on mobile

5. **Background colors**:
   - Clear sky: Blue gradient
   - Clouds: Gray gradient
   - Rain: Dark gray gradient

## Understanding the Complete Flow

### 1. User Action → API Call

```dart
// User types city and presses enter
void _loadWeather(String city) async {
  // 1. Show loading
  setState(() => _isLoading = true);

  // 2. Call API
  final weather = await _weatherService.getCurrentWeather(city);

  // 3. Update UI
  setState(() {
    _currentWeather = weather;
    _isLoading = false;
  });
}
```

### 2. Parallel API Calls

```dart
// Load both APIs at the same time (faster!)
final results = await Future.wait([
  _weatherService.getCurrentWeather(city),
  _weatherService.getForecast(city),
]);
```

### 3. Error Handling States

```dart
if (_isLoading && _currentWeather == null)
  _buildLoading()  // First load
else if (_error != null)
  _buildError()    // Error occurred
else if (_currentWeather != null)
  _buildContent()  // Success
else
  _buildEmpty()    // Initial state
```

## Exercises

### Exercise 1: Add Temperature Unit Toggle
Add a button to switch between Celsius and Fahrenheit.

**Hint:**
```dart
bool _isCelsius = true;

double _convertTemp(double celsius) {
  return _isCelsius ? celsius : (celsius * 9/5) + 32;
}
```

### Exercise 2: Add Recent Searches
Store last 5 searched cities and show as quick buttons.

**Hint:** Use a List to store cities and show as chips.

### Exercise 3: Add Refresh Button
Add a button to reload weather for current city.

### Exercise 4: Add Loading Skeleton
Instead of spinner, show gray placeholder cards while loading.

### Exercise 5: Add Weather Alerts
If temperature > 35°C, show a "Very Hot!" warning badge.

**Solution:**
```dart
if (weather.temperature > 35) {
  Container(
    padding: EdgeInsets.all(8),
    color: Colors.red,
    child: Text('Very Hot! Stay hydrated!'),
  )
}
```

### Exercise 6: Add Hourly Forecast
The forecast API gives hourly data. Show next 24 hours.

**Hint:**
```dart
final next24Hours = forecast.items.take(8).toList();
```

## Advanced Challenges

### Challenge 1: Add Geolocation
Use browser's geolocation API to get user's city automatically.

### Challenge 2: Add Caching
Cache weather data in browser's localStorage, refresh every 30 minutes.

### Challenge 3: Add Animations
Animate rain drops for rainy weather, snow for snowy weather.

### Challenge 4: Add Charts
Show temperature chart for 5-day forecast using CustomPaint.

### Challenge 5: Add Multiple Cities
Let users add favorite cities and show all in a dashboard.

## What You've Learned

✅ Complete API integration from start to finish
✅ Making HTTP requests and parsing JSON
✅ Handling loading, success, and error states
✅ Parallel API calls with Future.wait()
✅ Creating beautiful, responsive weather UI
✅ Dynamic background gradients based on weather
✅ Working with dates using intl package
✅ Network images with error handling
✅ Responsive layouts for mobile and desktop

## Production Checklist

Before deploying to production:

1. **✅ Environment Variables**
   - Move API key to environment variable
   - Never commit .env file

2. **✅ Error Handling**
   - Handle network errors gracefully
   - Show user-friendly error messages
   - Add retry button

3. **✅ Loading States**
   - Show loading indicators
   - Disable buttons during loading

4. **✅ Caching**
   - Cache API responses
   - Avoid unnecessary API calls

5. **✅ Rate Limiting**
   - Respect API rate limits (1000 calls/day for free tier)
   - Show error if limit exceeded

6. **✅ Responsive Design**
   - Test on different screen sizes
   - Ensure usability on mobile

7. **✅ Accessibility**
   - Add semantic labels
   - Support keyboard navigation

## Congratulations! 🎉

You've built a complete weather web app with real API integration!

**You now know:**
- How to integrate ANY API
- How to parse JSON responses
- How to handle async operations
- How to manage loading/error states
- How to build beautiful, responsive UIs

This knowledge applies to ANY API you'll work with:
- Social media APIs (Twitter, Instagram)
- Payment APIs (Stripe, PayPal)
- Database APIs (Firebase, Supabase)
- AI APIs (OpenAI, Claude)

Keep building! 🚀
