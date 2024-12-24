import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConstants {
  static double screenWidth = 1;
  static double screenHeight = 1;

  // Function to calculate dynamic font size
  static double getDynamicFontSize(double size) {
    return size * (screenWidth / 375); // 375 is a common base screen width (like an iPhone 8)
  }

  static const greyDivider = Divider(color: ThemeConstants.dividerGrey);
  static TextStyle robotoMono = GoogleFonts.robotoMono(fontSize: 70);


  // Pomodoro declarations

    static pageTitle(BuildContext context, String text) => Text(text,
      style: GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.primary ,
        fontSize: ThemeConstants.getDynamicFontSize(18),
        fontWeight: FontWeight.w400,
      ));

    static TextStyle boldText(context) => GoogleFonts.montserrat(
      fontSize: ThemeConstants.getDynamicFontSize(17),
      color: Theme.of(context).colorScheme.onSecondary,
      fontWeight: FontWeight.bold,
    );

    static TextStyle notBoldText(context) => GoogleFonts.montserrat(
      fontSize: ThemeConstants.getDynamicFontSize(15),
      color: Theme.of(context).colorScheme.onSecondary,
      fontWeight: FontWeight.bold,
    );

    static TextStyle montserratBold(BuildContext context) =>
      GoogleFonts.montserrat(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
      );

  // Dark theme colors
  static const darkBG = Color.fromARGB(255, 35, 35, 41);
  static const darkContainer = Color.fromARGB(255, 35, 35, 41);
  static const darkBorder = Color.fromARGB(255, 97, 98, 110);
  static const darkSubtitle = Colors.grey;
  static const darkTitle = Color.fromARGB(255, 220, 230, 236);
  static const darkSeedColor = Color.fromARGB(255, 51, 56, 71);
  static const darkerror = Color.fromARGB(255, 177, 61, 61);

  // Light theme colors
  static const lightBG = Colors.white;
  static const lightContainer = Colors.grey;
  static const lightBorder = Color.fromARGB(255, 200, 200, 200);
  static const lightSubtitle = Colors.black54;
  static const lightTitle = Colors.black;
  static const lightSeedColor = Color.fromARGB(255, 51, 56, 71);
  static const lightshader = Color.fromARGB(255, 165, 181, 181);
  static const lightError = Color.fromARGB(255, 237, 28, 36);

  // Neutral Color Themes
  static const neutralblue =  Color(0xFF5865F2);
  static const neutraldeepblue =  Color.fromARGB(255, 55, 101, 187);
  static const neutralgrey = Color.fromARGB(64, 153, 163, 168);
  static const neutralgreen = Color(0xFF2E8F87);
  static const neutralred =  Color.fromARGB(255, 252, 87, 87);
  static const dividerGrey =  Color.fromARGB(69, 108, 119, 151);

  // Dark theme
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: darkTitle,
          secondary: darkBorder,
          surfaceContainer: darkContainer,
          outline: darkBorder,
          surface: Color.fromARGB(255, 18, 18, 22),
          surfaceTint: darkBG,
          surfaceBright:  Color.fromARGB(255, 56, 56, 63),
          onPrimary: darkBG,
          onSecondary: darkSubtitle,
          onSurface: darkSubtitle,
          error: Color.fromARGB(255, 177, 61, 61), // Add an error color if needed
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.montserrat(fontSize: getDynamicFontSize(104), color: darkTitle,),
          titleMedium: GoogleFonts.montserrat(fontSize: getDynamicFontSize(70), color: darkTitle,),
          bodySmall: GoogleFonts.montserrat(fontSize: getDynamicFontSize(14), color: darkSubtitle,),
          labelSmall:GoogleFonts.montserrat(fontSize: getDynamicFontSize(12), color: darkTitle,) ,
          displaySmall:GoogleFonts.montserrat(fontSize: getDynamicFontSize(13), color: const Color.fromARGB(36, 220, 230, 236),) ,
          bodyMedium: GoogleFonts.montserrat(fontSize: getDynamicFontSize(13), color: darkTitle,),
          headlineMedium: GoogleFonts.montserrat(fontSize: getDynamicFontSize(17), color: darkTitle, fontWeight: FontWeight.bold),
          displayMedium: GoogleFonts.montserrat(fontSize: getDynamicFontSize(18), color: darkTitle,),
        ),

        // FLOATING ACTION BUTTON STYLING
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber
        ),

        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(darkTitle.withOpacity(0.2)), // 20% transparency of the primary color
        ),

        // ANDROID TIME PICKER THEME
        timePickerTheme: const TimePickerThemeData(
          // backgroundColor: Colors.white,
          hourMinuteTextStyle: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            // color: Colors.blue,
          ),
          dayPeriodTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            // color: Colors.blueAccent,
          ),
          // entryModeIconColor: Colors.blue,
        ),

      );

  // Light theme
  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: lightTitle,
          secondary: Color.fromARGB(255, 230, 233, 233),
          surface: Color.fromARGB(255, 192, 197, 204),
          surfaceContainer: Color.fromARGB(255, 225, 229, 233),
          surfaceTint: Color.fromARGB(255, 205, 216, 216),
          surfaceBright: Color.fromARGB(255, 240, 240, 240),
          onPrimary: lightBG,
          onSecondary: lightSubtitle,
          onSurface: lightSubtitle,
          error: Colors.red, // Add an error color if needed
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.montserrat(fontSize: getDynamicFontSize(104), color: lightTitle,),
          titleMedium: GoogleFonts.montserrat(fontSize: getDynamicFontSize(70), color: lightTitle,),
          bodySmall: GoogleFonts.montserrat(fontSize: getDynamicFontSize(14), color: lightSubtitle,),
          labelSmall:GoogleFonts.montserrat(fontSize: getDynamicFontSize(12), color: lightTitle,) ,
          displaySmall:GoogleFonts.montserrat(fontSize: getDynamicFontSize(13), color: const Color.fromARGB(61, 0, 0, 0),),
          bodyMedium: GoogleFonts.montserrat(fontSize: getDynamicFontSize(13), color: lightTitle,),
          headlineMedium: GoogleFonts.montserrat(fontSize: getDynamicFontSize(17), color: lightTitle, fontWeight: FontWeight.bold),
          displayMedium: GoogleFonts.montserrat(fontSize: getDynamicFontSize(18), color: lightTitle,),
        ),
        // floatingActionButtonTheme: FloatingActionButtonThemeData(
        //   backgroundColor: Colors.amber
        // ),

        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(lightTitle.withOpacity(0.2)), // 20% transparency of the primary color
        ),

        sliderTheme: SliderThemeData(
          trackHeight: 1.0, // Hairline thickness
          activeTrackColor: const Color.fromARGB(166, 0, 0, 0),
          secondaryActiveTrackColor: Colors.black,
          showValueIndicator: ShowValueIndicator.always,
          inactiveTrackColor: Colors.black, // Match inactive track to active track
          thumbColor: Colors.black,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0), // Adjust size as needed
          overlayColor: Colors.black.withOpacity(0.2), // Optional: for touch feedback
          valueIndicatorColor: Colors.black,
          valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
          valueIndicatorTextStyle: const TextStyle(color: Colors.white),
          ),

          // ANDROID TIME PICKER THEME
        timePickerTheme: const TimePickerThemeData(
          // backgroundColor: Colors.white,
          hourMinuteTextStyle: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            // color: Colors.blue,
          ),
          dayPeriodTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            // color: Colors.blueAccent,
          ),
          // entryModeIconColor: Colors.blue,
        ),
      );

  // Time Container Style
  static BoxDecoration timeContainerDecor({context, bool isSelected = false}) {
    bool isLight = Theme.of(context).colorScheme.primary != ThemeConstants.darkTitle;
    final backgroundColor = Theme.of(context).colorScheme.surfaceContainer;
    final borderColor = !isSelected
        ? (isLight ? Colors.transparent : Colors.transparent) //// onSecondary was here
        : (!isLight
            // ? neutralblue // Dark Color
            ? const Color.fromARGB(255, 58, 66, 156)// Dark Color
            : const Color.fromARGB(255, 255, 255, 255)); // Light Color

    return BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: backgroundColor,
      border: Border.all(
        color: borderColor,
        width: isSelected ? 2 : 1,
      ),
      boxShadow: isSelected && isLight ? [
        BoxShadow(
          color: Colors.white.withOpacity(0.7), // White color with opacity for glow
          spreadRadius: 5, // How much the shadow spreads
          blurRadius: 15, // How blurred the shadow is
          offset: const Offset(0, 0), // Shadow position (x, y)
        ),
      ] : null,
    );
  }
}
