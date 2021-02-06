// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_engine.dart';

// **************************************************************************
// TapeGenerator
// **************************************************************************

extension TaperForRememberState on TaperNamespace {
  _VersionedTapersForRememberState forRememberState() =>
      _VersionedTapersForRememberState();
}

class _VersionedTapersForRememberState {
  Taper<RememberState> get v0 => _TaperForV0RememberState();
}

class _TaperForV0RememberState extends MapTaper<RememberState> {
  @override
  Map<Object?, Object?> toMap(RememberState rememberstate) {
    return {
      'scores': rememberstate.scores,
      'lastDecay': rememberstate.lastDecay,
    };
  }

  @override
  RememberState fromMap(Map<Object?, Object?> map) {
    return RememberState(
      scores: map['scores'] as Map<String, double>,
      lastDecay: map['lastDecay'] as DateTime,
    );
  }
}

extension ReferenceToRememberState on Reference<RememberState> {
  Reference<Map<String, double>> get scores => child('scores');
  Reference<DateTime> get lastDecay => child('lastDecay');
}
