// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TapeGenerator
// **************************************************************************

extension TaperForThemeMode on TaperNamespace {
  _VersionedTapersForThemeMode forThemeMode() => _VersionedTapersForThemeMode();
}

class _VersionedTapersForThemeMode {
  Taper<ThemeMode> get v0 => _TaperForV0ThemeMode();
}

class _TaperForV0ThemeMode extends BytesTaper<ThemeMode> {
  @override
  List<int> toBytes(ThemeMode thememode) {
    final index = [
      ThemeMode.black,
      ThemeMode.dark,
      ThemeMode.light,
      ThemeMode.systemLightBlack,
      ThemeMode.systemLightDark
    ].indexOf(thememode);
    return [index];
  }

  @override
  ThemeMode fromBytes(List<int> bytes) {
    return [
      ThemeMode.black,
      ThemeMode.dark,
      ThemeMode.light,
      ThemeMode.systemLightBlack,
      ThemeMode.systemLightDark
    ][bytes.first];
  }
}

extension TaperForSettings on TaperNamespace {
  _VersionedTapersForSettings forSettings() => _VersionedTapersForSettings();
}

class _VersionedTapersForSettings {
  Taper<Settings> get v0 => _TaperForV0Settings();
}

class _TaperForV0Settings extends MapTaper<Settings> {
  @override
  Map<Object?, Object?> toMap(Settings settings) {
    return {
      'theme': settings.theme,
    };
  }

  @override
  Settings fromMap(Map<Object?, Object?> map) {
    return Settings(
      theme: map['theme'] as ThemeMode,
    );
  }
}

extension ReferenceToSettings on Reference<Settings> {
  Reference<ThemeMode> get theme => child('theme');
}
