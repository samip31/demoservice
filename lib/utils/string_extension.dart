extension StringExtension on String {
  replaceWhiteSpaces() {
    return replaceAll(RegExp(r"\s+"), " ");
  }

  toUppercaseFirstLetter() {
    return "${split("")[0].toUpperCase()}${substring(1)}";
  }
}
