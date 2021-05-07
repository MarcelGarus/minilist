import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:basics/basics.dart';
import 'package:chest_flutter/chest_flutter.dart';

import '../i18n.dart';
import 'list.dart';
import 'utils.dart';

part 'suggestion_engine.g.dart';

@tape({
  v0: {#scores, #lastDecay},
})
class RememberState {
  final Map<String, double> scores;
  final DateTime lastDecay;

  RememberState({required this.scores, required this.lastDecay});
  factory RememberState.reset() {
    final itemsList = Translation.forLocale(ui.window.locale).defaultItems;
    final itemsToScore = <String, double>{};
    for (var i = 0; i < itemsList.length; i++) {
      itemsToScore[itemsList[i]] = pow(0.9, i).toDouble();
    }

    return RememberState(scores: itemsToScore, lastDecay: DateTime.now());
  }

  String toDebugString() {
    final buffer = StringBuffer('RememberState(\n');
    for (final entry in scores.entries) {
      buffer.write('  ${entry.key.toDebugString()}: ${entry.value},\n');
    }
    buffer.write(')');
    return buffer.toString();
  }

  dynamic toJson() {
    return {
      'scores': scores,
      'lastDecay': lastDecay.millisecondsSinceEpoch,
    };
  }

  static RememberState fromJson(dynamic data) {
    return RememberState(
      scores: (data['scores'] as Map<dynamic, dynamic>).cast<String, double>(),
      lastDecay: DateTime.fromMillisecondsSinceEpoch(data['lastDecay']),
    );
  }
}

final suggestionEngine = _SuggestionEngine();

class _SuggestionEngine {
  /// Map from items to scores.
  final state = Chest<RememberState>(
    'rememberState',
    ifNew: () => RememberState.reset(),
  );

  Future<void> initialize() async {
    await state.open();
    final durationSinceDecay = DateTime.now() - state.lastDecay.value;
    if (durationSinceDecay > 1.hours) {
      final daysSinceDecay =
          durationSinceDecay.inMilliseconds / 1000 / 60 / 60 / 24;
      state.scores.update((it) {
        return it.map((item, score) {
          return MapEntry(item, score * pow(0.95, daysSinceDecay));
        });
      });
    }
  }

  double scoreOf(String item) =>
      state.scores[item].exists ? state.scores[item].value : 0;

  void add(String item) {
    if (state.scores[item].exists) {
      state.scores[item].value += 1;
    } else {
      state.scores[item].value = 1;
      final scores = state.scores.value;
      if (scores.length > 100) {
        state.scores.mutate((it) {
          // The bang succeeds because we know the `scores` are not empty.
          it.remove(scores.entries.minBy((entry) => entry.value)!.key);
        });
      }
    }
  }

  void remove(String item) {
    state.scores.mutate((it) => it.remove(item));
  }

  Iterable<String> get allSuggestions {
    return state.scores.value.entries
        .toList()
        .sortedCopyBy((it) => -it.value)
        .map((it) => it.key);
  }

  Iterable<String> get suggestionsNotInList {
    final items = list.items.value.toSet();
    return allSuggestions.where((it) => !items.contains(it));
  }

  String? suggestionFor(String prefix) {
    if (prefix.isEmpty) return null;
    return suggestionsNotInList
        .where((it) => it.startsWith(prefix) && it.length > prefix.length)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
  }

  String export() {
    return json.encode({
      'state': state.value.scores,
      'lastDecay': state.value.lastDecay.millisecondsSinceEpoch,
    });
  }

  void import(RememberState state) => this.state.value = state;
}
