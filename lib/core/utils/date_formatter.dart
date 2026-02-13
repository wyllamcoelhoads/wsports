import 'package:intl/intl.dart';

class DateFormatter {
  static String toBrazilian(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "Data N/A";
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return dateStr; // Retorna o original caso dê erro
    }
  }
}