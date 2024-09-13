import 'package:flutter/material.dart';

class SelectorButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelect;

  const SelectorButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: OutlinedButton(
        onPressed: onSelect,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
