extension NullableStringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
}

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
