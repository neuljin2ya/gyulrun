import 'package:flutter/material.dart';

class StarRatingInput extends StatelessWidget {
  const StarRatingInput({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '별점 $value점',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var index = 1; index <= 5; index++)
            IconButton(
              onPressed: () => onChanged(index),
              tooltip: '$index점',
              iconSize: 38,
              color: const Color(0xFFFFD447),
              icon: Icon(
                index <= value ? Icons.star_rounded : Icons.star_border_rounded,
              ),
            ),
        ],
      ),
    );
  }
}
