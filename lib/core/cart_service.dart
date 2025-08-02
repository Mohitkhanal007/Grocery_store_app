import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class CartService {
  // Get user's cart
  static Future<List<Map<String, dynamic>>> getCart(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }

  // Add item to cart
  static Future<Map<String, dynamic>> addToCart(
    String token,
    String productId,
    int quantity,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'productId': productId, 'quantity': quantity}),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to add item to cart');
      }
    } catch (e) {
      throw Exception('Failed to add item to cart: $e');
    }
  }

  // Update cart item quantity
  static Future<Map<String, dynamic>> updateCartItem(
    String token,
    String cartItemId,
    int quantity,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/cart/$cartItemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update cart item');
      }
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  // Remove item from cart
  static Future<void> removeFromCart(String token, String cartItemId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/cart/$cartItemId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(
          errorData['message'] ?? 'Failed to remove item from cart',
        );
      }
    } catch (e) {
      throw Exception('Failed to remove item from cart: $e');
    }
  }

  // Clear cart
  static Future<void> clearCart(String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to clear cart');
      }
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  // Get cart total
  static Future<double> getCartTotal(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/cart/total'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['total'].toDouble();
      } else {
        throw Exception('Failed to get cart total: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to get cart total: $e');
    }
  }
}
