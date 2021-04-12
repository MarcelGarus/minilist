extension DebugString on String {
  String toDebugString() => '"$this"';
  String indent() => split('\n').map((line) => '  $line').joinLines();
}

extension DebugStringIterable on Iterable<String> {
  String joinLines() => join('\n');
}

extension DebugIterable<T> on Iterable<T> {
  String toDebugStringUsing(String Function(T) stringifier) {
    if (isEmpty) return '[]';
    final buffer = StringBuffer('[\n');
    for (final item in this) {
      buffer..write('${stringifier(item)},'.indent())..write('\n');
    }
    buffer.write(']');
    return buffer.toString();
  }
}

extension ListX on Iterable<String> {
  String toDebugString() => toDebugStringUsing((it) => it.toDebugString());
}
