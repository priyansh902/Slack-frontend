class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }
  
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) return null;
    final urlRegex = RegExp(r'^(http|https)://[\w-]+(\.[\w-]+)+[/#?]?.*$');
    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL (include http:// or https://)';
    }
    return null;
  }
  
  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length > 500) {
      return 'Bio cannot exceed 500 characters';
    }
    return null;
  }
  
  static String? validateProjectTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Project title is required';
    }
    if (value.length > 100) {
      return 'Title cannot exceed 100 characters';
    }
    return null;
  }
}