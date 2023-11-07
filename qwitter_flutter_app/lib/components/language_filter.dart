import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/providers/selected_languages_provider.dart';

class LanguageFilter extends ConsumerStatefulWidget {
  const LanguageFilter({super.key});

  // List of languages
  final List<String> languages = const [
    'English - English',
    'Spanish - Español',
    'French - Français',
    'German - Deutsch',
    'Chinese - 中文',
    'Japanese - 日本語',
    'Korean - 한국어',
    'Russian - Русский',
    'Arabic - العربية',
    'Hindi - हिन्दी',
    'Portuguese - Português',
    'Turkish - Türkçe',
    'Vietnamese - Tiếng Việt',
    'Italian - Italiano',
    'Polish - Polski',
    'Dutch - Nederlands',
    'Swedish - Svenska',
    'Indonesian - Bahasa Indonesia',
    'Greek - Ελληνικά',
    'Thai - ไทย',
    'Romanian - Română',
    'Hungarian - Magyar',
    'Czech - Čeština',
    'Finnish - Suomi',
    'Norwegian - Norsk',
  ];

  @override
  _LanguageFilterState createState() => _LanguageFilterState();
}

class _LanguageFilterState extends ConsumerState<LanguageFilter> {
  // Filtered languages based on search query
  List<String> filtered_languages = [];

  // Controller for the search input
  TextEditingController search_controller = TextEditingController();

  List<bool> selected_languages = [];

  @override
  void initState() {
    super.initState();
    selected_languages = List.filled(widget.languages.length, false);
    filtered_languages = widget.languages;
    search_controller.addListener(() {
      filterLanguages(search_controller.text);
    });
  }

  void filterLanguages(String query) {
    setState(() {
      if (query.isEmpty) {
        filtered_languages = widget.languages;
      } else {
        filtered_languages = widget.languages
            .where((language) =>
                language.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        children: [
          TextField(
            controller: search_controller,
            cursorColor: Colors.blue,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              prefixIconColor: Colors.grey,
              hintText: 'Search languages',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 93, 99, 106)),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.search,
                  size: 32,
                ),
              ),
              suffixIcon: search_controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        BootstrapIcons.x_circle,
                        size: 20,
                        color: Color.fromARGB(255, 93, 99, 106),
                      ),
                      onPressed: () {
                        search_controller.clear();
                      },
                    )
                  : null,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  borderSide: BorderSide.none),
              fillColor: const Color.fromARGB(255, 32, 35, 40),
              filled: true,
            ),
            style: const TextStyle(color: Colors.white),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: filtered_languages.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(
                  filtered_languages[index],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 222, 222, 222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                value: selected_languages[
                    widget.languages.indexOf(filtered_languages[index])],
                onChanged: (value) {
                  setState(() {
                    selected_languages[widget.languages
                        .indexOf(filtered_languages[index])] = value!;
                  });
                  ref
                      .read(languagesProvider.notifier)
                      .toggleLanguage(filtered_languages[index]);
                },
                side: MaterialStateBorderSide.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.selected)) {
                      return const BorderSide(width: 0, color: Colors.blue);
                    }
                    return const BorderSide(width: 1.5, color: Colors.white);
                  },
                ),
                activeColor: Colors.blue,
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.trailing,
              );
            },
          ),
        ],
      ),
    );
  }
}
