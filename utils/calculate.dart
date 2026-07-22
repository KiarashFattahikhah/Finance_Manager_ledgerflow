import 'package:flutter_project/models/money.dart';
import 'package:hive/hive.dart';

Box<Money> hiveBox = Hive.box<Money>('moneyBox'); 

final DateTime now = DateTime.now();

String year = now.year.toString();
String month = now.month.toString().padLeft(2, '0');
String day = now.day.toString().padLeft(2, '0');

class Calculate {
  static double pDayIndex(int day) {
    double result = 0;

    for (var value in hiveBox.values) {
      String raw = value.date;

      // FIX: Convert 2024/06/05 → 2024-06-05
      raw = raw.replaceAll("/", "-");

      final date = DateTime.tryParse(raw);

      if (date != null &&
          date.day == day &&
          date.month == DateTime.now().month &&
          value.isReceived == false) {
        result += double.parse(value.price.replaceAll(",", ""));
      }
    }

    return result;
  }

  static double dDayIndex(int day) {
    double result = 0;

    for (var value in hiveBox.values) {
      String raw = value.date;

      // FIX: Convert 2024/06/05 → 2024-06-05
      raw = raw.replaceAll("/", "-");

      final date = DateTime.tryParse(raw);

      if (date != null &&
          date.day == day &&
          date.month == DateTime.now().month &&
          value.isReceived == true) {
        result += double.parse(value.price.replaceAll(",", ""));
      }
    }

    return result;
  }

  
  static double pMonthIndex(int month) {
    double result = 0;
  
    for (var value in hiveBox.values) {
      String raw = value.date;
  
      // FIX: Convert 2024/06/05 → 2024-06-05
      raw = raw.replaceAll("/", "-");
  
      final date = DateTime.tryParse(raw);
  
      if (date != null &&
          date.month == month &&
          value.isReceived == false) {
        result += double.parse(value.price.replaceAll(",", ""));
      }
    }
  
    return result;
  }
  
  static double dMonthIndex(int month) {
    double result = 0;
  
    for (var value in hiveBox.values) {
      String raw = value.date;
  
      // FIX: Convert 2024/06/05 → 2024-06-05
      raw = raw.replaceAll("/", "-");
  
      final date = DateTime.tryParse(raw);
  
      if (date != null &&
          date.month == month &&
          value.isReceived == true) {
        result += double.parse(value.price.replaceAll(",", ""));
      }
    }
  
    return result;
  }
  

  static String today() {
    
    return "$year/$month/$day";

  }
  

  static double pToday() {
    double result = 0; 
    for (var value in hiveBox.values) {
      if (value.date == today() && value.isReceived == false) {
        result += double.parse(value.price.replaceAll(',', ''));
      }
    }
    return result;
  }

  static double dToday() {
    double result = 0; 
    for (var value in hiveBox.values) {
      if (value.date == today() && value.isReceived == true) {
        result += double.parse(value.price.replaceAll(',', ''));
      }
    }
    return result;
  }

  static double pMonth() {
    double result = 0; 
    for (var value in hiveBox.values) {
      if (value.date.substring(5, 7) == month && value.isReceived == false) {
        result += double.parse(value.price.replaceAll(',', ''));
      }
    }
    return result;
  }

  static double dMonth() {
    double result = 0; 
    for (var value in hiveBox.values) {
      if (value.date.substring(5, 7) == month && value.isReceived == true) {
        result += double.parse(value.price.replaceAll(',', ''));
      }
    }
    return result;
  }

  static double pYear() {
    double result = 0; 
    for (var value in hiveBox.values) {
      if (value.date.substring(0, 4) == year && value.isReceived == false) {
        result += double.parse(value.price.replaceAll(',', ''));
      }
    }
    return result;
  }

  static double dYear() {
    double result = 0; 
    for (var value in hiveBox.values) {
      if (value.date.substring(0, 4) == year && value.isReceived == true) {
        result += double.parse(value.price.replaceAll(',', ''));
      }
    }
    return result;
  }
}