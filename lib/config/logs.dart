import 'package:logger/web.dart';

class Logs {
  Logs._internal() {
    _logger = Logger(level: Level.trace);
  }

  late final Logger _logger;

  static final Logs _instance = Logs._internal();

  static Logger get p => _instance._logger;
}
