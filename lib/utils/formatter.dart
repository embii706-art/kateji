import 'package:intl/intl.dart';

class Formatter {
  static String currency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
  
  static String date(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }
  
  static String time(DateTime date) {
    return DateFormat('HH:mm', 'id_ID').format(date);
  }
  
  static String dateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
  }
  
  static String shortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
