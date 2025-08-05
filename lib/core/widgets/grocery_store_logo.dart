import 'package:flutter/material.dart';

class GroceryStoreLogo extends StatelessWidget {
  final double size;
  final Color? textColor;
  final Color? iconColor;

  const GroceryStoreLogo({
    super.key,
    this.size = 200,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: size * 0.6,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: Row(
        children: [
          // Left side - Shopping basket icon
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(size * 0.08),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Shopping basket icon
                  Icon(
                    Icons.shopping_basket,
                    size: size * 0.25,
                    color: iconColor ?? Colors.white,
                  ),
                  // Small grocery items inside basket
                  Positioned(
                    bottom: size * 0.05,
                    left: size * 0.08,
                    child: Container(
                      width: size * 0.08,
                      height: size * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: size * 0.05,
                    right: size * 0.08,
                    child: Container(
                      width: size * 0.06,
                      height: size * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Vertical separator
          Container(
            width: 1,
            height: size * 0.35,
            color: (textColor ?? Colors.white).withOpacity(0.5),
          ),

          // Right side - Text
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(size * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GROCERY',
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: (size * 0.08).clamp(16.0, 20.0),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: size * 0.015),
                  Text(
                    'STORE',
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: (size * 0.08).clamp(16.0, 20.0),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
