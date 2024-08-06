import 'package:get/get.dart';

import 'Screens/Home/home_binding.dart';
import 'Screens/Home/main_home_page.dart';


class AppRoutes {
  static List<GetPage> routes = [
    GetPage(
      name: HomeScreen.routeName,
      page: () =>  HomeScreen(),
      bindings: HomeBinding.bindings,
    ),

  ];
}
