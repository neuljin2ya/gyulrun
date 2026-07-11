import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  static const Color _backgroundColor = Color(0xFFBAFF29);
  static const Color _foregroundColor = Color(0xFF252525);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 69,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          disabledBackgroundColor: _backgroundColor.withValues(alpha: 0.5),
          disabledForegroundColor: _foregroundColor.withValues(alpha: 0.5),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: 26,
                child: CircularProgressIndicator(
                  color: _foregroundColor,
                  strokeWidth: 2.5,
                ),
              )
            : Text(label),
      ),
    );
  }
}
