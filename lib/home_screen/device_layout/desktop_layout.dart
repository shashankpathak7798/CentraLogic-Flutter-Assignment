import 'package:flutter/material.dart';

import '../ui_services.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Row(children: [
        /// call to function which builds the left side of the screen
        buildLeftView(size: size, containerWidth: size.width * 0.5, containerHeight: size.height,),
        /// call to function which builds the right side of the screen
        buildRightView(size: size, containerWidth: size.width * 0.5, containerHeight: size.height,),
      ],),
    );
  }


}
