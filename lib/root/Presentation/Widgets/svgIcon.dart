import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

svgIcon({
  double iconSize = 23,
  Color color = Colors.black,
  String path = "Assets/icons/edit_square.svg",
}) {
  return SizedBox(
    height: iconSize,
    width: iconSize,
    child: SvgPicture.asset(
      path,
      color: color,
      height: iconSize, // Explicitly set the size
      width: iconSize,
      fit: BoxFit.contain, // Ensures it fits within the SizedBox
    ),
  );
}