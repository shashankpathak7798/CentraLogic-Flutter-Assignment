
import 'package:assignment_1/dashboard/screens/mobile/ViewMobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/window_controller/window_controller_bloc.dart';
import '../desktop/ViewDesktop.dart';

class ScreenHomeScreen extends StatelessWidget {
  const ScreenHomeScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).size.width > 400
          ? BlocProvider(create: (context) => WindowControllerBloc(), child: ViewDesktop(),)
          : BlocProvider(create: (context) => WindowControllerBloc(), child: ViewMobile(),),
    );
  }

}
