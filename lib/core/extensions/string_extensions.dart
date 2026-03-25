extension StringExtensions on String {
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }
  
  bool get isValidUrl {
    final urlRegex = RegExp(r'^(http|https)://[\w-]+(\.[\w-]+)+[/#?]?.*$');
    return urlRegex.hasMatch(this);
  }
  
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
  
  String get truncate {
    if (length <= 100) return this;
    return '${substring(0, 100)}...';
  }
  
  List<String> get toSkillsList {
    if (isEmpty) return [];
    return split(',').map((s) => s.trim()).toList();
  }
}