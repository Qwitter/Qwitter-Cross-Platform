import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qwitter_flutter_app/providers/selected_languages_provider.dart';
import 'package:qwitter_flutter_app/screens/authentication/signup/create_account_screen.dart';

class SelectLanguagesScreen extends ConsumerStatefulWidget {
  const SelectLanguagesScreen({super.key});
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
  ConsumerState<SelectLanguagesScreen> createState() =>
      _SelectLanguagesScreenState();
}

class _SelectLanguagesScreenState extends ConsumerState<SelectLanguagesScreen> {
  List<String> filteredLanguages = [];

  // Controller for the search input
  TextEditingController searchController = TextEditingController();

  List<bool> selectedLanguagesList = [];

  @override
  void initState() {
    super.initState();
    selectedLanguagesList = List.filled(widget.languages.length, false);
    filteredLanguages = widget.languages;
    searchController.addListener(() {
      filterLanguages(searchController.text);
    });
  }

  void filterLanguages(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredLanguages = widget.languages;
      } else {
        filteredLanguages = widget.languages
            .where((language) =>
                language.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedLanguages = ref.watch(languagesProvider);
    return WillPopScope(
      onWillPop: () async {
        ref.read(languagesProvider.notifier).clearLanguages();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(75),
          child: QwitterAppBar(
            showLogoOnly: true,
          ),
        ),
        body: Container(
          width: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Text(
                  'Select your language(s)',
                  style: TextStyle(
                    fontSize: 28,
                    color: Color.fromARGB(255, 222, 222, 222),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              const SliverToBoxAdapter(
                child: Text(
                  'Select the language(s) you want to use to personalize your X experience.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 132, 132, 132),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 5)),
              SliverToBoxAdapter(
                child: TextField(
                  controller: searchController,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    prefixIconColor: Colors.grey,
                    hintText: 'Search languages',
                    hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 93, 99, 106)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.search,
                        size: 32,
                      ),
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              BootstrapIcons.x_circle,
                              size: 20,
                              color: Color.fromARGB(255, 93, 99, 106),
                            ),
                            onPressed: () {
                              searchController.clear();
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
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => CheckboxListTile(
                    title: Text(
                      filteredLanguages[index],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 222, 222, 222),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    value: selectedLanguagesList[
                        widget.languages.indexOf(filteredLanguages[index])],
                    onChanged: (value) {
                      setState(() {
                        selectedLanguagesList[widget.languages
                            .indexOf(filteredLanguages[index])] = value!;
                      });
                      ref
                          .read(languagesProvider.notifier)
                          .toggleLanguage(filteredLanguages[index]);
                    },
                    side: MaterialStateBorderSide.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return const BorderSide(width: 0, color: Colors.blue);
                        }
                        return const BorderSide(
                            width: 1.5, color: Colors.white);
                      },
                    ),
                    activeColor: Colors.blue,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.trailing,
                  ),
                  childCount: filteredLanguages.length,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: QwitterNextBar(
            buttonFunction: selectedLanguages.isEmpty
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountScreen(),
                      ),
                    );
                  }),
      ),
    );
  }
}
