import "package:logger/logger.dart";

abstract class IAppLogger {
  void e(String message, {dynamic error, StackTrace? stackTrace});
}

class AppLogger implements IAppLogger {
  final Logger logger;
  const AppLogger(this.logger);
  @override
  void e(String message, {error, StackTrace? stackTrace}) {
    logger.e(message, error: error, stackTrace: stackTrace);
  }
}
