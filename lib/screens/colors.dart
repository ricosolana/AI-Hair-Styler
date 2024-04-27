@Deprecated('Use themePrefKey instead')
const oldDarkThemePrefKey = 'dark-theme';

const themeModePrefKey = 'theme-mode';

/*
class MyColorsPage extends StatefulWidget {
  const MyColorsPage({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<MyColorsPage> createState() => _MyColorsPageState();
}

class _MyColorsPageState extends State<MyColorsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
      ),
      home: MyHomePage(
        title: '',
        camera: widget.camera,
      ),
    );
  }
}

class ColorsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme & Primary Color Switcher'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 17),
          width: 450.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Theme'),
              ),
              ThemeSwitcher(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text('Primary Color'),
              ),
              PrimaryColorSwitcher(),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = Colors.blue;

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  set primaryColor(Color color) {
    _primaryColor = color;
    notifyListeners();
  }
}

class ThemeSwitcher extends StatefulWidget {
  @override
  _ThemeSwitcherState createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {
  void changeTheme(ThemeMode themeMode) {
    Provider.of<ThemeProvider>(context, listen: false).themeMode = themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (450.0 - (17 * 2) - (10 * 2)) / 3,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        crossAxisCount: 3,
        children: [
          buildThemeButton(
            context,
            ThemeMode.light,
            'Light',
            Icons.wb_sunny_outlined,
          ),
          buildThemeButton(context, ThemeMode.dark, 'Dark', Icons.brightness_3),
          buildThemeButton(context, ThemeMode.system, 'Auto', Icons.sync),
        ],
      ),
    );
  }

  Widget buildThemeButton(
    BuildContext context,
    ThemeMode themeMode,
    String title,
    IconData icon,
  ) {
    return GestureDetector(
      onTap: () {
        changeTheme(themeMode);
      },
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Theme.of(context).primaryColor),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(icon),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppTheme {
  ThemeMode mode;
  String title;
  IconData icon;

  AppTheme({
    required this.mode,
    required this.title,
    required this.icon,
  });
}

List<AppTheme> appThemes = [
  AppTheme(
    mode: ThemeMode.light,
    title: 'Light',
    icon: Icons.wb_sunny_outlined,
  ),
  AppTheme(
    mode: ThemeMode.dark,
    title: 'Dark',
    icon: Icons.brightness_3,
  ),
  AppTheme(
    mode: ThemeMode.system,
    title: 'Auto',
    icon: Icons.sync_outlined,
  ),
];

class PrimaryColorSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (450.0 - (17 * 2) - (10 * 2)) / 3,
      child: GridView.count(
        crossAxisCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        children: List.generate(
          5,
          (i) {
            return GestureDetector(
              onTap: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .primaryColor = const [
                  Color(0xffd23156),
                  Color(0xff16b9fd),
                  Color(0xff13d0c1),
                  Color(0xffe5672f),
                  Color(0xffb73d99),
                ][i];
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const [
                    Color(0xffd23156),
                    Color(0xff16b9fd),
                    Color(0xff13d0c1),
                    Color(0xffe5672f),
                    Color(0xffb73d99),
                  ][i],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
*/
