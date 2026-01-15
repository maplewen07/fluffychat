import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'package:fluffychat/utils/platform_infos.dart';

class WindowThemeManager with WidgetsBindingObserver {
  WindowThemeManager._();
  static final WindowThemeManager instance = WindowThemeManager._();

  ThemeMode _themeMode = ThemeMode.system;
  bool _inited = false;
  Brightness? _lastBrightness;

  /// 在 app 启动时调用一次
  void init() {
    if (!PlatformInfos.isWindows) return;
    if (_inited) return;
    _inited = true;
    WidgetsBinding.instance.addObserver(this);
  }

  /// 在 MaterialApp 主题模式变化时调用
  Future<void> setThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _applyCurrentBrightness();
  }

  /// 系统亮暗变化回调（ThemeMode.system 时实时触发）
  @override
  void didChangePlatformBrightness() {
    if (!PlatformInfos.isWindows) return;
    if (_themeMode != ThemeMode.system) return;
    _applyCurrentBrightness(); // 不 await 也行
  }

  Future<void> _applyCurrentBrightness() async {
    if (!PlatformInfos.isWindows) return;

    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    if (_lastBrightness == brightness) return;
    _lastBrightness = brightness;

    await windowManager.setBrightness(brightness);
  }

  void dispose() {
    if (!PlatformInfos.isWindows) return;
    if (_inited) {
      _inited = false;
      WidgetsBinding.instance.removeObserver(this);
    }
  }
}
