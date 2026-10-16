class HtmlHelper {
  /// Strips all HTML tags (like <p>, <br>, <blockquote>, etc.) from a given string.
  static String stripHtml(String htmlString) {
    if (htmlString.isEmpty) return '';
    final regExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(regExp, '').trim();
  }

  /// Parses an HTML list (e.g., <ul><li>...</li></ul>) into a list of plain strings.
  static List<String> parseHtmlList(String htmlString) {
    if (htmlString.isEmpty) return [];
    final regExp = RegExp(r'<li>(.*?)</li>', multiLine: true, caseSensitive: false);
    final matches = regExp.allMatches(htmlString);
    if (matches.isNotEmpty) {
      return matches.map((m) => stripHtml(m.group(1) ?? '')).toList();
    }
    return [stripHtml(htmlString)];
  }
}
