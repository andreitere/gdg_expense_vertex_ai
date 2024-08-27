import 'package:expense_ai_fe/api/api.dart';
import 'package:expense_ai_fe/constants/app_colors.dart';
import 'package:expense_ai_fe/pages/GroupsScreen.dart';
import 'package:expense_ai_fe/pages/LoginScreen.dart';
import 'package:expense_ai_fe/pages/ProfileScreen.dart';
import 'package:expense_ai_fe/state/AuthController.dart';
import 'package:expense_ai_fe/state/GroupsController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import 'pages/GroupDetails.dart';

void main() async {
  await GetStorage.init();
  Get.put(APIClient());
  final AuthController authCtrl = Get.put(AuthController());
  Get.put(GroupsController());
  await authCtrl.init();
  runApp(const MyApp());
}

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final AppBar? appBar;
  final bool showBottomNav;
  const BaseScaffold({super.key, required this.child, this.appBar, required this.showBottomNav});

  @override
  Widget build(BuildContext context) {
    final AuthController authCtrl = Get.put(AuthController());
    bool showNav = authCtrl.loggedIn.value;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar,
      body: child,
      bottomNavigationBar: showNav
          ? BottomNavigationBar(
              selectedItemColor: AppColors.lightBlue,
              items: [
                const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                const BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
                const BottomNavigationBarItem(icon: Icon(Icons.verified_user_outlined), label: 'Profile'),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    context.go('/');
                    break;
                  case 1:
                    context.go('/groups');
                    break;
                  case 2:
                    context.go('/profile');
                    break;
                }
              },
            )
          : null,
    );
  }
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          final Widget gdgSvg = SvgPicture.network(
            'https://res.cloudinary.com/startup-grind/image/upload/dpr_2.0,fl_sanitize/v1/gcs/platform-data-goog/contentbuilder/logo_dark_QmPdj9K.svg',
            semanticsLabel: 'GDG',
            placeholderBuilder: (BuildContext context) => Container(padding: const EdgeInsets.all(30.0), child: const CircularProgressIndicator()),
          );
          return BaseScaffold(
              showBottomNav: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "From Paper to JSON",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 50),
                    SizedBox(
                      width: 400,
                      child: gdgSvg,
                    ),
                  ],
                ),
              ));
        }),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const BaseScaffold(showBottomNav: false, child: LoginScreen());
      },
    ),
    GoRoute(
      path: '/groups',
      builder: (BuildContext context, GoRouterState state) {
        return const BaseScaffold(showBottomNav: false, child: GroupsScreen());
      },
    ),
    GoRoute(
      path: "/groups/:groupId/details",
      builder: (BuildContext context, GoRouterState state) {
        final groupId = int.tryParse(state.pathParameters["groupId"] ?? "") ?? 0;
        return BaseScaffold(
          showBottomNav: false,
          child: GroupDetails(
            groupId: groupId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (BuildContext context, GoRouterState state) {
        return const BaseScaffold(showBottomNav: false, child: ProfileScreen());
      },
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AuthController authCtrl = Get.find<AuthController>();
    return SafeArea(
      child: Obx(() {
        if (authCtrl.loggedIn.value == false) {
          return GetMaterialApp(home: BaseScaffold(showBottomNav: false, child: LoginScreen()), debugShowCheckedModeBanner: false,);
        }
        return GetMaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.darkBlue),
            useMaterial3: true,
          ),
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      }),
    );
  }
}
