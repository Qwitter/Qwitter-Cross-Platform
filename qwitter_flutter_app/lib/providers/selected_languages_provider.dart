import 'package:riverpod/riverpod.dart';

class SelectedLanguagesNotifier extends StateNotifier<List<String>> {
  SelectedLanguagesNotifier() : super([]);

  void addLanguage(String language) {
    state = [...state, language];
  }

  void removeLanguage(String language) {
    state = state.where((element) => element != language).toList();
  }

  void toggleLanguage(String language) {
    if (state.contains(language)) {
      removeLanguage(language);
    } else {
      addLanguage(language);
    }
  }

  void clearLanguages() {
    state = [];
  }
}

final languagesProvider =
    StateNotifierProvider<SelectedLanguagesNotifier, List<String>>((ref) {
  return SelectedLanguagesNotifier();
});
