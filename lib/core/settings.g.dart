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

extension TaperForInsertion on TaperNamespace {
  _VersionedTapersForInsertion forInsertion() => _VersionedTapersForInsertion();
}

class _VersionedTapersForInsertion {
  Taper<Insertion> get v0 => _TaperForV0Insertion();
}

class _TaperForV0Insertion extends BytesTaper<Insertion> {
  @override
  List<int> toBytes(Insertion insertion) {
    final index =
        [Insertion.atTheBeginning, Insertion.atTheEnd].indexOf(insertion);
    return [index];
  }

  @override
  Insertion fromBytes(List<int> bytes) {
    return [Insertion.atTheBeginning, Insertion.atTheEnd][bytes.first];
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
  Reference<bool> get showSuggestions => child('showSuggestions');
  Reference<bool> get showSmartCompose => child('showSmartCompose');
  Reference<bool> get useSmartInsertion => child('useSmartInsertion');
  Reference<Insertion> get defaultInsertion => child('defaultInsertion');
}
