import 'package:flutter/material.dart';
import 'package:jerseyhub/features/category/domain/entity/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onTap;
  final bool isSelected;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
        ),
        child: Column(
          children: [
            // Category Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: _buildCategoryImage(),
                ),
              ),
            ),
            // Category Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (category.description != null)
                      Flexible(
                        child: Text(
                          category.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white70
                                : Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryImage() {
    // First try to get club logo based on category name
    String? clubLogoPath = _getClubLogoPath(category.name);

    if (clubLogoPath != null) {
      return Image.asset(
        clubLogoPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
      );
    }

    // Fallback to original imageUrl logic
    if (category.imageUrl != null && category.imageUrl!.isNotEmpty) {
      if (category.imageUrl!.startsWith('assets/')) {
        return Image.asset(
          category.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        );
      } else {
        return Image.network(
          category.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderImage(),
        );
      }
    } else {
      return _buildPlaceholderImage();
    }
  }

  String? _getClubLogoPath(String categoryName) {
    String lowerName = categoryName.toLowerCase();

    if (lowerName.contains('barcelona') || lowerName.contains('fcb')) {
      return 'assets/images/Barcelona.png';
    } else if (lowerName.contains('manchester') ||
        lowerName.contains('united') ||
        lowerName.contains('man utd')) {
      return 'assets/images/Manchester United.png';
    } else if (lowerName.contains('real madrid') ||
        lowerName.contains('madrid')) {
      return 'assets/images/Real Madrid.png';
    } else if (lowerName.contains('liverpool') || lowerName.contains('lfc')) {
      return 'assets/images/Liverpool.png';
    }

    return null;
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.category, size: 48, color: Colors.grey),
      ),
    );
  }
}
