import 'package:get/get_instance/src/bindings_interface.dart';

import 'home_controller.dart';


class HomeBinding{
  static List<Bindings> bindings =  [
    BindingsBuilder.put(() => HomeController()),
  ];
}