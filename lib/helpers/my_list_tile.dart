import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String baseUrl;
  final String imageUrl;
  final bool selected;
  final VoidCallback? onTap;

  const MyListTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.baseUrl,
    required this.imageUrl,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap != null ? () => onTap!() : null,
      child: Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selected
                ? colorScheme.primary.withOpacity(0.8)
                : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.0),
                  child: Container(
                    width: 100.0,
                    height: 80.0,
                    child: Image.network(baseUrl + imageUrl),
                  ),
                ),
                SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: textTheme.bodyLarge),
                    SizedBox(height: 4.0),
                    Text(subtitle),
                  ],
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: 8.0,
                right: 8.0,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16.0),
                ),
              )
          ],
        ),
      ),
    );
  }
}
