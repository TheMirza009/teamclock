import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget buildDrawerIconButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: SvgPicture.asset(
              "Assets/icons/Menubars.svg",
              color: Theme.of(context).colorScheme.primary,
              height: 10,
            ),
          ),
        );
      },
    );
  }