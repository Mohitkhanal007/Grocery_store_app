import 'package:dio/dio.dart';
import 'package:grocerystore/app/constant/backend_config.dart';
import 'package:grocerystore/core/network/api_service.dart';
import 'package:grocerystore/features/product/data/model/product_api_model.dart';
import 'package:grocerystore/features/product/domain/entity/product_entity.dart';
import '../product_data_source.dart';

class ProductRemoteDataSource implements IProductDataSource {
  final ApiService _apiService;

  ProductRemoteDataSource({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    try {
      print(
        '🔗 ProductRemoteDataSource: Fetching products from Node.js backend',
      );

      final response = await _apiService.dio.get(
        BackendConfig.productsEndpoint,
      );

      if (BackendConfig.successStatusCodes.contains(response.statusCode)) {
        final responseData = response.data;
        print(
          '📦 ProductRemoteDataSource: Received ${responseData.length} products from backend',
        );

        // Handle different response formats
        List<dynamic> productsData;
        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true && responseData['data'] != null) {
            productsData = responseData['data'] as List<dynamic>;
          } else if (responseData['products'] != null) {
            productsData = responseData['products'] as List<dynamic>;
          } else {
            productsData = [responseData]; // Single product
          }
        } else if (responseData is List) {
          productsData = responseData;
        } else {
          throw Exception("Invalid response format");
        }

        final products = productsData
            .map((json) => ProductApiModel.fromJson(json).toEntity())
            .toList();

        print(
          '✅ ProductRemoteDataSource: Successfully parsed ${products.length} products',
        );
        return products;
      } else {
        throw Exception("Failed to fetch products: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      print('❌ ProductRemoteDataSource: Connection failed - ${e.message}');
      print(
        '❌ ProductRemoteDataSource: Backend must be running to fetch products',
      );
      throw Exception(
        'Backend connection failed. Please ensure the Node.js backend is running on port 5000',
      );
    } catch (e) {
      print('❌ ProductRemoteDataSource: Exception - $e');
      throw Exception('Failed to get products: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByCategory(String categoryId) async {
    try {
      final response = await _apiService.dio.get(
        '${BackendConfig.productsEndpoint}?categoryId=$categoryId',
      );

      if (BackendConfig.successStatusCodes.contains(response.statusCode)) {
        final responseData = response.data;
        List<dynamic> productsData;

        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true && responseData['data'] != null) {
            productsData = responseData['data'] as List<dynamic>;
          } else {
            productsData = [responseData];
          }
        } else if (responseData is List) {
          productsData = responseData;
        } else {
          throw Exception("Invalid response format");
        }

        return productsData
            .map((json) => ProductApiModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          "Failed to fetch products by category: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print(
          'Backend not available, simulating products by category for testing',
        );
        return _getMockProducts()
            .where((product) => product.categoryId == categoryId)
            .toList();
      } else {
        throw Exception('Failed to get products by category: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get products by category: $e');
    }
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      final response = await _apiService.dio.get(
        '${BackendConfig.productsEndpoint}/$id',
      );

      if (BackendConfig.successStatusCodes.contains(response.statusCode)) {
        final responseData = response.data;
        Map<String, dynamic> productData;

        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true && responseData['data'] != null) {
            productData = responseData['data'] as Map<String, dynamic>;
          } else {
            productData = responseData;
          }
        } else {
          throw Exception("Invalid response format");
        }

        return ProductApiModel.fromJson(productData).toEntity();
      } else {
        throw Exception("Failed to fetch product: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Backend not available, simulating product by ID for testing');
        final mockProducts = _getMockProducts();
        final product = mockProducts.firstWhere(
          (product) => product.id == id,
          orElse: () => throw Exception('Product not found'),
        );
        return product;
      } else {
        throw Exception('Failed to get product: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    try {
      // For testing purposes, always use mock data
      print('Using mock products for search testing');
      final mockProducts = _getMockProducts();
      return mockProducts
          .where(
            (product) =>
                product.team.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();

      // Uncomment the following code when you want to use real API
      /*
      final response = await _apiService.dio.get(
        '${BackendConfig.productsEndpoint}/search?q=$query',
      );

      if (BackendConfig.successStatusCodes.contains(response.statusCode)) {
        final responseData = response.data;
        List<dynamic> productsData;

        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true && responseData['data'] != null) {
            productsData = responseData['data'] as List<dynamic>;
          } else {
            productsData = [responseData];
          }
        } else if (responseData is List) {
          productsData = responseData;
        } else {
          throw Exception("Invalid response format");
        }

        return productsData
            .map((json) => ProductApiModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception("Failed to search products: ${response.statusMessage}");
      }
      */
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Backend not available, simulating product search for testing');
        final mockProducts = _getMockProducts();
        return mockProducts
            .where(
              (product) =>
                  product.team.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      } else {
        throw Exception('Failed to search products: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByType(String type) async {
    try {
      // For testing purposes, always use mock data
      print('Using mock products for type filtering testing');
      return _getMockProducts()
          .where((product) => product.type == type)
          .toList();

      // Uncomment the following code when you want to use real API
      /*
      final response = await _apiService.dio.get(
        '${BackendConfig.productsEndpoint}?type=$type',
      );

      if (BackendConfig.successStatusCodes.contains(response.statusCode)) {
        final responseData = response.data;
        List<dynamic> productsData;

        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true && responseData['data'] != null) {
            productsData = responseData['data'] as List<dynamic>;
          } else {
            productsData = [responseData];
          }
        } else if (responseData is List) {
          productsData = responseData;
        } else {
          throw Exception("Invalid response format");
        }

        return productsData
            .map((json) => ProductApiModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          "Failed to fetch products by type: ${response.statusMessage}",
        );
      }
      */
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Backend not available, simulating products by type for testing');
        return _getMockProducts()
            .where((product) => product.type == type)
            .toList();
      } else {
        throw Exception('Failed to get products by type: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get products by type: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsBySize(String size) async {
    try {
      final response = await _apiService.dio.get(
        '${BackendConfig.productsEndpoint}?size=$size',
      );

      if (BackendConfig.successStatusCodes.contains(response.statusCode)) {
        final responseData = response.data;
        List<dynamic> productsData;

        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true && responseData['data'] != null) {
            productsData = responseData['data'] as List<dynamic>;
          } else {
            productsData = [responseData];
          }
        } else if (responseData is List) {
          productsData = responseData;
        } else {
          throw Exception("Invalid response format");
        }

        return productsData
            .map((json) => ProductApiModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          "Failed to fetch products by size: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print('Backend not available, simulating products by size for testing');
        return _getMockProducts()
            .where((product) => product.size == size)
            .toList();
      } else {
        throw Exception('Failed to get products by size: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get products by size: $e');
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByPriceRange(
    double minPrice,
    double maxPrice,
  ) async {
    try {
      final response = await _apiService.dio.get(
        '${BackendConfig.productsEndpoint}?minPrice=$minPrice&maxPrice=$maxPrice',
      );

      if (BackendConfig.successStatusCodes.contains(response.statusCode)) {
        final responseData = response.data;
        List<dynamic> productsData;

        if (responseData is Map<String, dynamic>) {
          if (responseData['success'] == true && responseData['data'] != null) {
            productsData = responseData['data'] as List<dynamic>;
          } else {
            productsData = [responseData];
          }
        } else if (responseData is List) {
          productsData = responseData;
        } else {
          throw Exception("Invalid response format");
        }

        return productsData
            .map((json) => ProductApiModel.fromJson(json).toEntity())
            .toList();
      } else {
        throw Exception(
          "Failed to fetch products by price range: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        print(
          'Backend not available, simulating products by price range for testing',
        );
        return _getMockProducts()
            .where(
              (product) =>
                  product.price >= minPrice && product.price <= maxPrice,
            )
            .toList();
      } else {
        throw Exception('Failed to get products by price range: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get products by price range: $e');
    }
  }

  // Mock data for testing when backend is not available
  List<ProductEntity> _getMockProducts() {
    return [
      // Dairy Products (Category ID: 1)
      ProductEntity(
        id: '1',
        team: 'Fresh Eggs',
        type: 'Dozen',
        size: '12 pieces',
        price: 4.99,
        quantity: 50,
        categoryId: '1',
        productImage:
            'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '2',
        team: 'Organic Milk',
        type: 'Whole',
        size: '1L',
        price: 3.49,
        quantity: 30,
        categoryId: '1',
        productImage:
            'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '3',
        team: 'Greek Yogurt',
        type: 'Plain',
        size: '500g',
        price: 2.99,
        quantity: 25,
        categoryId: '1',
        productImage:
            'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Vegetables (Category ID: 2)
      ProductEntity(
        id: '4',
        team: 'Fresh Potatoes',
        type: 'Russet',
        size: '2kg',
        price: 3.99,
        quantity: 40,
        categoryId: '2',
        productImage:
            'https://images.unsplash.com/photo-1518977676601-b53f82b8fd26?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '5',
        team: 'Organic Spinach',
        type: 'Fresh',
        size: '250g',
        price: 2.49,
        quantity: 35,
        categoryId: '2',
        productImage:
            'https://images.unsplash.com/photo-1576045052395-18053fdc9b3f?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '6',
        team: 'Fresh Tomatoes',
        type: 'Roma',
        size: '1kg',
        price: 2.99,
        quantity: 45,
        categoryId: '2',
        productImage:
            'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '7',
        team: 'Bell Peppers',
        type: 'Mixed Colors',
        size: '500g',
        price: 3.49,
        quantity: 30,
        categoryId: '2',
        productImage:
            'https://images.unsplash.com/photo-1525607551316-5a9e1c8d0c3b?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Fruits (Category ID: 3)
      ProductEntity(
        id: '8',
        team: 'Fresh Apples',
        type: 'Gala',
        size: '1kg',
        price: 4.49,
        quantity: 40,
        categoryId: '3',
        productImage:
            'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '9',
        team: 'Bananas',
        type: 'Organic',
        size: '1kg',
        price: 2.99,
        quantity: 50,
        categoryId: '3',
        productImage:
            'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '10',
        team: 'Fresh Oranges',
        type: 'Navel',
        size: '1kg',
        price: 3.99,
        quantity: 35,
        categoryId: '3',
        productImage:
            'https://images.unsplash.com/photo-1547514701-42782101795e?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Pantry & Snacks (Category ID: 4)
      ProductEntity(
        id: '11',
        team: 'Cooking Oil',
        type: 'Olive',
        size: '500ml',
        price: 5.99,
        quantity: 25,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '12',
        team: 'Instant Noodles',
        type: 'Chicken',
        size: 'Pack of 5',
        price: 3.49,
        quantity: 60,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '13',
        team: 'Tomato Ketchup',
        type: 'Classic',
        size: '500ml',
        price: 2.99,
        quantity: 40,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1626094309830-abbb0c99da4a?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '14',
        team: 'Potato Chips',
        type: 'Classic Salted',
        size: '150g',
        price: 1.99,
        quantity: 70,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Additional Dairy Products
      ProductEntity(
        id: '15',
        team: 'Cheddar Cheese',
        type: 'Sharp',
        size: '200g',
        price: 4.99,
        quantity: 30,
        categoryId: '1',
        productImage:
            'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '16',
        team: 'Butter',
        type: 'Unsalted',
        size: '250g',
        price: 3.99,
        quantity: 25,
        categoryId: '1',
        productImage:
            'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '17',
        team: 'Sour Cream',
        type: 'Regular',
        size: '300g',
        price: 2.49,
        quantity: 20,
        categoryId: '1',
        productImage:
            'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Additional Vegetables
      ProductEntity(
        id: '18',
        team: 'Fresh Carrots',
        type: 'Organic',
        size: '1kg',
        price: 2.99,
        quantity: 40,
        categoryId: '2',
        productImage:
            'https://images.unsplash.com/photo-1518977676601-b53f82b8fd26?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '19',
        team: 'Onions',
        type: 'Yellow',
        size: '1kg',
        price: 1.99,
        quantity: 60,
        categoryId: '2',
        productImage:
            'https://images.unsplash.com/photo-1518977676601-b53f82b8fd26?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '20',
        team: 'Cucumber',
        type: 'English',
        size: '500g',
        price: 1.49,
        quantity: 35,
        categoryId: '2',
        productImage:
            'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '21',
        team: 'Broccoli',
        type: 'Fresh',
        size: '400g',
        price: 3.49,
        quantity: 25,
        categoryId: '2',
        productImage:
            'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Additional Fruits
      ProductEntity(
        id: '22',
        team: 'Strawberries',
        type: 'Fresh',
        size: '250g',
        price: 4.99,
        quantity: 30,
        categoryId: '3',
        productImage:
            'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '23',
        team: 'Grapes',
        type: 'Red Seedless',
        size: '500g',
        price: 5.99,
        quantity: 25,
        categoryId: '3',
        productImage:
            'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '24',
        team: 'Pineapple',
        type: 'Fresh',
        size: '1 piece',
        price: 3.99,
        quantity: 15,
        categoryId: '3',
        productImage:
            'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '25',
        team: 'Mangoes',
        type: 'Alphonso',
        size: '1kg',
        price: 6.99,
        quantity: 20,
        categoryId: '3',
        productImage:
            'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Additional Pantry & Snacks
      ProductEntity(
        id: '26',
        team: 'White Rice',
        type: 'Long Grain',
        size: '2kg',
        price: 4.99,
        quantity: 50,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '27',
        team: 'Pasta',
        type: 'Spaghetti',
        size: '500g',
        price: 2.49,
        quantity: 40,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1551892374-ecf8754cf8b0?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '28',
        team: 'Bread',
        type: 'Whole Wheat',
        size: '400g',
        price: 2.99,
        quantity: 30,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '29',
        team: 'Honey',
        type: 'Pure',
        size: '250ml',
        price: 4.49,
        quantity: 20,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductEntity(
        id: '30',
        team: 'Peanut Butter',
        type: 'Smooth',
        size: '400g',
        price: 3.99,
        quantity: 25,
        categoryId: '4',
        productImage:
            'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=400&h=400&fit=crop',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}
