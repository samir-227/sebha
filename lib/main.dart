import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/sebha/presentation/pages/sebha_screen.dart';
import 'features/sebha/presentation/state/sebha_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPreferences.getInstance();
  runApp(const SebhaApp());
}


class SebhaApp extends StatelessWidget {
  const SebhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SebhaCubit()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, themeController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Seb7a',
            theme: buildLightTheme(),
            darkTheme: buildDarkTheme(),
            themeMode: themeController.themeMode,
            home: const SebhaScreen(),
          );
        },
      ),
    );
  }
}
