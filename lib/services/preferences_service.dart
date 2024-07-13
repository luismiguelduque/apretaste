import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();
  SharedPreferences? _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  set preferredMirror(String value){
    _prefs?.setString('preferred_mirror', value);
  }
  String get preferredMirror {
    return _prefs!.getString('preferred_mirror')??'';
  }

  set deepLink(String value){
    _prefs?.setString('deep_link', value);
  }
  String get deepLink {
    return _prefs!.getString('deep_link')??'';
  }

  void clear(){
    _prefs?.clear();
  }
}
