import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:talker/talker.dart';

class CrashlitycsTalkerObserver extends TalkerObserver {

  final FirebaseCrashlytics crashlytics;

  const CrashlitycsTalkerObserver({required this.crashlytics,});

  @override
  void onLog(TalkerData log) {
    crashlytics.log(log.generateTextMessage());
  }

  @override
  void onError(err) {
    crashlytics.recordError(
      err.error,
      err.stackTrace,
      reason: err.message,
    );
  }

  @override
  void onException(err) {
    crashlytics.recordError(
      err.exception,
      err.stackTrace,
      reason: err.message,
    );
  }
}
