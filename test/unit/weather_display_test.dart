import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/weather_display.dart';
import 'package:flutter_testing_lab/utils/temperature_converter.dart';

void main() {
  group('WeatherData Unit Tests', () {
    group('WeatherData.fromJson', () {
      test('creates WeatherData from valid complete JSON', () {
        final json = {
          'city': 'New York',
          'temperature': 22.5,
          'description': 'Sunny',
          'humidity': 65,
          'windSpeed': 12.3,
          'icon': '☀️',
        };

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.city, 'New York');
        expect(weatherData.temperatureCelsius, 22.5);
        expect(weatherData.description, 'Sunny');
        expect(weatherData.humidity, 65);
        expect(weatherData.windSpeed, 12.3);
        expect(weatherData.icon, '☀️');
      });

      test('creates WeatherData with default values for optional fields', () {
        final json = {'city': 'London', 'temperature': 15.0};

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.city, 'London');
        expect(weatherData.temperatureCelsius, 15.0);
        expect(weatherData.description, 'N/A');
        expect(weatherData.humidity, 0);
        expect(weatherData.windSpeed, 0.0);
        expect(weatherData.icon, '🌡️');
      });

      test('throws ArgumentError when JSON is null', () {
        expect(
          () => WeatherData.fromJson(null),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'JSON data cannot be null',
            ),
          ),
        );
      });

      test('throws ArgumentError when city is missing', () {
        final json = {'temperature': 22.5, 'description': 'Sunny'};

        expect(
          () => WeatherData.fromJson(json),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Missing required field: city',
            ),
          ),
        );
      });

      test('throws ArgumentError when temperature is missing', () {
        final json = {'city': 'New York', 'description': 'Sunny'};

        expect(
          () => WeatherData.fromJson(json),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              'Missing required field: temperature',
            ),
          ),
        );
      });

      test('handles integer temperature value', () {
        final json = {'city': 'Tokyo', 'temperature': 25};

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.temperatureCelsius, 25.0);
      });

      test('handles null optional fields with defaults', () {
        final json = {
          'city': 'Paris',
          'temperature': 18.5,
          'description': null,
          'humidity': null,
          'windSpeed': null,
          'icon': null,
        };

        final weatherData = WeatherData.fromJson(json);

        expect(weatherData.city, 'Paris');
        expect(weatherData.temperatureCelsius, 18.5);
        expect(weatherData.description, 'N/A');
        expect(weatherData.humidity, 0);
        expect(weatherData.windSpeed, 0.0);
        expect(weatherData.icon, '🌡️');
      });
    });
  });

  group('Temperature Conversion Unit Tests', () {
    group('Celsius to Fahrenheit Conversion', () {
      test('converts 0°C to 32°F', () {
        expect(TemperatureConverter.celsiusToFahrenheit(0), 32.0);
      });

      test('converts 100°C to 212°F (boiling point)', () {
        expect(TemperatureConverter.celsiusToFahrenheit(100), 212.0);
      });

      test('converts 25°C to 77°F', () {
        expect(TemperatureConverter.celsiusToFahrenheit(25), 77.0);
      });

      test('converts -40°C to -40°F', () {
        expect(TemperatureConverter.celsiusToFahrenheit(-40), -40.0);
      });

      test('converts negative temperature -10°C to 14°F', () {
        expect(TemperatureConverter.celsiusToFahrenheit(-10), 14.0);
      });

      test('converts 37°C (body temperature) to 98.6°F', () {
        expect(
          TemperatureConverter.celsiusToFahrenheit(37),
          closeTo(98.6, 0.1),
        );
      });

      test('converts decimal temperature 22.5°C', () {
        expect(TemperatureConverter.celsiusToFahrenheit(22.5), 72.5);
      });

      test('handles very high temperature 1000°C', () {
        expect(TemperatureConverter.celsiusToFahrenheit(1000), 1832.0);
      });

      test('handles very low temperature -273.15°C (absolute zero)', () {
        expect(
          TemperatureConverter.celsiusToFahrenheit(-273.15),
          closeTo(-459.67, 0.01),
        );
      });
    });

    group('Fahrenheit to Celsius Conversion', () {
      test('converts 32°F to 0°C', () {
        expect(TemperatureConverter.fahrenheitToCelsius(32), 0.0);
      });

      test('converts 212°F to 100°C (boiling point)', () {
        expect(TemperatureConverter.fahrenheitToCelsius(212), 100.0);
      });

      test('converts 77°F to 25°C', () {
        expect(TemperatureConverter.fahrenheitToCelsius(77), 25.0);
      });

      test('converts -40°F to -40°C', () {
        expect(TemperatureConverter.fahrenheitToCelsius(-40), -40.0);
      });

      test('converts 14°F to -10°C', () {
        expect(TemperatureConverter.fahrenheitToCelsius(14), -10.0);
      });

      test('converts 98.6°F (body temperature) to ~37°C', () {
        expect(
          TemperatureConverter.fahrenheitToCelsius(98.6),
          closeTo(37, 0.1),
        );
      });

      test('converts decimal temperature 72.5°F', () {
        expect(TemperatureConverter.fahrenheitToCelsius(72.5), 22.5);
      });

      test('handles very high temperature 1832°F', () {
        expect(TemperatureConverter.fahrenheitToCelsius(1832), 1000.0);
      });

      test('handles very low temperature -459.67°F (absolute zero)', () {
        expect(
          TemperatureConverter.fahrenheitToCelsius(-459.67),
          closeTo(-273.15, 0.01),
        );
      });
    });

    group('Round-trip Conversion Tests', () {
      test('C -> F -> C returns original value', () {
        const originalCelsius = 25.0;
        final fahrenheit = TemperatureConverter.celsiusToFahrenheit(
          originalCelsius,
        );
        final backToCelsius = TemperatureConverter.fahrenheitToCelsius(
          fahrenheit,
        );

        expect(backToCelsius, closeTo(originalCelsius, 0.0001));
      });

      test('F -> C -> F returns original value', () {
        const originalFahrenheit = 77.0;
        final celsius = TemperatureConverter.fahrenheitToCelsius(
          originalFahrenheit,
        );
        final backToFahrenheit = TemperatureConverter.celsiusToFahrenheit(
          celsius,
        );

        expect(backToFahrenheit, closeTo(originalFahrenheit, 0.0001));
      });

      test('multiple round-trip conversions maintain precision', () {
        double temperature = 20.0;

        for (int i = 0; i < 10; i++) {
          temperature = TemperatureConverter.celsiusToFahrenheit(temperature);
          temperature = TemperatureConverter.fahrenheitToCelsius(temperature);
        }

        expect(temperature, closeTo(20.0, 0.0001));
      });
    });

    group('Edge Cases and Precision', () {
      test('handles zero temperature', () {
        expect(TemperatureConverter.celsiusToFahrenheit(0), 32.0);
        expect(TemperatureConverter.fahrenheitToCelsius(32), 0.0);
      });

      test('handles very small positive temperature', () {
        expect(
          TemperatureConverter.celsiusToFahrenheit(0.01),
          closeTo(32.018, 0.001),
        );
      });

      test('handles very small negative temperature', () {
        expect(
          TemperatureConverter.celsiusToFahrenheit(-0.01),
          closeTo(31.982, 0.001),
        );
      });

      test('handles decimal precision for typical weather temperatures', () {
        final testTemperatures = [15.5, 20.3, 28.7, -5.2, 35.9];

        for (final temp in testTemperatures) {
          final fahrenheit = TemperatureConverter.celsiusToFahrenheit(temp);
          final backToCelsius = TemperatureConverter.fahrenheitToCelsius(
            fahrenheit,
          );
          expect(backToCelsius, closeTo(temp, 0.0001));
        }
      });
    });

    group('Special Temperature Points', () {
      test('freezing point of water', () {
        expect(TemperatureConverter.celsiusToFahrenheit(0), 32.0);
        expect(TemperatureConverter.fahrenheitToCelsius(32), 0.0);
      });

      test('boiling point of water', () {
        expect(TemperatureConverter.celsiusToFahrenheit(100), 212.0);
        expect(TemperatureConverter.fahrenheitToCelsius(212), 100.0);
      });

      test('average human body temperature', () {
        expect(
          TemperatureConverter.celsiusToFahrenheit(37),
          closeTo(98.6, 0.1),
        );
        expect(
          TemperatureConverter.fahrenheitToCelsius(98.6),
          closeTo(37, 0.1),
        );
      });

      test('comfortable room temperature', () {
        expect(TemperatureConverter.celsiusToFahrenheit(20), 68.0);
        expect(TemperatureConverter.fahrenheitToCelsius(68), 20.0);
      });
    });
  });
}
