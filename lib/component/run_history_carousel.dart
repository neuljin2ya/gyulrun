import 'package:flutter/material.dart';
import 'package:gyulrun/component/activity_photo_card.dart';
import 'package:gyulrun/model/run_history_entry.dart';

class RunHistoryCarousel extends StatefulWidget {
  const RunHistoryCarousel({
    super.key,
    required this.entries,
    required this.onPageChanged,
  });

  final List<RunHistoryEntry> entries;
  final ValueChanged<int> onPageChanged;

  @override
  State<RunHistoryCarousel> createState() => _RunHistoryCarouselState();
}

class _RunHistoryCarouselState extends State<RunHistoryCarousel> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth * 0.88;
        final cardHeight = cardWidth * 1.34;

        return Column(
          children: [
            SizedBox(
              height: cardHeight,
              child: PageView.builder(
                clipBehavior: Clip.none,
                controller: _controller,
                itemCount: widget.entries.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  widget.onPageChanged(index);
                },
                itemBuilder: (context, index) {
                  final entry = widget.entries[index];
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      var scale = 1.0;
                      var opacity = 1.0;
                      var translateY = 0.0;
                      if (_controller.hasClients &&
                          _controller.position.haveDimensions) {
                        final page =
                            _controller.page ?? _currentPage.toDouble();
                        final distance = (page - index).abs();
                        scale = (1 - distance * 0.08).clamp(0.9, 1.0);
                        opacity = (1 - distance * 0.22).clamp(0.72, 1.0);
                        translateY = distance * 14;
                      }
                      return Opacity(
                        opacity: opacity,
                        child: Transform.translate(
                          offset: Offset(0, translateY),
                          child: Transform.scale(scale: scale, child: child),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: ActivityPhotoCard(
                        title: entry.result.courseName,
                        distanceKm: entry.result.distanceKm,
                        rating: entry.rating.toDouble(),
                        image: MemoryImage(entry.photoBytes),
                        width: cardWidth,
                        height: cardHeight,
                        titleTop: 34,
                        distanceBottom: 108,
                        ratingBottom: 34,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (widget.entries.length > 1) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < widget.entries.length; index++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: index == _currentPage ? 18 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: index == _currentPage
                            ? const Color(0xFF9DFF00)
                            : const Color(0xFFD6D6D6),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
