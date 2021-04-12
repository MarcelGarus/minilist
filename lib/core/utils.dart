extension StringX on String {
  String toDebugString() => '"$this"';
  String indent() => split('\n').map((line) => '  $line').joinLines();
}

extension IterableX on Iterable<String> {
  String joinLines() => join('\n');
}

extension ListX on Iterable<String> {
  String toDebugString() {
    if (isEmpty) return '[]';
    final buffer = StringBuffer('[\n');
    for (final item in this) {
      buffer.write('  ${item.toDebugString()},\n');
    }
    buffer.write(']');
    return buffer.toString();
  }
}
