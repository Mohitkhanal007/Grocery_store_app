import 'package:flutter/material.dart';
import 'package:grocerystore/features/category/domain/entity/category_entity.dart';

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
        width: 90,
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Logo Container
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                    : Colors.grey[100],
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[300]!,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: isSelected ? 12 : 8,
                    offset: const Offset(0, 4),
                    spreadRadius: isSelected ? 2 : 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _buildCategoryImage(),
              ),
            ),
            const SizedBox(height: 6),
            // Category Name
            Text(
              category.name,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black87,
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
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
      return 'assets/images/barcelonalogo.png';
    } else if (lowerName.contains('manchester') ||
        lowerName.contains('united') ||
        lowerName.contains('man utd')) {
      return 'assets/images/manchesterUnitelogo.png';
    } else if (lowerName.contains('real madrid') ||
        lowerName.contains('madrid')) {
      return 'assets/images/realmadrid logo.png';
    } else if (lowerName.contains('liverpool') || lowerName.contains('lfc')) {
      return 'assets/images/liverpoollogo.png';
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
