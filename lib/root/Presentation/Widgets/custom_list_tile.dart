import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teamclock/core/theme/theme_constants.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function(TapDownDetails)? onTapDown; // Accepts TapDownDetails
  final VoidCallback? onTap;
  final bool showChevron;
  final bool showDivider;
  final Widget? trailingWidget;
  final bool noTitle;

  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTapDown,
    this.onTap,
    this.trailingWidget,
    this.showChevron = true,
    this.showDivider = true,
    this.noTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    double titleSize = 14;
    double subtitleSize = 10;
    final montserratBold = GoogleFonts.montserrat(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: titleSize,
    );

    return GestureDetector(
      onTapDown: onTapDown, // Capture tap position
      child: Column(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: montserratBold),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: AnimatedOpacity(
                        opacity: noTitle || subtitle.isNotEmpty ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          subtitle,
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          style: GoogleFonts.montserrat(
                            fontSize: subtitleSize,
                            fontWeight: FontWeight.w500,
                            color: noTitle == true
                                ? const Color.fromARGB(166, 201, 54, 44)
                                : Theme.of(context).colorScheme.primary.withAlpha(100),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    showChevron
                        ? const Icon(CupertinoIcons.right_chevron)
                        : (trailingWidget != null
                            ? trailingWidget!
                            : const SizedBox.shrink()),
                  ],
                ),
              ],
            ),
            onTap: onTap,
          ),
          showDivider ? ThemeConstants.greyDivider : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
