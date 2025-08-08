import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

const String CURRENT_POSITION = "current_position";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<void> setCurrentPosition(String imdbId, int position) async {
    final jsonString = _sharedPreferences.getString(CURRENT_POSITION);
    List<Map<String, dynamic>> currentList = [];

    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      currentList = decoded.cast<Map<String, dynamic>>();
    }

    // Check if videoId already exists and update
    bool found = false;
    for (var map in currentList) {
      if (map.containsKey(imdbId.toString())) {
        map[imdbId.toString()] = position;
        found = true;
        break;
      }
    }

    // If not found, insert new
    if (!found) {
      currentList.add({imdbId.toString(): position});
    }

    await _sharedPreferences.setString(CURRENT_POSITION, jsonEncode(currentList));
  }


  Duration getCurrentPositionById(String imdbId) {
    final String? jsonString = _sharedPreferences.getString(CURRENT_POSITION);
    if (jsonString == null || jsonString.isEmpty) return Duration.zero;

    final List<dynamic> decodedList = jsonDecode(jsonString);

    for (final item in decodedList) {
      final map = Map<String, dynamic>.from(item);
      if (map.containsKey(imdbId.toString())) {
        final positionInMillis = map[imdbId.toString()];
        if (positionInMillis is int) {
          return Duration(milliseconds: positionInMillis);
        }
      }
    }

    return Duration.zero;
  }

}
