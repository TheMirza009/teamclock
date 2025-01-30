class Weekday {
  final bool monday;
  final bool tuesday;
  final bool wednesday;
  final bool thursday;
  final bool friday;
  final bool saturday;
  final bool sunday;

  const Weekday({
    this.monday = false,
    this.tuesday = false,
    this.wednesday = false,
    this.thursday = false,
    this.friday = false,
    this.saturday = false,
    this.sunday = false,
  });

  // Default instance where all values are false
  factory Weekday.none() {
    return const Weekday();
  }

  // Instance where all values are true
  factory Weekday.everyday() {
    return const Weekday(
      monday: true,
      tuesday: true,
      wednesday: true,
      thursday: true,
      friday: true,
      saturday: true,
      sunday: true,
    );
  }

  static List<String> names = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  // Function to count how many days are true and return the day(s) name
  static String countTrueDays(Weekday weekdays) {
    List<String> trueDays = [];

    if (weekdays.monday) trueDays.add('Monday');
    if (weekdays.tuesday) trueDays.add('Tuesday');
    if (weekdays.wednesday) trueDays.add('Wednesday');
    if (weekdays.thursday) trueDays.add('Thursday');
    if (weekdays.friday) trueDays.add('Friday');
    if (weekdays.saturday) trueDays.add('Saturday');
    if (weekdays.sunday) trueDays.add('Sunday');

    if (trueDays.isEmpty) {
      return "None";
    } else if (trueDays.length == 7) {
      return "Everyday";
    } else if (trueDays.length == 1) {
      return trueDays[0]; // Only one day is selected
    } else if (trueDays.length == 2) {
      return trueDays.join(' & '); // Multiple days are selected, join them with commas
    } else {
      return "${trueDays.length} days";
    }
  }

   // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }

  // Create instance from JSON
  factory Weekday.fromJson(Map<String, dynamic> json) {
    return Weekday(
      monday: json['monday'] ?? false,
      tuesday: json['tuesday'] ?? false,
      wednesday: json['wednesday'] ?? false,
      thursday: json['thursday'] ?? false,
      friday: json['friday'] ?? false,
      saturday: json['saturday'] ?? false,
      sunday: json['sunday'] ?? false,
    );
  }
}

