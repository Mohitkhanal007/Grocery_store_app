import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jerseyhub/app/service_locator/service_locator.dart';
import 'package:jerseyhub/features/category/domain/entity/category_entity.dart';
import 'package:jerseyhub/features/category/presentation/view/category_list_view.dart';
import 'package:jerseyhub/features/category/presentation/viewmodel/category_viewmodel.dart';
import 'package:jerseyhub/features/product/domain/entity/product_entity.dart';
import 'package:jerseyhub/features/product/presentation/view/product_detail_view.dart';
import 'package:jerseyhub/features/product/presentation/viewmodel/product_viewmodel.dart';
import 'package:jerseyhub/features/product/presentation/widgets/product_card.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final TextEditingController _searchController = TextEditingController();
  CategoryEntity? _selectedCategory;

  @override
  void initState() {
    super.initState();
    print('ProductListView: initState called');
    context.read<ProductViewModel>().add(LoadAllProductsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<ProductViewModel>().add(SearchProductsEvent(query: query));
    } else {
      context.read<ProductViewModel>().add(LoadAllProductsEvent());
    }
  }

  void _onCategorySelected(CategoryEntity category) {
    setState(() {
      _selectedCategory = category;
    });
    // TODO: Implement category filtering
    print('Selected category: ${category.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jersey Hub'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search jerseys...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: _onSearch,
            ),
          ),
          // Categories
          SizedBox(
            height: 120,
            child: BlocProvider(
              create: (context) => serviceLocator<CategoryViewModel>(),
              child: CategoryListView(
                selectedCategoryId: _selectedCategory?.id,
                onCategorySelected: _onCategorySelected,
              ),
            ),
          ),
          // Products Grid
          Expanded(
            child: BlocBuilder<ProductViewModel, ProductState>(
              builder: (context, state) {
                print('ProductListView: Current state: ${state.runtimeType}');
                if (state is ProductLoading) {
                  print('ProductListView: Showing loading indicator');
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductsLoaded) {
                  print(
                    'ProductListView: Products loaded: ${state.products.length}',
                  );
                  if (state.products.isEmpty) {
                    print('ProductListView: No products found');
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return _buildProductsGrid(state.products);
                } else if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductViewModel>().add(
                              LoadAllProductsEvent(),
                            );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: Text('No products available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<ProductEntity> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () {
            // Navigate to product detail page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => serviceLocator<ProductViewModel>(),
                  child: ProductDetailView(productId: product.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
