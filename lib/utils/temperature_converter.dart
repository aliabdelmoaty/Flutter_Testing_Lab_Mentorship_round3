/// Utility class for temperature conversion between Celsius and Fahrenheit
class TemperatureConverter {
  /// Converts temperature from Celsius to Fahrenheit
  /// Formula: F = (C * 9/5) + 32
  static double celsiusToFahrenheit(double celsius) {
    return (celsius * 9 / 5) + 32;
  }

  /// Converts temperature from Fahrenheit to Celsius
  /// Formula: C = (F - 32) * 5/9
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
}
