import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:time_slider/View/Screens/settings_screen.dart';
import 'package:time_slider/View/Theme/themeconstants.dart';
import 'package:time_slider/View/Utils/TimeZone%20components/fadingcolon.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimeFunctions {

  static String formatTimeOnly({
    required tz.TZDateTime current,
    required BuildContext context,
    bool showSeconds = false,
    bool show12HourFormat = false, // Parameter for 24-hour format
  }) {
    // Format the time based on 24-hour or 12-hour format
    final hour = !show12HourFormat ? current.hour : (current.hour % 12 == 0 ? 12 : current.hour % 12);
    final formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinutes = current.minute.toString().padLeft(2, '0');
    // final formattedSeconds = current.second.toString().padLeft(2, '0');
    final isAM = show12HourFormat ? (current.hour < 12 ? 'AM' : 'PM') : '';
    // No AM/PM for 24-hour 

    return "$formattedHour:$formattedMinutes $isAM";
  }

  static String formatHourOnly(current, show12HourFormat) {
    final hour = !show12HourFormat 
    ? current.hour 
    : (current.hour % 12 == 0 ? 12 : current.hour % 12);
    final formattedHour = hour.toString().padLeft(2, '0');
    return formattedHour;
  }

  static Widget formatTime({
    required tz.TZDateTime current,
    required BuildContext context,
    bool showSeconds = false,
    bool show12HourFormat = false, // Parameter for 24-hour format
  }) {
    // Format the time based on 24-hour or 12-hour format
    final hour = !show12HourFormat ? current.hour : (current.hour % 12 == 0 ? 12 : current.hour % 12);
    final formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinutes = current.minute.toString().padLeft(2, '0');
    final formattedSeconds = current.second.toString().padLeft(2, '0');
    final isAM = show12HourFormat ? (current.hour < 12 ? 'AM' : 'PM') : '';
    // No AM/PM for 24-hour format

    // Style selection
    final timeStyle = showSeconds
        ? Theme.of(context).textTheme.titleMedium
        : Theme.of(context).textTheme.titleLarge;

    // Widget helpers
    Widget buildSeparator() => FadingWidget(
          child: Transform.translate(
            offset: Offset(0, ThemeConstants.getDynamicFontSize(-5)),
            child: Text(":", style: timeStyle),
          ),
        );

    Widget buildAmPm() => Transform.translate(
          offset: Offset(
            ThemeConstants.getDynamicFontSize(-5),
            ThemeConstants.getDynamicFontSize(0),
          ),
          child: Text(isAM, style: Theme.of(context).textTheme.headlineMedium),
        );

    // Main row with hours, minutes, and optionally seconds
    final timeRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(formattedHour, style: timeStyle),
        buildSeparator(),
        Text(formattedMinutes, style: timeStyle),
        if (showSeconds) ...[
          buildSeparator(),
          Text(formattedSeconds, style: timeStyle),
        ],
      ],
    );

    // Final stack with optional AM/PM
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        timeRow,
        if (show12HourFormat) buildAmPm(),
      ],
    );
  }

  // STOP WATCH FUNCTIONS
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds =
        (duration.inMilliseconds % 100).toString().padLeft(2, "0");
    return hours != "00"
        ? "$hours:$minutes:$seconds.$milliseconds"
        : "$minutes:$seconds.$milliseconds";
  }

  // STOP WATCH FUNCTIONS
  static Row formatDurationRow(Duration duration) {
    TextStyle robotoMono = GoogleFonts.robotoMono(fontSize: 80);
    double presentHourSize = 60;
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds =
        (duration.inMilliseconds % 100).toString().padLeft(2, "0");
    // return hours != "00"
    // ? "$hours:$minutes:$seconds.$milliseconds"
    // : "$minutes:$seconds.$milliseconds";
    return hours != "00"
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(hours, style: GoogleFonts.robotoMono(fontSize: 50)),
              Text(minutes, style: GoogleFonts.robotoMono(fontSize: 50)),
              Text(seconds, style: GoogleFonts.robotoMono(fontSize: 50)),
              Text(milliseconds, style: GoogleFonts.robotoMono(fontSize: 50)),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(minutes, style: robotoMono),
              Text(":", style: robotoMono),
              Text(seconds, style: robotoMono),
              Text(":", style: robotoMono),
              Text(milliseconds, style: robotoMono),
            ],
          );
  }

  // POMODORO Time Format
  static String formatTimeFromSeconds(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    if (hours > 0) {
      return '${NumberFormat("00").format(hours)}:${NumberFormat("00").format(minutes)}:${NumberFormat("00").format(remainingSeconds)}';
    } else {
      return '${NumberFormat("00").format(minutes)}:${NumberFormat("00").format(remainingSeconds)}';
    }
  }

  // Format Time from datetime
  static String formatTimeFromDateTime(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  // Format date into a readable format
  static Map<String, String> formatDate(tz.TZDateTime current) {
    final dayOfWeek = DateFormat('EEEE').format(current);
    final fullDate = DateFormat.yMMMMd().format(current);
    return {
      'dayOfWeek': dayOfWeek,
      'fullDate': fullDate,
    };
  }

  // Format counter display
  static String formatCounter(int counter) {
    String sign = counter >= 0 ? '+' : '-';
    int absCounter = counter.abs();

    int hours = absCounter ~/ 60;
    int minutes = absCounter % 60;

    return hours + minutes == 0
        ? ""
        : (hours > 0
            ? '$sign${hours}h${minutes > 0 ? ', ${minutes}m' : ''}'
            : '$sign${minutes}m');
  }

  // Get Offset function
  static String getTimezoneOffset(String timezone) {
    // Get location from timezone
    final location = tz.getLocation(timezone);
    final now = tz.TZDateTime.now(location);
    final offset = now.timeZoneOffset;

    // Format the offset with the sign
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final sign = offset.isNegative ? '-' : '+';

    return 'GMT$sign$hours:$minutes';
  }

  static String replaceLongWords(String input) {
    // Split the input into words
    return input.split(' ').map((word) {
      return word.length > 10 ? word.replaceAll(' ', '\n') : word;
    }).join(' ');
  }

  // Mapping of timezones to city-country pairs
  static String getCityAndCountryFromTimezone(String timezone) {
    const Map<String, String> timezoneToCityCountry = {
      'Africa/Abidjan': 'Abidjan, Ivory Coast',
      'Africa/Accra': 'Accra, Ghana',
      'Africa/Addis_Ababa': 'Addis Ababa, Ethiopia',
      'Africa/Algiers': 'Algiers, Algeria',
      'Africa/Asmara': 'Asmara, Eritrea',
      'Africa/Bamako': 'Bamako, Mali',
      'Africa/Bangui': 'Bangui, \nC. African Republic',
      'Africa/Banjul': 'Banjul, Gambia',
      'Africa/Bissau': 'Bissau, Guinea-Bissau',
      'Africa/Blantyre': 'Blantyre, Malawi',
      'Africa/Brazzaville': 'Brazzaville, Congo',
      'Africa/Bujumbura': 'Bujumbura, Burundi',
      'Africa/Cairo': 'Cairo, Egypt',
      'Africa/Casablanca': 'Casablanca, Morocco',
      'Africa/Ceuta': 'Ceuta, Spain',
      'Africa/Conakry': 'Conakry, Guinea',
      'Africa/Dakar': 'Dakar, Senegal',
      'Africa/Dar_es_Salaam': 'Dar es Salaam, Tanzania',
      'Africa/Djibouti': 'Djibouti, Djibouti',
      'Africa/Douala': 'Douala, Cameroon',
      'Africa/El_Aaiun': 'El Aaiun, Western Sahara',
      'Africa/Freetown': 'Freetown,\nSierra Leone',
      'Africa/Gaborone': 'Gaborone, Botswana',
      'Africa/Harare': 'Harare, Zimbabwe',
      'Africa/Johannesburg': 'Johannesburg, South Africa',
      'Africa/Juba': 'Juba, South Sudan',
      'Africa/Kampala': 'Kampala, Uganda',
      'Africa/Khartoum': 'Khartoum, Sudan',
      'Africa/Kigali': 'Kigali, Rwanda',
      'Africa/Kinshasa': 'Kinshasa,\nCongo Republic',
      'Africa/Lagos': 'Lagos, Nigeria',
      'Africa/Libreville': 'Libreville, Gabon',
      'Africa/Lome': 'Lome, Togo',
      'Africa/Luanda': 'Luanda, Angola',
      'Africa/Lubumbashi': 'Lubumbashi,\nCongo Republic',
      'Africa/Lusaka': 'Lusaka, Zambia',
      'Africa/Malabo': 'Malabo,\nEquatorial Guinea',
      'Africa/Maputo': 'Maputo, Mozambique',
      'Africa/Maseru': 'Maseru, Lesotho',
      'Africa/Mbabane': 'Mbabane, Eswatini',
      'Africa/Mogadishu': 'Mogadishu, Somalia',
      'Africa/Monrovia': 'Monrovia, Liberia',
      'Africa/Nairobi': 'Nairobi, Kenya',
      'Africa/Ndjamena': 'Ndjamena, Chad',
      'Africa/Niamey': 'Niamey, Niger',
      'Africa/Nouakchott': 'Nouakchott, Mauritania',
      'Africa/Ouagadougou': 'Ouagadougou,\nBurkina Faso',
      'Africa/Porto-Novo': 'Porto-Novo, Benin',
      'Africa/Sao_Tome': 'Sao Tome,\nSao Tome and Principe',
      'Africa/Tripoli': 'Tripoli, Libya',
      'Africa/Tunis': 'Tunis, Tunisia',
      'Africa/Windhoek': 'Windhoek, Namibia',
      'America/Adak': 'Adak, United States',
      'America/Anchorage': 'Anchorage, United States',
      'America/Anguilla': 'Anguilla, Anguilla',
      'America/Antigua': 'Antigua,\nAntigua and Barbuda',
      'America/Argentina/Buenos_Aires': 'Buenos Aires, Argentina',
      'America/Argentina/Catamarca': 'Catamarca, Argentina',
      'America/Argentina/Cordoba': 'Cordoba, Argentina',
      'America/Argentina/Jujuy': 'Jujuy, Argentina',
      'America/Argentina/La_Rioja': 'La Rioja, Argentina',
      'America/Argentina/Mendoza': 'Mendoza, Argentina',
      'America/Argentina/Rio_Gallegos': 'Rio Gallegos, Argentina',
      'America/Argentina/Salta': 'Salta, Argentina',
      'America/Argentina/San_Juan': 'San Juan, Argentina',
      'America/Argentina/San_Luis': 'San Luis, Argentina',
      'America/Argentina/Tucuman': 'Tucuman, Argentina',
      'America/Argentina/Ushuaia': 'Ushuaia, Argentina',
      'America/Aruba': 'Oranjestad, Aruba',
      'America/Asuncion': 'Asuncion, Paraguay',
      'America/Atikokan': 'Atikokan, Canada',
      'America/Bahia': 'Salvador, Brazil',
      'America/Bahia_Banderas': 'Bahia Banderas, Mexico',
      'America/Barbados': 'Bridgetown, Barbados',
      'America/Belem': 'Belem, Brazil',
      'America/Belize': 'Belize City, Belize',
      'America/Blanc-Sablon': 'Blanc-Sablon, Canada',
      'America/Boa_Vista': 'Boa Vista, Brazil',
      'America/Bogota': 'Bogota, Colombia',
      'America/Boise': 'Boise, United States',
      'America/Cambridge_Bay': 'Cambridge Bay, Canada',
      'America/Campo_Grande': 'Campo Grande, Brazil',
      'America/Cancun': 'Cancun, Mexico',
      'America/Caracas': 'Caracas, Venezuela',
      'America/Cayenne': 'Cayenne, French Guiana',
      'America/Cayman': 'George Town,\nCayman Islands',
      'America/Chicago': 'Chicago, United States',
      'America/Chihuahua': 'Chihuahua, Mexico',
      'America/Costa_Rica': 'San Jose, Costa Rica',
      'America/Creston': 'Creston, Canada',
      'America/Cuiaba': 'Cuiaba, Brazil',
      'America/Curacao': 'Willemstad, Curacao',
      'America/Danmarkshavn': 'Danmarkshavn,\nGreenland',
      'America/Dawson': 'Dawson, Canada',
      'America/Dawson_Creek': 'Dawson Creek, Canada',
      'America/Denver': 'Denver, United States',
      'America/Detroit': 'Detroit, United States',
      'America/Dominica': 'Roseau, Dominica',
      'America/Edmonton': 'Edmonton, Canada',
      'America/Eirunepe': 'Eirunepe, Brazil',
      'America/El_Salvador': 'San Salvador, El Salvador',
      'America/Fortaleza': 'Fortaleza, Brazil',
      'America/Glace_Bay': 'Glace Bay, Canada',
      'America/Godthab': 'Nuuk, Greenland',
      'America/Goose_Bay': 'Goose Bay, Canada',
      'America/Grand_Turk': 'Cockburn Town, \nTurks and Caicos Islands',
      'America/Grenada': 'St. George’s, Grenada',
      'America/Guadeloupe': 'Basse-Terre, Guadeloupe',
      'America/Guatemala': 'Guatemala City,\nGuatemala',
      'America/Guayaquil': 'Guayaquil, Ecuador',
      'America/Guyana': 'Georgetown, Guyana',
      'America/Halifax': 'Halifax, Canada',
      'America/Havana': 'Havana, Cuba',
      'America/Hermosillo': 'Hermosillo, Mexico',
      'America/Indiana/Indianapolis': 'Indianapolis,\nUnited States',
      'America/Indiana/Knox': 'Knox, United States',
      'America/Indiana/Marengo': 'Marengo, United States',
      'America/Indiana/Petersburg': 'Petersburg, United States',
      'America/Indiana/Tell_City': 'Tell City, United States',
      'America/Indiana/Vevay': 'Vevay, United States',
      'America/Indiana/Vincennes': 'Vincennes, United States',
      'America/Indiana/Winamac': 'Winamac, United States',
      'America/Inuvik': 'Inuvik, Canada',
      'America/Iqaluit': 'Iqaluit, Canada',
      'America/Jamaica': 'Kingston, Jamaica',
      'America/Juneau': 'Juneau, United States',
      'America/Kentucky/Louisville': 'Louisville, United States',
      'America/Kentucky/Monticello': 'Monticello, United States',
      'America/Kralendijk': 'Kralendijk, Bonaire',
      'America/La_Paz': 'La Paz, Bolivia',
      'America/Lima': 'Lima, Peru',
      'America/Los_Angeles': 'Los Angeles, United States',
      'America/Lower_Princes': 'Lower Princes,\nSint Maarten',
      'America/Maceio': 'Maceio, Brazil',
      'America/Managua': 'Managua, Nicaragua',
      'America/Manaus': 'Manaus, Brazil',
      'America/Marigot': 'Marigot, Saint Martin',
      'America/Martinique': 'Fort-de-France,\nMartinique',
      'America/Matamoros': 'Matamoros, Mexico',
      'America/Mazatlan': 'Mazatlan, Mexico',
      'America/Menominee': 'Menominee,\nUnited States',
      'America/Merida': 'Merida, Mexico',
      'America/Metlakatla': 'Metlakatla,\nUnited States',
      'America/Mexico_City': 'Mexico City, Mexico',
      'America/Miquelon': 'Saint-Pierre,\nSaint Pierre and Miquelon',
      'America/Moncton': 'Moncton, Canada',
      'America/Monterrey': 'Monterrey, Mexico',
      'America/Montevideo': 'Montevideo, Uruguay',
      'America/Montreal': 'Montreal, Canada',
      'America/Montserrat': 'Plymouth, Montserrat',
      'America/Nassau': 'Nassau, Bahamas',
      'America/New_York': 'New York, United States',
      'America/Nipigon': 'Nipigon, Canada',
      'America/Nome': 'Nome, United States',
      'America/Noronha': 'Fernando de Noronha,\nBrazil',
      'America/North_Dakota/Beulah': 'Beulah, United States',
      'America/North_Dakota/Center': 'Center, United States',
      'America/North_Dakota/New_Salem': 'New Salem,\nUnited States',
      'America/Ojinaga': 'Ojinaga, Mexico',
      'America/Panama': 'Panama City, Panama',
      'America/Pangnirtung': 'Pangnirtung, Canada',
      'America/Paramaribo': 'Paramaribo, Suriname',
      'America/Phoenix': 'Phoenix, United States',
      'America/Port-au-Prince': 'Port-au-Prince, Haiti',
      'America/Port_of_Spain': 'Port of Spain,\nTrinidad and Tobago',
      'America/Porto_Velho': 'Porto Velho, Brazil',
      'America/Puerto_Rico': 'San Juan, Puerto Rico',
      'America/Rainy_River': 'Rainy River, Canada',
      'America/Rankin_Inlet': 'Rankin Inlet, Canada',
      'America/Recife': 'Recife, Brazil',
      'America/Regina': 'Regina, Canada',
      'America/Resolute': 'Resolute, Canada',
      'America/Rio_Branco': 'Rio Branco, Brazil',
      'America/Santa_Isabel': 'Santa Isabel, Brazil',
      'America/Santarem': 'Santarem, Brazil',
      'America/Santiago': 'Santiago, Chile',
      'America/Santo_Domingo': 'Santo Domingo, \nDominican Republic',
      'America/Sao_Paulo': 'Sao Paulo, Brazil',
      'America/Scoresbysund': 'Scoresbysund, Greenland',
      'America/Sitka': 'Sitka, United States',
      'America/St_Barthelemy': 'Gustavia,\nSaint Barthelemy',
      'America/St_Johns': 'St. Johns, Canada',
      'America/St_Kitts': 'Basseterre,\nSaint Kitts and Nevis',
      'America/St_Lucia': 'Castries,\nSaint Lucia',
      'America/St_Thomas': 'Charlotte Amalie, U.S. \nVirgin Islands',
      'America/St_Vincent': 'Kingstown,\nSaint Vincent\nand The Grenadines',
      'America/Swift_Current': 'Swift Current, Canada',
      'America/Tegucigalpa': 'Tegucigalpa, Honduras',
      'America/Thule': 'Thule, Greenland',
      'America/Thunder_Bay': 'Thunder Bay, Canada',
      'America/Tijuana': 'Tijuana, Mexico',
      'America/Toronto': 'Toronto, Canada',
      'America/Tortola': 'Road Town,\nBritish Virgin Islands',
      'America/Vancouver': 'Vancouver, Canada',
      'America/Whitehorse': 'Whitehorse, Canada',
      'America/Winnipeg': 'Winnipeg, Canada',
      'America/Yakutat': 'Yakutat, United States',
      'America/Yellowknife': 'Yellowknife, Canada',
      'Antarctica/Casey': 'Casey Station, Antarctica',
      'Antarctica/Davis': 'Davis Station, Antarctica',
      'Antarctica/DumontDUrville': 'Dumont d’Urville,\nAntarctica',
      'Antarctica/Macquarie': 'Macquarie Island,\nAustralia',
      'Antarctica/Mawson': 'Mawson Station,\nAntarctica',
      'Antarctica/McMurdo': 'McMurdo Station,\nAntarctica',
      'Antarctica/Palmer': 'Palmer Station,\nAntarctica',
      'Antarctica/Rothera': 'Rothera Station,\nAntarctica',
      'Antarctica/Syowa': 'Syowa Station,\nAntarctica',
      'Antarctica/Troll': 'Troll Station,\nAntarctica',
      'Antarctica/Vostok': 'Vostok Station,\nAntarctica',
      'Arctic/Longyearbyen': 'Longyearbyen,\nSvalbard',
      'Asia/Aden': 'Aden, Yemen',
      'Asia/Almaty': 'Almaty, Kazakhstan',
      'Asia/Amman': 'Amman, Jordan',
      'Asia/Anadyr': 'Anadyr, Russia',
      'Asia/Aqtau': 'Aqtau, Kazakhstan',
      'Asia/Aqtobe': 'Aqtobe, Kazakhstan',
      'Asia/Ashgabat': 'Ashgabat, Turkmenistan',
      'Asia/Baghdad': 'Baghdad, Iraq',
      'Asia/Bahrain': 'Manama, Bahrain',
      'Asia/Baku': 'Baku, Azerbaijan',
      'Asia/Bangkok': 'Bangkok, Thailand',
      'Asia/Beirut': 'Beirut, Lebanon',
      'Asia/Bishkek': 'Bishkek, Kyrgyzstan',
      'Asia/Brunei': 'Bandar Seri Begawan,\nBrunei',
      'Asia/Chita': 'Chita, Russia',
      'Asia/Choibalsan': 'Choibalsan, Mongolia',
      'Asia/Colombo': 'Colombo, Sri Lanka',
      'Asia/Damascus': 'Damascus, Syria',
      'Asia/Dhaka': 'Dhaka, Bangladesh',
      'Asia/Dili': 'Dili, Timor-Leste',
      'Asia/Dubai': 'Dubai,\nUnited Arab Emirates',
      'Asia/Dushanbe': 'Dushanbe, Tajikistan',
      'Asia/Gaza': 'Gaza, Palestine',
      'Asia/Hebron': 'Hebron, Palestine',
      'Asia/Ho_Chi_Minh': 'Ho Chi Minh City,\nVietnam',
      'Asia/Hong_Kong': 'Hong Kong, China',
      'Asia/Hovd': 'Hovd, Mongolia',
      'Asia/Irkutsk': 'Irkutsk, Russia',
      'Asia/Jakarta': 'Jakarta, Indonesia',
      'Asia/Jayapura': 'Jayapura, Indonesia',
      'Asia/Jerusalem': 'Jerusalem, Israel',
      'Asia/Kabul': 'Kabul, Afghanistan',
      'Asia/Kamchatka': 'Petropavlovsk-\nKamchatsky, Russia',
      'Asia/Karachi': 'Karachi, Pakistan',
      'Asia/Kathmandu': 'Kathmandu, Nepal',
      'Asia/Khandyga': 'Khandyga, Russia',
      'Asia/Kolkata': 'Kolkata, India',
      'Asia/Krasnoyarsk': 'Krasnoyarsk, Russia',
      'Asia/Kuala_Lumpur': 'Kuala Lumpur, Malaysia',
      'Asia/Kuching': 'Kuching, Malaysia',
      'Asia/Kuwait': 'Kuwait City, Kuwait',
      'Asia/Macau': 'Macau, China',
      'Asia/Magadan': 'Magadan, Russia',
      'Asia/Makassar': 'Makassar, Indonesia',
      'Asia/Manila': 'Manila, Philippines',
      'Asia/Muscat': 'Muscat, Oman',
      'Asia/Nicosia': 'Nicosia, Cyprus',
      'Asia/Novokuznetsk': 'Novokuznetsk,\nRussia',
      'Asia/Novosibirsk': 'Novosibirsk,\nRussia',
      'Asia/Omsk': 'Omsk, Russia',
      'Asia/Oral': 'Oral, Kazakhstan',
      'Asia/Phnom_Penh': 'Phnom Penh, Cambodia',
      'Asia/Pontianak': 'Pontianak, Indonesia',
      'Asia/Pyongyang': 'Pyongyang, North Korea',
      'Asia/Qatar': 'Doha, Qatar',
      'Asia/Qyzylorda': 'Qyzylorda, Kazakhstan',
      'Asia/Riyadh': 'Riyadh, Saudi Arabia',
      'Asia/Rangoon': 'Yancon, Myanmar',
      'Asia/Sakhalin': 'Yuzhno-Sakhalinsk,\nRussia',
      'Asia/Samarkand': 'Samarkand, Uzbekistan',
      'Asia/Seoul': 'Seoul, South Korea',
      'Asia/Shanghai': 'Shanghai, China',
      'Asia/Singapore': 'Singapore, Singapore',
      'Asia/Taipei': 'Taipei, Taiwan',
      'Asia/Tashkent': 'Tashkent, Uzbekistan',
      'Asia/Tbilisi': 'Tbilisi, Georgia',
      'Asia/Tehran': 'Tehran, Iran',
      'Asia/Thimphu': 'Thimphu, Bhutan',
      'Asia/Tokyo': 'Tokyo, Japan',
      'Asia/Ulaanbaatar': 'Ulaanbaatar, Mongolia',
      'Asia/Urumqi': 'Urumqi, China',
      'Asia/Vientiane': 'Vientiane, Laos',
      'Asia/Vladivostok': 'Vladivostok, Russia',
      'Asia/Yakutsk': 'Yakutsk, Russia',
      'Asia/Yangon': 'Yangon, Myanmar',
      'Asia/Yerevan': 'Yerevan, Armenia',
      'Atlantic/Azores': 'Azores, Portugal',
      'Atlantic/Bermuda': 'Hamilton, Bermuda',
      'Atlantic/Canary': 'Las Palmas, Spain',
      'Atlantic/Cape_Verde': 'Praia, Cape Verde',
      'Atlantic/Faeroe': 'Torshavn, Faroe Islands',
      'Atlantic/Faroe': 'Torshavn, Faroe Islands',
      'Atlantic/Reykjavik': 'Reykjavik, Iceland',
      'Atlantic/South_Georgia': 'King Edward Point,\nSouth Georgia',
      'Atlantic/Stanley': 'Stanley, Falkland Islands',
      'Australia/Adelaide': 'Adelaide, Australia',
      'Australia/Brisbane': 'Brisbane, Australia',
      'Australia/Broken_Hill': 'Broken Hill,\nAustralia',
      'Australia/Darwin': 'Darwin, Australia',
      'Australia/Hobart': 'Hobart, Australia',
      'Australia/Perth': 'Perth, Australia',
      'Australia/Sydney': 'Sydney, Australia',
      'Australia/Lord_Howe': 'Lord Howe Island,\nAustralia',
      'Europe/Amsterdam': 'Amsterdam,\nNetherlands',
      'Europe/Andorra': 'Andorra la Vella,\nAndorra',
      'Europe/Astrakhan': 'Astrakhan, Russia',
      'Europe/Athens': 'Athens, Greece',
      'Europe/Belfast': 'Belfast, United Kingdom',
      'Europe/Berlin': 'Berlin, Germany',
      'Europe/Bratislava': 'Bratislava, Slovakia',
      'Europe/Brussels': 'Brussels, Belgium',
      'Europe/Bucharest': 'Bucharest, Romania',
      'Europe/Budapest': 'Budapest, Hungary',
      'Europe/Chisinau': 'Chisinau, Moldova',
      'Europe/Copenhagen': 'Copenhagen, Denmark',
      'Europe/Dublin': 'Dublin, Ireland',
      'Europe/Gibraltar': 'Gibraltar, Gibraltar',
      'Europe/Guernsey': 'St. Peter Port, Guernsey',
      'Europe/Helsinki': 'Helsinki, Finland',
      'Europe/Isle_of_Man': 'Douglas, Isle of Man',
      'Europe/Istanbul': 'Istanbul, Turkey',
      'Europe/Jersey': 'St. Helier, Jersey',
      'Europe/Kaliningrad': 'Kaliningrad, Russia',
      'Europe/Kiev': 'Kyiv, Ukraine',
      'Europe/Kosovo': 'Pristina, Kosovo',
      'Europe/Lisbon': 'Lisbon, Portugal',
      'Europe/Ljubljana': 'Ljubljana, Slovenia',
      'Europe/London': 'London,\nUnited Kingdom',
      'Europe/Luxembourg': 'Luxembourg City,\nLuxembourg',
      'Europe/Madrid': 'Madrid, Spain',
      'Europe/Malta': 'Valletta, Malta',
      'Europe/Minsk': 'Minsk, Belarus',
      'Europe/Monaco': 'Monaco, Monaco',
      'Europe/Moscow': 'Moscow, Russia',
      'Europe/Nicosia': 'Nicosia, Cyprus',
      'Europe/Oslo': 'Oslo, Norway',
      'Europe/Paris': 'Paris, France',
      'Europe/Prague': 'Prague, Czech Republic',
      'Europe/Riga': 'Riga, Latvia',
      'Europe/Rome': 'Rome, Italy',
      'Europe/Samara': 'Samara, Russia',
      'Europe/San_Marino': 'San Marino, San Marino',
      'Europe/Sarajevo': 'Sarajevo, Bosnia \n& Herzegovina',
      'Europe/Sofia': 'Sofia, Bulgaria',
      'Europe/Tallinn': 'Tallinn, Estonia',
      'Europe/Tirane': 'Tirana, Albania',
      'Europe/Uzhgorod': 'Uzhgorod, Ukraine',
      'Europe/Vaduz': 'Vaduz, Liechtenstein',
      'Europe/Vienna': 'Vienna, Austria',
      'Europe/Vilnius': 'Vilnius, Lithuania',
      'Europe/Zagreb': 'Zagreb, Croatia',
      'Pacific/Apia': 'Apia, Samoa',
      'Pacific/Auckland': 'Auckland, New Zealand',
      'Pacific/Bougainville': 'Bougainville, Papua New Guinea',
      'Pacific/Chatham': 'Chatham Islands,\nNew Zealand',
      'Pacific/Chuuk': 'Weno, Micronesia',
      'Pacific/Easter': 'Easter Island, Chile',
      'Pacific/Efate': 'Port Vila, Vanuatu',
      'Pacific/Fiji': 'Suva, Fiji',
      'Pacific/Funafuti': 'Funafuti, Tuvalu',
      'Pacific/Galapagos': 'Galapagos Islands,\nEcuador',
      'Pacific/Gambier': 'Gambier Islands, France',
      'Pacific/Guadalcanal': 'Honiara,\nSolomon Islands',
      'Pacific/Guam': 'Hagatna, Guam',
      'Pacific/Kiritimati': 'Kiritimati, Kiribati',
      'Pacific/Kosrae': 'Kosrae, Micronesia',
      'Pacific/Majuro': 'Majuro, Marshall Islands',
      'Pacific/Marquesas': 'Marquesas Islands, \nFrench Polynesia',
      'Pacific/Nauru': 'Yaren, Nauru',
      'Pacific/Niue': 'Alofi, Niue',
      'Pacific/Norfolk': 'Norfolk Island, Australia',
      'Pacific/Noumea': 'Noumea, New Caledonia',
      'Pacific/Pago_Pago': 'Pago Pago,\nAmerican Samoa',
      'Pacific/Port_Moresby': 'Port Moresby,\nPapua New Guinea',
      'Pacific/Port_Vila': 'Port Vila, Vanuatu',
      'Pacific/Rarotonga': 'Avarua, Cook Islands',
      'Pacific/Tahiti': 'Papeete, French Polynesia',
      'Pacific/Tarawa': 'Tarawa, Kiribati',
      'Pacific/Tongatapu': 'Nukuʻalofa, Tonga',
      'Pacific/Wallis': 'Wallis Island, France',
      'Pacific/Whangarei': 'Whangarei, New Zealand',
      'UTC': "Universal Standard Time"
    };

    return timezoneToCityCountry[timezone] ?? timezone;
  }

  static String getRegionFromAbbreviation(String abbreviation) {
    const Map<String, String> abbreviationToRegion = {
      'ACDT': 'Australia/Adelaide',
      'ACST': 'Australia/Adelaide',
      'ACT': 'Australia/Darwin',
      'ADT': 'America/Halifax',
      'AEDT': 'Australia/Sydney',
      'AEST': 'Australia/Brisbane',
      'AKDT': 'America/Anchorage',
      'AKST': 'America/Anchorage',
      'AMST': 'Asia/Yerevan',
      'AMT': 'Asia/Yekaterinburg',
      'ART': 'America/Argentina/Buenos_Aires',
      'AST': 'Asia/Riyadh',
      'AWDT': 'Australia/Perth',
      'AWST': 'Australia/Perth',
      'AZOST': 'Atlantic/Azores',
      'AZT': 'Asia/Baku',
      'BNT': 'Asia/Brunei',
      'BRT': 'America/Sao_Paulo',
      'BST': 'Asia/Dhaka',
      'CCT': 'Asia/Choibalsan',
      'CDT': 'America/Chicago',
      'CEST': 'Europe/Berlin',
      'CET': 'Europe/Berlin',
      'CHADT': 'Pacific/Chatham',
      'CHAST': 'Pacific/Chatham',
      'CKT': 'Pacific/Rarotonga',
      'CLT': 'America/Santiago',
      'COT': 'America/Bogota',
      'CST': 'America/Chicago',
      'CT': 'Asia/Shanghai',
      'CVT': 'Atlantic/Cape_Verde',
      'ChST': 'Pacific/Guam',
      'EADT': 'Pacific/Funafuti',
      'EAST': 'Pacific/Funafuti',
      'EET': 'Europe/Bucharest',
      'EEST': 'Europe/Helsinki',
      'EST': 'America/New_York',
      'ET': 'America/New_York',
      'FET': 'Europe/Minsk',
      'FJT': 'Pacific/Fiji',
      'FKT': 'Atlantic/Stanley',
      'GAMT': 'Pacific/Gambier',
      'GMT': 'Etc/GMT',
      'GST': 'Asia/Dubai',
      'HADT': 'America/Adak',
      'HAST': 'America/Adak',
      'HKT': 'Asia/Hong_Kong',
      'HMT': 'Asia/Kolkata',
      'HST': 'Pacific/Honolulu',
      'ICT': 'Asia/Bangkok',
      'IDT': 'Asia/Jerusalem',
      'IRDT': 'Asia/Tehran',
      'IRST': 'Asia/Tehran',
      'IST': 'Asia/Kolkata',
      'JST': 'Asia/Tokyo',
      'KGT': 'Asia/Bishkek',
      'KST': 'Asia/Seoul',
      'MDT': 'America/Denver',
      'MSK': 'Europe/Moscow',
      'MST': 'America/Denver',
      'NCT': 'Pacific/Noumea',
      'NDT': 'America/St_Johns',
      'NFT': 'Pacific/Norfolk',
      'NST': 'Pacific/Auckland',
      'NZDT': 'Pacific/Auckland',
      'NZST': 'Pacific/Auckland',
      'OMST': 'Asia/Omsk',
      'PDT': 'America/Los_Angeles',
      'PET': 'America/Lima',
      'PETT': 'Asia/Kamchatka',
      'PHT': 'Asia/Manila',
      'PKT': 'Asia/Karachi',
      'PMDT': 'America/Port_of_Spain',
      'PMST': 'America/Port_of_Spain',
      'PST': 'America/Los_Angeles',
      'PWT': 'Pacific/Palau',
      'PYST': 'America/Asuncion',
      'RET': 'Indian/Reunion',
      'RMT': 'Etc/GMT',
      'ROTT': 'America/Boa_Vista',
      'SAKST': 'Asia/Sakhalin',
      'SAKT': 'Asia/Sakhalin',
      'SAST': 'Africa/Johannesburg',
      'SGT': 'Asia/Singapore',
      'SRT': 'America/Paramaribo',
      'SST': 'Pacific/Apia',
      'SYOT': 'Antarctica/Syowa',
      'TJT': 'Asia/Dushanbe',
      'TKT': 'Pacific/Tokelau',
      'TLT': 'Asia/Dili',
      'TMT': 'Asia/Ashgabat',
      'TOST': 'Pacific/Tongatapu',
      'TOT': 'Pacific/Tongatapu',
      'UTC': 'Etc/UTC',
      'WAKT': 'Pacific/Wake',
      'WAST': 'Africa/Harare',
      'WET': 'Europe/Lisbon',
      'WIT': 'Asia/Jakarta',
      'WITA': 'Asia/Makassar',
      'WST': 'Australia/Perth',
      'WT': 'Etc/GMT',
      'YAKT': 'Asia/Yakutsk',
      'YEKT': 'Asia/Yekaterinburg',
    };

    return abbreviationToRegion[abbreviation] ?? abbreviation;
  }
}
