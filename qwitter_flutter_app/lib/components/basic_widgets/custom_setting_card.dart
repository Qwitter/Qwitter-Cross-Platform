import 'package:flutter/material.dart';

class CustomSettingCard extends StatelessWidget {
  const CustomSettingCard({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
  final IconData? icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: Colors.grey[500],
                  )
                : const SizedBox(
                    width: 0,
                    height: 0,
                  ),
            const SizedBox(
              width: 30,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
