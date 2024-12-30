import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buttonRow({
  required BuildContext context, 
  required final onResetPressed, 
  required final onPlayPressed, 
  required final onTuningPressed, 
  required bool isPlaying,
  required bool isEnabled,
  }) {
  ThemeData themeContext = Theme.of(context);
  Size mediaSize = MediaQuery.sizeOf(context);

  return Padding(
  padding: const EdgeInsets.only(top: 10.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      SizedBox(width: mediaSize.width * 0.02), // 2% of screen width
      // Reset Button
      Flexible(
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor:themeContext.colorScheme.surfaceContainerHigh,
          ),
          iconSize: mediaSize.width * 0.07, // 6% of screen width
          onPressed: onResetPressed,
          icon: Icon(Icons.refresh, color: themeContext.colorScheme.primary,),
        ),
      ),
      SizedBox(width: mediaSize.width * 0.02), // 2% of screen width

      // PLAY Button
      Flexible(
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor:themeContext.colorScheme.surfaceContainerHigh,
          ),
          iconSize: mediaSize.width * 0.1, // 8% of screen width
          onPressed: onPlayPressed,
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: themeContext.colorScheme.primary,),
        ),
      ),
      SizedBox(width: mediaSize.width * 0.02), // 2% of screen width

      // Tuning Button
      Flexible(
        child: IconButton(
          style: IconButton.styleFrom(
            backgroundColor:themeContext.colorScheme.surfaceContainerHigh,
          ),
          onPressed: onTuningPressed,
          icon: SvgPicture.asset(
            "Assets/icons/tune1.svg",
            color: themeContext.colorScheme.primary,
            height: mediaSize.height * 0.017, // 2% of screen height
          ),
        ),
      ),
      SizedBox(width: mediaSize.width * 0.02), // 2% of screen width
    ],
  ),
);

}