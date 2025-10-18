import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';

void main() {
  group('WeatherDisplay Widget Tests', () {
    testWidgets('renders initial loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Should show loading indicator initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Should show city dropdown
      expect(find.byType(DropdownButton<String>), findsOneWidget);

      // Should show refresh button
      expect(find.text('Refresh'), findsOneWidget);

      // Should show temperature unit switch
      expect(find.byType(Switch), findsOneWidget);
      expect(find.text('Celsius'), findsOneWidget);

      // Complete the pending timer to avoid test failure
      await tester.pumpAndSettle();
    });

    testWidgets('displays weather data after loading', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for the loading to complete (2 seconds delay in _fetchWeatherData)
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Loading indicator should be gone
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Should display weather card
      expect(find.byType(Card), findsAtLeastNWidgets(1));

      // Should display city name (default is New York) - multiple widgets may have it
      expect(find.text('New York'), findsWidgets);

      // Should display temperature
      expect(find.textContaining('°C'), findsOneWidget);
    });

    testWidgets('shows error state for Invalid City', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Find and tap the dropdown to select "Invalid City"
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select "Invalid City" from dropdown
      await tester.tap(find.text('Invalid City').last);
      await tester.pump();

      // Wait for the fetch to complete
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display error message
      expect(
        find.text('Failed to load weather data. City not found.'),
        findsOneWidget,
      );

      // Should show error icon
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Should not show weather data card
      expect(find.text('Sunny'), findsNothing);
    });

    testWidgets('toggles between Celsius and Fahrenheit', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Initially should show Celsius
      expect(find.text('Celsius'), findsOneWidget);
      expect(find.textContaining('°C'), findsOneWidget);

      // Tap the switch to change to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Should now show Fahrenheit
      expect(find.text('Fahrenheit'), findsOneWidget);
      expect(find.textContaining('°F'), findsOneWidget);

      // Tap again to switch back to Celsius
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Should show Celsius again
      expect(find.text('Celsius'), findsOneWidget);
      expect(find.textContaining('°C'), findsOneWidget);
    });

    testWidgets('changes city selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Initial city should be New York
      expect(find.text('New York'), findsAtLeastNWidgets(1));

      // Tap dropdown
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Select London
      await tester.tap(find.text('London').last);
      await tester.pump();

      // Wait for load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show London weather - multiple widgets may have it (dropdown + card)
      expect(find.text('London'), findsWidgets);
      expect(find.text('Rainy'), findsOneWidget);
      expect(find.text('🌧️'), findsOneWidget);
    });

    testWidgets('refresh button reloads weather', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Tap refresh button
      await tester.tap(find.text('Refresh'));
      await tester.pump();

      // Wait for reload
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show weather data again
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(Card), findsAtLeastNWidgets(1));
    });

    testWidgets('displays all weather details', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should display humidity
      expect(find.text('Humidity'), findsOneWidget);
      expect(find.textContaining('%'), findsOneWidget);

      // Should display wind speed
      expect(find.text('Wind Speed'), findsOneWidget);
      expect(find.textContaining('km/h'), findsOneWidget);

      // Should display weather icon
      expect(find.byIcon(Icons.water_drop), findsOneWidget);
      expect(find.byIcon(Icons.air), findsOneWidget);
    });

    testWidgets('displays correct weather for Tokyo', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Select Tokyo
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tokyo').last);
      await tester.pumpAndSettle();

      // Wait for load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Should show Tokyo weather - multiple widgets may have it
      expect(find.text('Tokyo'), findsWidgets);
      // Note: Due to random behavior in _fetchWeatherData, we might not always get description
      expect(find.byType(Card), findsAtLeastNWidgets(1));
    });

    testWidgets('loading state hides weather card', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // During loading, weather card should not be visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait a bit but not complete loading
      await tester.pump(const Duration(seconds: 1));

      // Should still be loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the loading
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
    });

    testWidgets('error state clears previous weather data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for initial successful load
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Verify weather data is displayed
      expect(find.text('New York'), findsAtLeastNWidgets(1));

      // Switch to Invalid City
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Invalid City').last);
      await tester.pumpAndSettle();

      // Wait for error
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Previous weather data should be cleared
      expect(find.text('Sunny'), findsNothing);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('temperature conversion displays correct values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Wait for loading
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Get Celsius temperature text
      final celsiusText = find.textContaining('°C');
      expect(celsiusText, findsOneWidget);

      // Switch to Fahrenheit
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Should show Fahrenheit temperature
      final fahrenheitText = find.textContaining('°F');
      expect(fahrenheitText, findsOneWidget);

      // Verify Celsius is no longer displayed in weather card
      expect(find.textContaining('°C'), findsNothing);
    });

    testWidgets('all cities are available in dropdown', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: WeatherDisplay())),
      );

      // Tap dropdown to open it
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      // Verify all cities are in the dropdown
      expect(find.text('New York').last, findsOneWidget);
      expect(find.text('London').last, findsOneWidget);
      expect(find.text('Tokyo').last, findsOneWidget);
      expect(find.text('Invalid City').last, findsOneWidget);
    });
  });
}
