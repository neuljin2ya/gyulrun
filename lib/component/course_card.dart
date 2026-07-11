import 'package:flutter/material.dart';

enum CourseDifficulty {
  easy('EASY'),
  normal('NORMAL'),
  hard('HARD');

  const CourseDifficulty(this.label);

  final String label;
}

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.difficulty,
    this.title = '귤런',
    this.distanceKm = 3,
    this.address = '위치주소',
    this.initiallyFavorite = false,
    this.onFavoriteChanged,
    this.onTap,
  });

  final CourseDifficulty difficulty;
  final String title;
  final double distanceKm;
  final String address;
  final bool initiallyFavorite;
  final ValueChanged<bool>? onFavoriteChanged;
  final VoidCallback? onTap;

  static const Color _accentColor = Color(0xFFA8FF18);
  static const Color _textColor = Color(0xFF252525);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: '$title, ${difficulty.label}, ${distanceKm.toStringAsFixed(2)} Km',
      child: Material(
        color: const Color(0x80E7FFF8),
        borderRadius: BorderRadius.circular(10),
        elevation: 4,
        shadowColor: Colors.black38,
        child: InkWell(
          key: ValueKey('course_card_$title'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 329,
            height: 176,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _FavoriteButton(
                        initiallyFavorite: initiallyFavorite,
                        onChanged: onFavoriteChanged,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        difficulty.label,
                        style: const TextStyle(
                          color: _textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6, bottom: 5),
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      _DistanceLabel(distanceKm: distanceKm),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xA6252525),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({
    required this.initiallyFavorite,
    required this.onChanged,
  });

  final bool initiallyFavorite;
  final ValueChanged<bool>? onChanged;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initiallyFavorite;
  }

  @override
  void didUpdateWidget(covariant _FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyFavorite != widget.initiallyFavorite) {
      _isFavorite = widget.initiallyFavorite;
    }
  }

  void _toggle() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onChanged?.call(_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _isFavorite ? '즐겨찾기 해제' : '즐겨찾기 추가',
      child: Material(
        color: CourseCard._accentColor,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: _toggle,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: 38,
            child: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: CourseCard._textColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

class _DistanceLabel extends StatelessWidget {
  const _DistanceLabel({required this.distanceKm});

  final double distanceKm;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${distanceKm.toStringAsFixed(2)} Km',
            maxLines: 1,
            style: const TextStyle(
              color: CourseCard._textColor,
              fontSize: 34,
              height: 1,
              fontWeight: FontWeight.w700,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 7),
          Transform.rotate(
            angle: -0.04,
            child: Container(
              width: 156,
              height: 6,
              decoration: BoxDecoration(
                color: CourseCard._accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
