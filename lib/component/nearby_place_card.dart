import 'package:flutter/material.dart';

enum PlaceCategory {
  cafe('카페', Icons.local_cafe_rounded),
  restaurant('음식점', Icons.restaurant_rounded),
  attraction('관광지', Icons.landscape_rounded);

  const PlaceCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

class NearbyPlaceCard extends StatelessWidget {
  const NearbyPlaceCard({
    super.key,
    required this.name,
    required this.category,
    required this.address,
    this.image,
    this.distanceMeters,
    this.rating,
    this.onTap,
  });

  final String name;
  final PlaceCategory category;
  final String address;
  final ImageProvider? image;
  final int? distanceMeters;
  final double? rating;
  final VoidCallback? onTap;

  static const Color _accentColor = Color(0xFFBAFF29);
  static const Color _textColor = Color(0xFF252525);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: '${category.label} $name, $address',
      child: Material(
        color: const Color(0xFFF5FFF9),
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 329,
            height: 126,
            child: Row(
              children: [
                _PlaceImage(image: image, category: category),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 13, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _CategoryBadge(category: category),
                            const Spacer(),
                            if (rating != null) _Rating(rating: rating!),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Color(0xA6252525),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xA6252525),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (distanceMeters != null) ...[
                              const SizedBox(width: 7),
                              Text(
                                _formatDistance(distanceMeters!),
                                style: const TextStyle(
                                  color: _textColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatDistance(int meters) {
    if (meters < 1000) return '${meters}m';
    return '${(meters / 1000).toStringAsFixed(1)}km';
  }
}

class _PlaceImage extends StatelessWidget {
  const _PlaceImage({required this.image, required this.category});

  final ImageProvider? image;
  final PlaceCategory category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 112,
      height: double.infinity,
      child: image == null
          ? ColoredBox(
              color: const Color(0xFFE3E9E5),
              child: Icon(
                category.icon,
                size: 38,
                color: const Color(0xFF69726C),
              ),
            )
          : Image(
              image: image!,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFE3E9E5),
                child: Icon(Icons.image_not_supported_outlined),
              ),
            ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});

  final PlaceCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: NearbyPlaceCard._accentColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14, color: NearbyPlaceCard._textColor),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: const TextStyle(
              color: NearbyPlaceCard._textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Rating extends StatelessWidget {
  const _Rating({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star_rounded, size: 17, color: Color(0xFFFFD447)),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: NearbyPlaceCard._textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
