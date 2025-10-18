import '../widgets/shopping_cart.dart';

/// Service class to handle shopping cart business logic
/// This class is testable and doesn't depend on Flutter widgets
class ShoppingCartService {
  final List<CartItem> _items = [];

  /// Get a copy of all items in the cart
  List<CartItem> get items => List.unmodifiable(_items);

  /// Add an item to the cart
  /// If item with same id exists, increase its quantity
  void addItem(String id, String name, double price, {double discount = 0.0}) {
    if (_items.any((item) => item.id == id)) {
      updateQuantity(
        id,
        _items.firstWhere((item) => item.id == id).quantity + 1,
      );
      return;
    }

    _items.add(CartItem(id: id, name: name, price: price, discount: discount));
  }

  /// Remove an item from the cart by id
  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
  }

  /// Update the quantity of an item
  /// If quantity is 0 or negative, the item is removed
  void updateQuantity(String id, int newQuantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
    }
  }

  /// Clear all items from the cart
  void clearCart() {
    _items.clear();
  }

  /// Calculate subtotal (sum of price * quantity for all items)
  double get subtotal {
    double total = 0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  /// Calculate total discount (sum of price * quantity * discount for all items)
  double get totalDiscount {
    double discount = 0;
    for (var item in _items) {
      discount += item.price * item.quantity * item.discount;
    }
    return discount;
  }

  /// Calculate total amount (subtotal - totalDiscount)
  double get totalAmount {
    return subtotal - totalDiscount;
  }

  /// Calculate total number of items in the cart
  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  /// Get number of unique items (not counting quantity)
  int get uniqueItemsCount => _items.length;
}
