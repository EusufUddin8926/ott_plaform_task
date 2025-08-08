import 'package:shared_preferences/shared_preferences.dart';

const String CURRENT_POSITION = "current_position";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<void> setCurrentPosition(Duration currentPosition) async {
    await _sharedPreferences.setInt(CURRENT_POSITION, currentPosition.inMilliseconds);
  }

  int getCurrentPosition() {
    return _sharedPreferences.getInt(CURRENT_POSITION) ?? 0;
  }
}

