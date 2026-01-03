import 'package:flutter/material.dart';


Widget _buildOptionCard(BuildContext context, String title, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap, //
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        width: 200,
        height: 180,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF009688) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: isSelected ? null : Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}