import 'dart:math';

import 'package:basics/basics.dart';
import 'package:chest_flutter/chest_flutter.dart';

import 'data.dart';

part 'suggestion_engine.g.dart';

@tape({
  v0: {#scores, #lastDecay},
})
class RememberState {
  final Map<String, double> scores;
  final DateTime lastDecay;

  RememberState({required this.scores, required this.lastDecay});
  RememberState.reset()
      : this(
          scores: <String, double>{
            'Milk': 1.1,
            'Bread': 1.1,
            'Cheese': 1.1,
            'Honey': 1,
            'Beer': 1,
          },
          lastDecay: DateTime.now(),
        );
}

/// Map from items to scores.
final _state = Chest<RememberState>(
  'rememberState',
  ifNew: () => RememberState.reset(),
);

Future<void> initialize() async {
  await _state.open();
  final durationSinceDecay = DateTime.now() - _state.lastDecay.value;
  if (durationSinceDecay > 1.hours) {
    final daysSinceDecay =
        durationSinceDecay.inMilliseconds / 1000 / 60 / 60 / 24;
    _state.scores.value = _state.scores.value.map((item, score) {
      return MapEntry(item, score * pow(0.95, daysSinceDecay));
    });
  }
}

void add(String item) {
  if (_state.scores[item].exists) {
    _state.scores[item].value += 1;
  } else {
    _state.scores[item].value = 1;
    final scores = _state.scores.value;
    if (scores.length > 100) {
      _state.scores.value = scores
        ..remove(scores.entries.minBy((entry) => entry.value).orNull.key);
    }
  }
}

List<String> get relevantSuggestions {
  final items = list.items.value.toSet();
  return _state.scores.value.entries
      .where((it) => !items.contains(it.key))
      .toList()
      .sortedCopyBy((entry) => -entry.value)
      .map((entry) => entry.key)
      .toList();
}
