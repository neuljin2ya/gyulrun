import 'package:flutter/material.dart';

class ActivityPhotoCard extends StatelessWidget {
  const ActivityPhotoCard({
    super.key,
    required this.title,
    required this.distanceKm,
    this.rating,
    this.image,
    this.onCapture,
    this.onTap,
    this.emptyMessage = '완주 사진이 표시됩니다',
    this.width = 329,
    this.height = 440,
    this.titleTop = 34,
    this.titleFontSize = 64,
    this.distanceBottom = 120,
    this.ratingBottom = 34,
  });

  final String title;
  final double distanceKm;
  final double? rating;
  final ImageProvider? image;
  final VoidCallback? onCapture;
  final VoidCallback? onTap;
  final String emptyMessage;
  final double width;
  final double height;
  final double titleTop;
  final double titleFontSize;
  final double distanceBottom;
  final double ratingBottom;

  static const Color _distanceColor = Color(0xFFFFE358);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null || (image == null && onCapture != null),
      label: '$title 활동 사진, ${distanceKm.toStringAsFixed(2)} 킬로미터',
      child: Material(
        color: const Color(0xFF353535),
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: image == null ? onCapture : onTap,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (image != null)
                  Image(
                    image: image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        _PhotoPlaceholder(message: emptyMessage),
                  )
                else
                  _PhotoPlaceholder(message: emptyMessage),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x66000000),
                        Colors.transparent,
                        Color(0x73000000),
                      ],
                      stops: [0, 0.48, 1],
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  right: 20,
                  top: titleTop,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xFFF8F8F8),
                      fontSize: titleFontSize,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -3,
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  right: 20,
                  bottom: distanceBottom,
                  child: Text(
                    '${_formatDistance(distanceKm)} KM',
                    maxLines: 1,
                    style: const TextStyle(
                      color: _distanceColor,
                      fontSize: 58,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -2,
                    ),
                  ),
                ),
                if (rating != null)
                  Positioned(
                    left: 30,
                    bottom: ratingBottom,
                    child: _RatingBadge(rating: rating!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatDistance(double value) {
    return value.toStringAsFixed(2);
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF4A4A4A),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image_outlined, color: Colors.white, size: 48),
            const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_border_rounded,
            color: ActivityPhotoCard._distanceColor,
            size: 32,
          ),
          const SizedBox(width: 7),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Color(0xFF252525),
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
