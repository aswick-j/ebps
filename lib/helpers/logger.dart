import 'package:logger/logger.dart';

var logger = Logger(
    filter: DevelopmentFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 0,
      lineLength: 50,
      colors: true,
      printEmojis: false,
      printTime: false,
    ));
