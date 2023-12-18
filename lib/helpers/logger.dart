import 'package:logger/logger.dart';

var logger = Logger(
    printer: PrettyPrinter(
  methodCount: 0,
  errorMethodCount: 0,
  lineLength: 50,
  colors: true,
  printEmojis: false,
  printTime: false,
));
