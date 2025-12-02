import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String formatDouble({bool isKeep = false, bool isTwoDecimal = false}) {
    return NumberUtil.formatDouble(
      this,
      isKeep: isKeep,
      isTwoDecimal: isTwoDecimal,
    );
  }

  String formatDoubleV2({bool isKeep = false}) {
    return NumberUtil.formatDoubleV2(this, isKeep: isKeep);
  }

  String getIntComma() {
    var f = NumberFormat("###,###", "en_US");
    return f.format(int.parse('${floor()}'));
  }

  String getDecimal() {
    int length = 2;
    if (this == 0) {
      return '.00';
    }
    if (this < 1) {
      length = 6;
    }
    final number = formatDouble(isTwoDecimal: length == 2);
    if (number.contains('.')) {
      return '.${number.split('.')[1]}';
    }
    return '.00';
  }
}

extension NumExtensions on num {
  checkSmall() {
    if (abs() < 0.000001) {
      return 0;
    }
    return this;
  }
}

final class NumberUtil {
  static String formatDouble(
    double number, {
    bool isKeep = false,
    isTwoDecimal = false,
  }) {
    if (number.abs() < 0.000001) {
      return '0.00';
    }
    if (isKeep) {
      var f = NumberFormat("###,###.#############", "en_US");
      return f.format(number);
    }
    if (number.abs() >= 1 || number == 0.0 || number.isNaN || isTwoDecimal) {
      var f = NumberFormat("###,###.##", "en_US");
      String s = f.format(
        number.isNaN
            ? 0
            : (number > 0 && number < 3
                ? (number * 100).floor() / 100
                : number),
      );
      if (s.contains('.')) {
        final split = s.split('.');
        if (split[1].length == 2) {
          return s;
        }
        return '${s}0';
      } else {
        return s;
      }
    } else {
      var f = NumberFormat("###,###.######", "en_US");
      String s = f.format(number > 0.999999 && number < 1 ? 0.999999 : number);
      final split = s.split('.');
      if (split.length > 1 && split[1].length < 2) {
        s += '0';
      }
      return s;
    }
  }

  static String formatDoubleV2(double number, {bool isKeep = false}) {
    if (number.abs() < 0.000001) {
      return '0.00';
    }
    if (isKeep) {
      var f = NumberFormat("###,###.#############", "en_US");
      return f.format(number);
    }
    var f = NumberFormat("###,###.##", "en_US");
    if (number >= 1 || number <= -1 || number == 0) {
      // return number.toStringAsFixed(2);
      return f.format(number);
    } else {
      if ('$number'.length > 6) {
        var f = NumberFormat("###,###.##", "en_US");
        return f.format(number);
      }
      return '$number';
    }
  }

  // Format number 10000 to 10,000
  static String formatNumber(double number, {String separator = ','}) {
    return number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}$separator',
        );
  }

  static String formatTimer(int timer) {
    final minutes = timer ~/ 60;
    final seconds = timer % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String formatMin(String min) {
    return NumberUtil.formatDouble(double.tryParse(min) ?? 0);
  }
}
