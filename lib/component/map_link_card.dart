import 'package:flutter/material.dart';

class MapLinkCard extends StatelessWidget {
  const MapLinkCard({super.key, required this.address, required this.onTap});

  final String address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '주소',
          style: TextStyle(
            color: Color(0xFF252525),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          address,
          style: const TextStyle(
            color: Color(0xFF252525),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 26),
        Material(
          color: const Color(0xFFF2FFFB),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 17),
              child: Row(
                children: [
                  Icon(Icons.map_outlined, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '누르면 네이버 지도 연결',
                      style: TextStyle(
                        color: Color(0xFF252525),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
