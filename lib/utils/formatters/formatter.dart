import 'package:intl/intl.dart';

class TFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_US', symbol: "\$").format(amount);
  }

  static String formatPhoneNumber(String number) {
    // format number is (076) 456 7896
    if (number.length == 10) {
      return '(${number.substring(0, 3)}) (${number.substring(3, 6)}) (${number.substring(6)})';
    } else if (number.length == 11) {
      return '(${number.substring(0, 4)}) (${number.substring(4, 7)}) (${number.substring(7)})';
    }
    // add more custom phone number length for logics
    return number;
  }

  static String internationalFormatPhoneNumber(String number) {
    // remove the non digits characters
    var digitsOnly = number.replaceAll(RegExp(r'\D'), '');

    // get the country code
    String countryCode = '+${digitsOnly.substring(0, 2)}';
    digitsOnly = digitsOnly.substring(2);

    // add the remaining digits with proper formatting
    final formatNumber = StringBuffer();
    formatNumber.write('($countryCode) ');
    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 2;
      if (i == 0 && countryCode == '+1') {
        groupLength = 3;
      }
      int end = i * groupLength;
      formatNumber.write(digitsOnly.substring(i, end));

      if (end < digitsOnly.length) {
        formatNumber.write(' ');
      }
      i = end;
    }
    return formatNumber.toString();
  }
}