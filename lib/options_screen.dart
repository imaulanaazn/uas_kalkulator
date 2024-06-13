import 'package:flutter/material.dart';
import 'themes.dart';

class OptionsScreen extends StatefulWidget {
  final bool isDarkMode;
  final bool isVibrationOn;
  final String selectedTheme;

  const OptionsScreen({
    super.key,
    required this.isDarkMode,
    required this.isVibrationOn,
    required this.selectedTheme,
  });

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  late bool isDarkMode;
  late bool isVibrationOn;
  late String selectedTheme;
  List<String> languages = ['English', 'Spanish', 'French', 'German'];
  String selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    isVibrationOn = widget.isVibrationOn;
    selectedTheme = widget.selectedTheme;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const DefaultTextStyle(
            style: TextStyle(color: Colors.white, fontSize: 16),
            child: Text('Options'),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.transparent,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: 'Options'),
              Tab(text: 'Themes'),
              Tab(text: 'About'),
            ],
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, {
                'isDarkMode': isDarkMode,
                'isVibrationOn': isVibrationOn,
                'selectedTheme': selectedTheme,
              });
            },
          ),
        ),
        body: Container(
          color: Colors.black87,
          child: TabBarView(
            children: [
              OptionsTab(
                isDarkMode: isDarkMode,
                isVibrationOn: isVibrationOn,
                selectedLanguage: selectedLanguage,
                languages: languages,
                onDarkModeChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                onVibrationChanged: (value) {
                  setState(() {
                    isVibrationOn = value;
                  });
                },
                onLanguageChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
              ),
              ThemesTab(
                selectedTheme: selectedTheme,
                onThemeChanged: (value) {
                  setState(() {
                    selectedTheme = value;
                  });
                },
              ),
              const AboutTab(),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionsTab extends StatelessWidget {
  final bool isDarkMode;
  final bool isVibrationOn;
  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<bool> onVibrationChanged;
  final ValueChanged<String?> onLanguageChanged;

  const OptionsTab({
    super.key,
    required this.isDarkMode,
    required this.isVibrationOn,
    required this.selectedLanguage,
    required this.languages,
    required this.onDarkModeChanged,
    required this.onVibrationChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title:
                const Text('Dark Mode', style: TextStyle(color: Colors.white)),
            value: isDarkMode,
            onChanged: onDarkModeChanged,
          ),
          SwitchListTile(
            title:
                const Text('Vibrations', style: TextStyle(color: Colors.white)),
            value: isVibrationOn,
            onChanged: onVibrationChanged,
          ),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.black54,
            ),
            child: DropdownButtonFormField<String>(
              value: selectedLanguage,
              items: languages.map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language,
                      style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: onLanguageChanged,
              dropdownColor: const Color.fromARGB(255, 55, 55, 55),
              decoration: const InputDecoration(
                labelText: 'Language',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemesTab extends StatelessWidget {
  final String selectedTheme;
  final ValueChanged<String> onThemeChanged;

  const ThemesTab(
      {super.key, required this.selectedTheme, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: AppThemes.themes.keys.map((String theme) {
                final ThemeData themeData = AppThemes.themes[theme]!;

                return ListTile(
                  leading: Icon(
                    Icons.palette,
                    color: themeData.colorScheme.secondary,
                  ),
                  title: Text(
                    theme,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: selectedTheme == theme
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    onThemeChanged(theme);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 10),
          CalculatorPreview(selectedTheme: selectedTheme),
        ],
      ),
    );
  }
}

class CalculatorPreview extends StatelessWidget {
  final String selectedTheme;

  const CalculatorPreview({super.key, required this.selectedTheme});

  Color getBgColor(String text, ThemeData themeData) {
    if (text == "=") {
      return themeData.colorScheme.secondary;
    }
    if (["/", "*", "-", "+", "%", "(", ")"].contains(text)) {
      return themeData.colorScheme.tertiary;
    }
    return themeData.primaryColor;
  }

  Color getTextColor(String text, ThemeData themeData) {
    if (text == "=") {
      return themeData.colorScheme.onSecondary;
    }
    if (["/", "*", "-", "+", "%", "(", ")"].contains(text)) {
      return themeData.colorScheme.onTertiary;
    }
    return themeData.textTheme.bodyLarge?.color ?? Colors.white;
  }

  Widget CustomButton({
    required String text,
    required bool isVibrationOn,
    required ThemeData themeData,
  }) {
    return Expanded(
      flex: text == "=" ? 2 : 1,
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: getBgColor(text, themeData),
          borderRadius: const BorderRadius.all(
            Radius.circular(3),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getTextColor(text, themeData),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = AppThemes.themes[selectedTheme]!;

    return Theme(
      data: themeData,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomButton(text: "+", isVibrationOn: true, themeData: themeData),
          const SizedBox(width: 4),
          CustomButton(text: "1", isVibrationOn: true, themeData: themeData),
          const SizedBox(width: 4),
          CustomButton(text: "2", isVibrationOn: true, themeData: themeData),
          const SizedBox(width: 4),
          CustomButton(text: "3", isVibrationOn: true, themeData: themeData),
          const SizedBox(width: 4),
          CustomButton(text: "=", isVibrationOn: true, themeData: themeData),
        ],
      ),
    );
  }
}

class AboutTab extends StatelessWidget {
  const AboutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                "About",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: const Text(
              'Version',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              '1.09',
              style: TextStyle(fontSize: 12, color: Colors.white60),
            ),
            onTap: () {},
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.blue),
            title: const Text(
              'For more information, please visit',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'FOTHONG.COM',
              style: TextStyle(fontSize: 12, color: Colors.white60),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
