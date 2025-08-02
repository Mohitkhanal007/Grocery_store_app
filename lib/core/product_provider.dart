import 'package:flutter/foundation.dart';
import '../model/product.dart';
import 'api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await ApiService.getProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load products by category
  Future<void> loadProductsByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await ApiService.getProductsByCategory(category);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load expiring products
  Future<void> loadExpiringProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await ApiService.getExpiringProducts();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new product
  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final newProduct = await ApiService.createProduct(productData);
      _products.add(newProduct);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update a product
  Future<void> updateProduct(
    String id,
    Map<String, dynamic> productData,
  ) async {
    try {
      final updatedProduct = await ApiService.updateProduct(id, productData);
      final index = _products.indexWhere((product) => product.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Update stock quantity
  Future<void> updateStock(String id, int stockQuantity) async {
    try {
      final updatedProduct = await ApiService.updateStock(id, stockQuantity);
      final index = _products.indexWhere((product) => product.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    try {
      await ApiService.deleteProduct(id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get products by category (from loaded products)
  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  // Get available products only
  List<Product> getAvailableProducts() {
    return _products.where((product) => product.isAvailable).toList();
  }

  // Get organic products only
  List<Product> getOrganicProducts() {
    return _products.where((product) => product.isOrganic).toList();
  }

  // Search products
  List<Product> searchProducts(String query) {
    return _products
        .where(
          (product) =>
              product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.description.toLowerCase().contains(query.toLowerCase()) ||
              product.brand.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
