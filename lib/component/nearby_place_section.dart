import 'package:flutter/material.dart';
import 'package:gyulrun/component/memory_thumbnail_card.dart';
import 'package:gyulrun/model/nearby_place_info.dart';

class NearbyPlaceSection extends StatelessWidget {
  const NearbyPlaceSection({
    super.key,
    required this.places,
    required this.onPlaceTap,
  });

  final List<NearbyPlaceInfo> places;
  final ValueChanged<NearbyPlaceInfo> onPlaceTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: Column(
        key: ValueKey(places.map((place) => place.name).join(',')),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '주변',
            style: TextStyle(
              color: Color(0xFF252525),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < places.length; index++) ...[
            MemoryThumbnailCard(
              title: places[index].name,
              subtitle: places[index].address,
              image: places[index].imageUrl == null
                  ? null
                  : NetworkImage(places[index].imageUrl!),
              onTap: () => onPlaceTap(places[index]),
            ),
            if (index < places.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
