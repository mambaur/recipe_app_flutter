class TextFormat {
  static String slugToTitle(String slug) {
    List<String> listWords = slug.split('-');
    String result = listWords.join(' ');
    return result.toUpperCase();
  }
}
