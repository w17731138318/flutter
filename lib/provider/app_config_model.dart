import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfigModel with ChangeNotifier {
  /// 夜间模式 0: 关闭 1: 开启 2: 随系统
  int _darkMode;

  static const Map<int, String> darkModeMap = {0: "关闭", 1: "开启", 2: "跟随系统"};

  static const String STORE_KEY = 'darkMode';

  SharedPreferences _prefs;

  int get darkMode => _darkMode;

  AppConfigModel() {
    _init();
  }

  void _init() async {
    this._prefs = await SharedPreferences.getInstance();
    int localMode = this._prefs.getInt(STORE_KEY);
    changeMode(localMode ?? 0);
    String themeMode = this._prefs.getString(STORE_KEY_THEME);
    changeThemeMode(themeMode ?? 'blue');
  }

  void changeMode(int darkMode) async {
    _darkMode = darkMode;
    notifyListeners();

    SharedPreferences prefs = this._prefs ?? SharedPreferences.getInstance();

    await prefs.setInt(STORE_KEY, darkMode);
  }

  Color _themeMode;

  static const Map<String, Color> themeModeMap = {
    'blueAccent': Colors.blueAccent,
    'blue': Colors.blue,
    'lightBlue': Colors.lightBlue,
    'lightBlueAccent': Colors.lightBlueAccent,
    'cyan': Colors.cyan,
    'deepPurple': Colors.deepPurple,
    'deepPurpleAccent': Colors.deepPurpleAccent,
    'purple': Colors.purple,
    'purpleAccent': Colors.purpleAccent,
    'pink': Colors.pink,
    'pinkAccent': Colors.pinkAccent,
    'red': Colors.red,
    'redAccent': Colors.redAccent,
    'deepOrange': Colors.deepOrange,
    'deepOrangeAccent': Colors.deepOrangeAccent,
    'orange': Colors.orange,
    'orangeAccent': Colors.orangeAccent,
    'amber': Colors.amber,
    'yellow': Colors.yellow,
    'green': Colors.green,
    'lightGreen': Colors.lightGreen,
    'lightGreenAccent': Colors.lightGreenAccent,
    'greenAccent': Colors.greenAccent,
  };

  static const String STORE_KEY_THEME = 'themeMode';

  Color get themeMode => _themeMode;
  Map<String, Color> get themeMap => themeModeMap;

  void changeThemeMode(String themeMode) async {
    _themeMode = themeModeMap[themeMode];
    notifyListeners();
    SharedPreferences prefs = this._prefs ?? SharedPreferences.getInstance();
    await prefs.setString(STORE_KEY_THEME, themeMode);
  }
}
