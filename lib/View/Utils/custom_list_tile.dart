import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final bool showChevron;
  final bool showDivider;
  final Widget? trailingWidget;
  const CustomListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailingWidget,
    this.showChevron = true,
    this.showDivider = true,
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

    return Column(
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
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      style: GoogleFonts.montserrat(
                        fontSize: subtitleSize, 
                        fontWeight: FontWeight.w500,
                        
                        ),
                      overflow: TextOverflow.ellipsis,
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
        showDivider 
        ? ThemeConstants.greyDivider
        : const SizedBox.shrink(), // Assuming this is `greyDivider`
      ],
    );
  }
}
