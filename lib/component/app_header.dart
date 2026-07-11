import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key, required this.title, this.onMenuTap});

  final String title;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: IconButton(
              onPressed: onMenuTap,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              tooltip: '메뉴',
              icon: const Icon(Icons.menu_rounded, size: 22),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF252525),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
