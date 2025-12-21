import 'package:intl/intl.dart';

String formatWithSuffix(DateTime date) {
  var day = date.day;
  var suffix = 'th';

  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1: suffix = 'st'; break;
      case 2: suffix = 'nd'; break;
      case 3: suffix = 'rd'; break;
    }
  }

  // Returns: 21st Dec, 2025
  return "$day$suffix ${DateFormat('MMM, yyyy').format(date)}";
}