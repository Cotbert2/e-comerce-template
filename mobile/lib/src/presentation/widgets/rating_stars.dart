import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 20.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        double fillAmount = rating - index;
        
        if (fillAmount >= 1.0) {
          // Full star
          return Icon(
            Icons.star,
            size: size,
            color: activeColor,
          );
        } else if (fillAmount > 0.0) {
          // Partial star
          return Stack(
            children: [
              Icon(
                Icons.star_border,
                size: size,
                color: inactiveColor,
              ),
              ClipRect(
                clipper: _StarClipper(fillAmount),
                child: Icon(
                  Icons.star,
                  size: size,
                  color: activeColor,
                ),
              ),
            ],
          );
        } else {
          // Empty star
          return Icon(
            Icons.star_border,
            size: size,
            color: inactiveColor,
          );
        }
      }),
    );
  }
}

class _StarClipper extends CustomClipper<Rect> {
  final double fillAmount;

  _StarClipper(this.fillAmount);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, size.width * fillAmount, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}