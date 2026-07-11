import 'package:flutter/material.dart';

/// 귤런의 주요 화면과 러닝 시작 액션을 연결하는 하단 내비게이션 바입니다.
class RunningBottomNavigationBar extends StatelessWidget {
  const RunningBottomNavigationBar({
    super.key,
    this.onHomeTap,
    this.onRunTap,
    this.onStatsTap,
  });

  final VoidCallback? onHomeTap;
  final VoidCallback? onRunTap;
  final VoidCallback? onStatsTap;

  static const double height = 80;
  static const Color _accentColor = Color(0xFFA8FF18);
  static const Color _surfaceColor = Color(0xBF2B2B2B);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: _NavigationButton(
                  semanticLabel: '홈',
                  onTap: onHomeTap,
                  icon: const Icon(
                    Icons.person_rounded,
                    size: 27,
                    color: Color(0xFF171717),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: _NavigationButton(
                  semanticLabel: '러닝 기록',
                  onTap: onStatsTap,
                  icon: const _StatsIcon(),
                ),
              ),
            ],
          ),
          Semantics(
            button: true,
            label: '러닝 시작',
            child: Material(
              color: _accentColor,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRunTap,
                child: const SizedBox.square(
                  dimension: 68,
                  child: Center(child: _PlayIcon()),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.semanticLabel,
    required this.icon,
    this.onTap,
  });

  final String semanticLabel;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(
          side: BorderSide(
            color: RunningBottomNavigationBar._accentColor,
            width: 2,
          ),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(dimension: 52, child: Center(child: icon)),
        ),
      ),
    );
  }
}

class _PlayIcon extends StatelessWidget {
  const _PlayIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(29, 29), painter: _PlayIconPainter());
  }
}

class _PlayIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width * 0.2, size.height)
      ..close();

    canvas.drawPath(path, Paint()..color = const Color(0xFF171717));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatsIcon extends StatelessWidget {
  const _StatsIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27,
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.bar_chart_rounded, size: 18, color: Colors.white),
    );
  }
}
