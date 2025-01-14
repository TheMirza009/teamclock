import 'package:flutter/material.dart';
import 'package:time_slider/core/theme/theme_constants.dart';

floatingAdd(BuildContext context, void Function()? onPressed, Widget icon) {
  return Container(
        width: 70.0, // Diameter of the button
        height: 70.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Shadow color with some transparency
              offset: const Offset(-2, 4), // The offset of the shadow
              blurRadius: 6, // The blur effect of the shadow
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          // color: const Color.fromARGB(255, 55, 101, 187), // Icon color
          color: ThemeConstants.neutralblue,
        ),
      );
}