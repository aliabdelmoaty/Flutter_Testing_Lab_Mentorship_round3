import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_lab/widgets/shopping_cart.dart';
import 'package:flutter_testing_lab/services/shopping_cart_service.dart';

void main() {
  group('CartItem Unit Tests', () {
    test('CartItem creation with default values', () {
      final item = CartItem(id: '1', name: 'Test Product', price: 99.99);

      expect(item.id, '1');
      expect(item.name, 'Test Product');
      expect(item.price, 99.99);
      expect(item.quantity, 1);
      expect(item.discount, 0.0);
    });

    test('CartItem creation with custom values', () {
      final item = CartItem(
        id: '2',
        name: 'Discounted Product',
        price: 199.99,
        quantity: 5,
        discount: 0.25,
      );

      expect(item.id, '2');
      expect(item.name, 'Discounted Product');
      expect(item.price, 199.99);
      expect(item.quantity, 5);
      expect(item.discount, 0.25);
    });

    test('CartItem with 100% discount', () {
      final item = CartItem(
        id: '3',
        name: 'Free Product',
        price: 50.0,
        discount: 1.0,
      );

      expect(item.discount, 1.0);
      final discountAmount = item.price * item.quantity * item.discount;
      expect(discountAmount, 50.0);
    });
  });

  group('ShoppingCart - Add Item Operations', () {
    late ShoppingCartService cart;

    setUp(() {
      cart = ShoppingCartService();
    });

    test('Add single item to empty cart', () {
      cart.addItem('1', 'iPhone', 999.99);

      expect(cart.totalItems, 1);
      expect(cart.uniqueItemsCount, 1);
      expect(cart.subtotal, 999.99);
      expect(cart.isEmpty, false);
    });

    test('Add multiple different items', () {
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('2', 'Samsung', 899.99);
      cart.addItem('3', 'iPad', 1099.99);

      expect(cart.totalItems, 3);
      expect(cart.uniqueItemsCount, 3);
      expect(cart.subtotal, closeTo(2999.97, 0.01));
    });

    test('Add same item twice increases quantity', () {
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('1', 'iPhone', 999.99);

      expect(cart.totalItems, 2);
      expect(cart.uniqueItemsCount, 1);
      expect(cart.subtotal, 1999.98);
    });

    test('Add item with discount', () {
      cart.addItem('1', 'iPhone', 999.99, discount: 0.1);

      expect(cart.totalItems, 1);
      expect(cart.subtotal, 999.99);
      expect(cart.totalDiscount, closeTo(99.999, 0.01));
      expect(cart.totalAmount, closeTo(900.00, 0.01));
    });

    test('Add item with 100% discount', () {
      cart.addItem('1', 'Free Item', 100.0, discount: 1.0);

      expect(cart.totalItems, 1);
      expect(cart.subtotal, 100.0);
      expect(cart.totalDiscount, 100.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Add multiple items with different discounts', () {
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1); // 10% off
      cart.addItem('2', 'Samsung', 800.0, discount: 0.2); // 20% off
      cart.addItem('3', 'iPad', 1200.0); // No discount

      expect(cart.subtotal, 3000.0);
      expect(cart.totalDiscount, 260.0); // 100 + 160
      expect(cart.totalAmount, 2740.0);
    });
  });

  group('ShoppingCart - Remove Item Operations', () {
    late ShoppingCartService cart;

    setUp(() {
      cart = ShoppingCartService();
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('2', 'Samsung', 899.99);
    });

    test('Remove existing item', () {
      cart.removeItem('1');

      expect(cart.totalItems, 1);
      expect(cart.uniqueItemsCount, 1);
      expect(cart.subtotal, 899.99);
    });

    test('Remove non-existing item does nothing', () {
      cart.removeItem('999');

      expect(cart.totalItems, 2);
      expect(cart.uniqueItemsCount, 2);
      expect(cart.subtotal, 1899.98);
    });

    test('Remove all items one by one', () {
      cart.removeItem('1');
      cart.removeItem('2');

      expect(cart.totalItems, 0);
      expect(cart.uniqueItemsCount, 0);
      expect(cart.subtotal, 0.0);
      expect(cart.isEmpty, true);
    });
  });

  group('ShoppingCart - Update Quantity Operations', () {
    late ShoppingCartService cart;

    setUp(() {
      cart = ShoppingCartService();
      cart.addItem('1', 'iPhone', 1000.0, discount: 0.1);
    });

    test('Increase quantity', () {
      cart.updateQuantity('1', 3);

      expect(cart.totalItems, 3);
      expect(cart.subtotal, 3000.0);
      expect(cart.totalDiscount, 300.0);
      expect(cart.totalAmount, 2700.0);
    });

    test('Decrease quantity', () {
      cart.updateQuantity('1', 5);
      cart.updateQuantity('1', 2);

      expect(cart.totalItems, 2);
      expect(cart.subtotal, 2000.0);
      expect(cart.totalDiscount, 200.0);
      expect(cart.totalAmount, 1800.0);
    });

    test('Set quantity to zero removes item', () {
      cart.updateQuantity('1', 0);

      expect(cart.totalItems, 0);
      expect(cart.uniqueItemsCount, 0);
      expect(cart.subtotal, 0.0);
      expect(cart.isEmpty, true);
    });

    test('Set quantity to negative removes item', () {
      cart.updateQuantity('1', -5);

      expect(cart.totalItems, 0);
      expect(cart.uniqueItemsCount, 0);
      expect(cart.subtotal, 0.0);
      expect(cart.isEmpty, true);
    });

    test('Update quantity of non-existing item does nothing', () {
      cart.updateQuantity('999', 5);

      expect(cart.totalItems, 1);
      expect(cart.uniqueItemsCount, 1);
    });

    test('Update quantity with large number', () {
      cart.updateQuantity('1', 1000);

      expect(cart.totalItems, 1000);
      expect(cart.subtotal, 1000000.0);
      expect(cart.totalDiscount, 100000.0);
      expect(cart.totalAmount, 900000.0);
    });
  });

  group('ShoppingCart - Clear Cart Operations', () {
    late ShoppingCartService cart;

    setUp(() {
      cart = ShoppingCartService();
    });

    test('Clear empty cart', () {
      cart.clearCart();

      expect(cart.totalItems, 0);
      expect(cart.isEmpty, true);
      expect(cart.subtotal, 0.0);
    });

    test('Clear cart with items', () {
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('2', 'Samsung', 899.99);
      cart.addItem('3', 'iPad', 1099.99);

      cart.clearCart();

      expect(cart.totalItems, 0);
      expect(cart.uniqueItemsCount, 0);
      expect(cart.isEmpty, true);
      expect(cart.subtotal, 0.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 0.0);
    });
  });

  group('ShoppingCart - Calculation Edge Cases', () {
    late ShoppingCartService cart;

    setUp(() {
      cart = ShoppingCartService();
    });

    test('Empty cart calculations', () {
      expect(cart.totalItems, 0);
      expect(cart.isEmpty, true);
      expect(cart.subtotal, 0.0);
      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Cart with zero price items', () {
      cart.addItem('1', 'Free Sample', 0.0);

      expect(cart.totalItems, 1);
      expect(cart.subtotal, 0.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Cart with 100% discount on all items', () {
      cart.addItem('1', 'Item 1', 100.0, discount: 1.0);
      cart.addItem('2', 'Item 2', 200.0, discount: 1.0);
      cart.addItem('3', 'Item 3', 300.0, discount: 1.0);

      expect(cart.subtotal, 600.0);
      expect(cart.totalDiscount, 600.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Cart with very small prices', () {
      cart.addItem('1', 'Penny Item', 0.01);

      expect(cart.subtotal, 0.01);
      expect(cart.totalAmount, 0.01);
    });

    test('Cart with very large prices', () {
      cart.addItem('1', 'Luxury Item', 999999.99);

      expect(cart.subtotal, 999999.99);
      expect(cart.totalAmount, 999999.99);
    });

    test('Discount calculation precision', () {
      cart.addItem('1', 'Item', 99.99, discount: 0.15);

      expect(cart.subtotal, 99.99);
      expect(cart.totalDiscount, closeTo(14.9985, 0.0001));
      expect(cart.totalAmount, closeTo(84.9915, 0.0001));
    });

    test('Multiple quantities with discount', () {
      cart.addItem('1', 'iPhone', 999.99, discount: 0.1);
      cart.updateQuantity('1', 5);

      expect(cart.totalItems, 5);
      expect(cart.subtotal, closeTo(4999.95, 0.01));
      expect(cart.totalDiscount, closeTo(499.995, 0.01));
      expect(cart.totalAmount, closeTo(4499.955, 0.01));
    });

    test('Mixed cart: items with and without discount', () {
      cart.addItem('1', 'Full Price', 100.0);
      cart.addItem('2', '50% Off', 100.0, discount: 0.5);
      cart.addItem('3', '100% Off', 100.0, discount: 1.0);

      expect(cart.subtotal, 300.0);
      expect(cart.totalDiscount, 150.0);
      expect(cart.totalAmount, 150.0);
    });
  });

  group('ShoppingCart - Complex Scenarios', () {
    late ShoppingCartService cart;

    setUp(() {
      cart = ShoppingCartService();
    });

    test('Add, update, and remove multiple items', () {
      // Add items
      cart.addItem('1', 'iPhone', 999.99, discount: 0.1);
      cart.addItem('2', 'Samsung', 899.99, discount: 0.15);
      cart.addItem('3', 'iPad', 1099.99);

      // Update quantities
      cart.updateQuantity('1', 2);
      cart.updateQuantity('2', 3);

      // Remove one item
      cart.removeItem('3');

      expect(cart.totalItems, 5);
      expect(cart.uniqueItemsCount, 2);
      expect(cart.subtotal, closeTo(4699.94, 0.02));
      expect(cart.totalDiscount, closeTo(604.9965, 0.01));
      expect(cart.totalAmount, closeTo(4094.9435, 0.02));
    });

    test(
      'Add same item multiple times with different discount (should use first)',
      () {
        cart.addItem('1', 'iPhone', 999.99, discount: 0.1);
        cart.addItem(
          '1',
          'iPhone',
          999.99,
          discount: 0.5,
        ); // Should increase quantity only

        expect(cart.totalItems, 2);
        expect(cart.uniqueItemsCount, 1);
        // Discount should be from first add (0.1)
        expect(cart.totalDiscount, closeTo(199.998, 0.01));
      },
    );

    test('Rapid quantity changes', () {
      cart.addItem('1', 'Test', 100.0);
      cart.updateQuantity('1', 10);
      cart.updateQuantity('1', 5);
      cart.updateQuantity('1', 15);
      cart.updateQuantity('1', 1);

      expect(cart.totalItems, 1);
      expect(cart.subtotal, 100.0);
    });

    test('Clear and repopulate cart', () {
      cart.addItem('1', 'iPhone', 999.99);
      cart.addItem('2', 'Samsung', 899.99);
      cart.clearCart();

      expect(cart.totalItems, 0);
      expect(cart.isEmpty, true);

      cart.addItem('3', 'iPad', 1099.99);
      expect(cart.totalItems, 1);
      expect(cart.isEmpty, false);
      expect(cart.subtotal, 1099.99);
    });
  });

  group('ShoppingCart - Boundary Testing', () {
    late ShoppingCartService cart;

    setUp(() {
      cart = ShoppingCartService();
    });

    test('Quantity limit: very large quantity', () {
      cart.addItem('1', 'Item', 1.0);
      cart.updateQuantity('1', 999999);

      expect(cart.totalItems, 999999);
      expect(cart.subtotal, 999999.0);
    });

    test('Discount boundary: exactly 0% discount', () {
      cart.addItem('1', 'Item', 100.0, discount: 0.0);

      expect(cart.totalDiscount, 0.0);
      expect(cart.totalAmount, 100.0);
    });

    test('Discount boundary: exactly 100% discount', () {
      cart.addItem('1', 'Item', 100.0, discount: 1.0);

      expect(cart.totalDiscount, 100.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Price boundary: zero price', () {
      cart.addItem('1', 'Free Item', 0.0);
      cart.updateQuantity('1', 100);

      expect(cart.subtotal, 0.0);
      expect(cart.totalAmount, 0.0);
    });

    test('Multiple items reaching large total', () {
      for (int i = 1; i <= 100; i++) {
        cart.addItem('$i', 'Item $i', 99.99);
      }

      expect(cart.totalItems, 100);
      expect(cart.uniqueItemsCount, 100);
      expect(cart.subtotal, closeTo(9999.0, 1.0));
    });

    test('Quantity boundary: transition from 1 to 0', () {
      cart.addItem('1', 'Item', 100.0);
      expect(cart.isEmpty, false);

      cart.updateQuantity('1', 0);
      expect(cart.isEmpty, true);
    });

    test('Negative quantity handling', () {
      cart.addItem('1', 'Item', 100.0);
      cart.updateQuantity('1', -100);

      expect(cart.isEmpty, true);
      expect(cart.totalItems, 0);
    });
  });

  group('ShoppingCart - Discount Calculation Tests', () {
    late ShoppingCartService cart;

    setUp(() {
      cart = ShoppingCartService();
    });

    test('10% discount calculation', () {
      cart.addItem('1', 'Item', 100.0, discount: 0.1);

      expect(cart.subtotal, 100.0);
      expect(cart.totalDiscount, 10.0);
      expect(cart.totalAmount, 90.0);
    });

    test('25% discount calculation', () {
      cart.addItem('1', 'Item', 200.0, discount: 0.25);

      expect(cart.subtotal, 200.0);
      expect(cart.totalDiscount, 50.0);
      expect(cart.totalAmount, 150.0);
    });

    test('50% discount calculation', () {
      cart.addItem('1', 'Item', 100.0, discount: 0.5);

      expect(cart.subtotal, 100.0);
      expect(cart.totalDiscount, 50.0);
      expect(cart.totalAmount, 50.0);
    });

    test('75% discount calculation', () {
      cart.addItem('1', 'Item', 100.0, discount: 0.75);

      expect(cart.subtotal, 100.0);
      expect(cart.totalDiscount, 75.0);
      expect(cart.totalAmount, 25.0);
    });

    test('Discount with multiple quantities', () {
      cart.addItem('1', 'Item', 50.0, discount: 0.2);
      cart.updateQuantity('1', 10);

      expect(cart.subtotal, 500.0);
      expect(cart.totalDiscount, 100.0);
      expect(cart.totalAmount, 400.0);
    });

    test('Different discounts on different items', () {
      cart.addItem('1', 'Item 1', 100.0, discount: 0.1); // $10 off
      cart.addItem('2', 'Item 2', 100.0, discount: 0.2); // $20 off
      cart.addItem('3', 'Item 3', 100.0, discount: 0.3); // $30 off

      expect(cart.subtotal, 300.0);
      expect(cart.totalDiscount, 60.0);
      expect(cart.totalAmount, 240.0);
    });
  });
}
