import 'package:flutter/material.dart';

class MemoryThumbnailCard extends StatelessWidget {
  const MemoryThumbnailCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.image,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final ImageProvider? image;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF353535),
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 96,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (image != null)
                Image(
                  image: image!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _PlaceImagePlaceholder(),
                )
              else
                const _PlaceImagePlaceholder(),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xCC000000), Color(0x10000000)],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 20,
                right: 16,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 18,
                right: 16,
                child: Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceImagePlaceholder extends StatelessWidget {
  const _PlaceImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xFF474747),
      child: Icon(Icons.landscape_outlined, color: Colors.white54, size: 34),
    );
  }
}
