import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class App {
  // static SharedPreferences data;
  //
  // static Future init() async {
  //   data = await SharedPreferences.getInstance();
  // }
  //
  // static String parseHtmlString(String htmlString) {
  //   final document = parse(htmlString);
  //   final String parsedString = parse(document.body.text).documentElement.text;
  //
  //   return parsedString;
  // }

  static String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final time = DateFormat("HH.mm").format(dt);
    return time;
  }

  static String formatDate(String date) {
    final dt = DateTime(int.parse(date.split('-')[0]),
        int.parse(date.split('-')[1]), int.parse(date.split('-')[2]));
    final time = DateFormat('d/MM/y').format(dt);
    return time;
  }

  static String formatTimeOfDays(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final time = DateFormat("HH:mm:ss").format(dt);
    return time;
  }

  static String currency(BuildContext context, dynamic number, {String code}) {
    String symbol = "Rp ";

    if (code == "IDR") symbol = "Rp ";

    return NumberFormat.currency(
            locale: Localizations.localeOf(context).toString(),
            symbol: symbol,
            decimalDigits: 0)
        .format(number);
  }

  static String thousandSeparator(dynamic number) {
    var formatter = NumberFormat('###,000');
    return formatter.format(number).replaceAll(RegExp(r','), '.');
  }

  static String countdown(String createdAt) {
    var now = DateTime.now();
    var created = DateTime.parse(createdAt).toString().split(' ').first;
    var created2 = DateTime.parse(createdAt).toString().split(' ').last;

    Duration diffDays = now.difference(DateTime(
      int.parse(
        created.split('-').first,
      ),
      int.parse(created.split('-')[1]),
      int.parse(created.split('-')[2]),
      int.parse(created2.split(':').first),
      int.parse(created2.split(':')[1]),
    ));
    if (diffDays.inDays > 365)
      return (diffDays.inDays % 365).toString() + ' Tahun yang lalu';
    else if (diffDays.inDays > 30)
      return (diffDays.inDays % 30).toString() + ' Bulan yang lalu';
    else if (diffDays.inDays > 7)
      return (diffDays.inDays % 7).toString() + ' Minggu yang lalu';
    else if (diffDays.inDays != 0)
      return diffDays.inDays.toString() + ' Hari yang lalu';
    else if (diffDays.inHours != 0)
      return diffDays.inHours.toString() + ' Jam yang lalu';
    else if (diffDays.inMinutes != 0)
      return diffDays.inMinutes.toString() + ' Menit yang lalu';
    else
      return 'Baru saja';
  }

  static String getWeight(dynamic weight){
    String result;

    if (weight < 1000) {
      result = "$weight gram";
    } else if (weight >= 1000) {
      var f = NumberFormat("###.0#", "en_US");
      String conv = f.format(weight / 1000);
      result = "$conv kg";
    }

    return result;
  }

  static String getLocale(BuildContext context){
    return Localizations.localeOf(context).languageCode;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static int getCrossAxisCount(BuildContext context){
    double width = App.getWidth(context);

    if(width <= 200){
      return 1;
    }
    else if(width <= 600){
      return 2;
    }
    else if(width <= 1000){
      return 3;
    }
    else{
      return 4;
    }
  }
}
