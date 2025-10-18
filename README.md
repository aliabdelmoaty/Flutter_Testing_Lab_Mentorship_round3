# 🧪 Flutter Testing Lab - Mentorship Round 3

[![Flutter Version](https://img.shields.io/badge/Flutter-3.8.1+-02569B?logo=flutter)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.8.1+-0175C2?logo=dart)](https://dart.dev)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen)](#running-tests)
[![License](https://img.shields.io/badge/License-MIT-blue)](#)

## 📋 Project Overview

This project is a comprehensive Flutter testing laboratory that demonstrates proper testing practices, bug fixing, and professional Git workflow. The project contains three widgets that were initially broken and have been fixed with full test coverage.

## 🎯 Mission Statement

As a Flutter developer joining a new team, this project simulates fixing bugs left behind by a previous developer. The focus is on:

- ✅ Identifying and fixing critical bugs
- ✅ Writing comprehensive unit and widget tests
- ✅ Following proper Git workflow with feature branches
- ✅ Maintaining high code quality standards

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── home_page.dart               # Main page with tab navigation
├── widgets/
│   ├── user_registration_form.dart   # Fixed registration form with validation
│   ├── shopping_cart.dart            # Fixed shopping cart with proper calculations
│   └── weather_display.dart          # Fixed weather display with error handling
├── services/
│   └── shopping_cart_service.dart    # Business logic service for cart operations
└── utils/
    └── temperature_converter.dart    # Temperature conversion utilities

test/
├── unit/
│   ├── user_registration_form_test.dart   # Unit tests for form validators
│   ├── shopping_cart_test.dart            # Unit tests for cart logic
│   └── weather_display_test.dart          # Unit tests for weather data
└── widget/
    ├── user_registration_form_widget_test.dart  # Widget tests for registration form
    └── weather_display_widget_test.dart         # Widget tests for weather display
```

## 🐛 Bugs Fixed

### Widget 1: User Registration Form

#### Issues Found:
- ❌ **Email validation** accepted invalid emails like `"a@"`, `"@b"`, or `"user@"`
- ❌ **Password validation** was completely missing (always returned `true`)
- ❌ **Form submission** occurred without proper validation

#### Solutions Implemented:
- ✅ Implemented proper email validation using regex pattern:
  ```dart
  r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
  ```
- ✅ Added strong password validation requiring:
  - Minimum 8 characters
  - At least one uppercase letter (A-Z)
  - At least one lowercase letter (a-z)
  - At least one number (0-9)
  - At least one special character (!@#$&*~)
- ✅ Form now validates before submission

#### Code Changes:
**File:** `lib/widgets/user_registration_form.dart`
- Created `FormValidators` class with static validation methods
- Updated `isValidEmail()` with proper regex
- Updated `isValidPassword()` with comprehensive checks
- Modified `_submitForm()` to validate before submitting

---

### Widget 2: Shopping Cart

#### Issues Found:
- ❌ **Duplicate items** created new entries instead of updating quantity
- ❌ **Discount calculation** was incorrect: `discount * quantity` (wrong!)
- ❌ **Total amount** was calculated as `subtotal + discount` (should be subtraction!)

#### Solutions Implemented:
- ✅ Fixed `addItem()` to check for existing items and update quantity
- ✅ Corrected discount calculation: `price * quantity * discount`
- ✅ Fixed total amount: `subtotal - totalDiscount`
- ✅ Created separate `ShoppingCartService` for testable business logic

#### Code Changes:
**File:** `lib/widgets/shopping_cart.dart`
```dart
// Before: Always added new item
_items.add(CartItem(...));

// After: Check for duplicates
if (_items.any((item) => item.id == id)) {
  updateQuantity(id, existingItem.quantity + 1);
  return;
}
```

```dart
// Before: Wrong discount calculation
discount += item.discount * item.quantity;

// After: Correct calculation
discount += item.price * item.quantity * item.discount;
```

```dart
// Before: Wrong total (adding discount!)
return subtotal + totalDiscount;

// After: Correct total (subtracting discount)
return subtotal - totalDiscount;
```

**File:** `lib/services/shopping_cart_service.dart`
- Extracted business logic into testable service class
- Made methods more testable without Flutter dependencies

---

### Widget 3: Weather Display

#### Issues Found:
- ❌ **Temperature conversion** was missing `+32` in Celsius to Fahrenheit
- ❌ **Fahrenheit to Celsius** formula was completely wrong: `fahrenheit - 32 * 5 / 9`
- ❌ **App crashed** when API returned `null` or incomplete data
- ❌ **Loading state** didn't update on error (stayed loading forever)

#### Solutions Implemented:
- ✅ Fixed temperature conversion formulas:
  - `C to F = (C * 9/5) + 32`
  - `F to C = (F - 32) * 5/9`
- ✅ Added proper null safety and error handling
- ✅ Fixed loading state management
- ✅ Added error message display in UI
- ✅ Created separate `TemperatureConverter` utility class

#### Code Changes:
**File:** `lib/utils/temperature_converter.dart`
```dart
// Fixed formulas
static double celsiusToFahrenheit(double celsius) {
  return (celsius * 9 / 5) + 32;  // Added +32
}

static double fahrenheitToCelsius(double fahrenheit) {
  return (fahrenheit - 32) * 5 / 9;  // Fixed operator precedence
}
```

**File:** `lib/widgets/weather_display.dart`
- Added try-catch block in `_loadWeather()`
- Added null check before parsing data
- Proper error state management
- Error message display in UI

---

## 🧪 Test Coverage

### Unit Tests

#### 1. User Registration Form Tests (`test/unit/user_registration_form_test.dart`)
- ✅ Email validation with valid emails
- ✅ Email validation with invalid emails
- ✅ Password validation with strong passwords
- ✅ Password validation with weak passwords
- ✅ Edge cases: empty strings, special characters

**Test Count:** 8 tests

#### 2. Shopping Cart Tests (`test/unit/shopping_cart_test.dart`)
- ✅ Adding items to cart
- ✅ Duplicate item handling (quantity increase)
- ✅ Removing items from cart
- ✅ Updating item quantities
- ✅ Subtotal calculation
- ✅ Discount calculation (with different discount rates)
- ✅ Total amount calculation
- ✅ Edge cases: empty cart, 100% discount, zero quantity

**Test Count:** 15+ tests

#### 3. Weather Display Tests (`test/unit/weather_display_test.dart`)
- ✅ Temperature conversion (Celsius to Fahrenheit)
- ✅ Temperature conversion (Fahrenheit to Celsius)
- ✅ WeatherData parsing from JSON
- ✅ Null data handling
- ✅ Incomplete data handling
- ✅ Edge cases: negative temperatures, extreme values

**Test Count:** 12+ tests

### Widget Tests

#### 1. Registration Form Widget Tests (`test/widget/user_registration_form_widget_test.dart`)
- ✅ Widget renders correctly
- ✅ All text fields are present
- ✅ Email validation error messages
- ✅ Password validation error messages
- ✅ Password confirmation mismatch
- ✅ Form submission with invalid data (prevented)
- ✅ Form submission with valid data (successful)
- ✅ Loading state during submission
- ✅ Success message display

**Test Count:** 10+ tests

#### 2. Weather Display Widget Tests (`test/widget/weather_display_widget_test.dart`)
- ✅ Widget renders correctly
- ✅ Loading state display
- ✅ Weather data display
- ✅ Error state display
- ✅ Temperature unit switching (Celsius ↔ Fahrenheit)
- ✅ City selection
- ✅ Refresh button functionality
- ✅ Null data error handling

**Test Count:** 12+ tests

### Total Test Count: 50+ tests ✅

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Git

### Installation

1. Clone the repository:
```bash
git clone https://github.com/your-username/Flutter_Testing_Lab_Mentorship_round3.git
cd Flutter_Testing_Lab_Mentorship_round3
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

---

## 🧪 Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/user_registration_form_test.dart
flutter test test/widget/weather_display_widget_test.dart
```

### Run Tests with Coverage
```bash
flutter test --coverage
```

### View Coverage Report (HTML)
```bash
# Install lcov (if not already installed)
# On macOS: brew install lcov
# On Linux: sudo apt-get install lcov

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html

# Open in browser
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

---

## 📊 Git Workflow Used

This project follows a professional Git workflow with feature branches and pull requests:

```
main (production-ready code)
  └── develop (integration branch)
       ├── feature/fix-registration-form ✅ (merged)
       ├── feature/fix-shopping-cart ✅ (merged)
       └── feature/fix-weather-display ✅ (merged)
```

### Workflow Steps for Each Widget:

1. **Create feature branch** from `develop`
   ```bash
   git checkout develop
   git checkout -b feature/fix-widget-name
   ```

2. **Fix bugs and write tests**
   - Analyze and document bugs
   - Implement fixes
   - Write comprehensive tests
   - Ensure all tests pass

3. **Commit changes**
   ```bash
   git add .
   git commit -m "Fix: descriptive message"
   ```

4. **Push and create Pull Request**
   ```bash
   git push -u origin feature/fix-widget-name
   ```
   - Create PR on GitHub/GitLab
   - Document bugs, solutions, and test coverage
   - Request code review

5. **Merge to develop**
   - After approval, merge PR
   - Delete feature branch

6. **Final merge to main**
   ```bash
   git checkout develop
   git pull origin develop
   # Create PR: develop → main
   # Merge after final review
   ```

---

## 📝 Commit Message Convention

This project follows conventional commit messages:

- `Fix:` Bug fixes
- `Feature:` New features
- `Test:` Adding or updating tests
- `Refactor:` Code refactoring
- `Docs:` Documentation updates
- `Style:` Code style changes (formatting)
- `Chore:` Maintenance tasks

**Example:**
```
Fix: User registration email validation and password strength

- Implemented proper email validation with regex
- Added strong password requirements (8+ chars, numbers, symbols)
- Fixed form submission to validate before submitting
- Added comprehensive unit and widget tests
```

---

## 🛠️ Technologies Used

- **Flutter** - UI framework
- **Dart** - Programming language
- **flutter_test** - Testing framework
- **Git** - Version control
- **GitHub** - Repository hosting and PR workflow

---

## 📚 What I Learned

### Testing Best Practices
- ✅ Writing unit tests for business logic
- ✅ Writing widget tests for UI behavior
- ✅ Testing edge cases and error scenarios
- ✅ Mocking dependencies for isolated tests
- ✅ Achieving high test coverage

### Flutter Best Practices
- ✅ Proper form validation
- ✅ State management
- ✅ Error handling and null safety
- ✅ Separation of concerns (widgets vs services)
- ✅ User feedback (loading states, error messages)

### Git Workflow
- ✅ Feature branch workflow
- ✅ Writing descriptive commit messages
- ✅ Creating professional Pull Requests
- ✅ Code review process
- ✅ Branch management (develop → main)

---

## 🎓 Mentorship Round 3 Requirements

All requirements have been completed:

- ✅ **Fixed Widget 1** - User Registration Form (validation bugs)
- ✅ **Fixed Widget 2** - Shopping Cart (calculation bugs)
- ✅ **Fixed Widget 3** - Weather Display (conversion & error handling bugs)
- ✅ **Wrote comprehensive tests** (50+ tests total)
- ✅ **Followed Git workflow** (feature branches + PRs)
- ✅ **Documented everything** (this README)

---

## 🤝 Contributing

This is a mentorship project, but if you'd like to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License.

---

## 👨‍💻 Author

**Omar Ahmed**  
Flutter Developer | Mentorship Round 3

---

## 🙏 Acknowledgments

- Thanks to the mentorship program for providing this practical testing challenge
- Flutter team for excellent documentation
- Community for testing best practices

---
