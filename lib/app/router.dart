import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';

import '../pages/home/home_page.dart';
import '../pages/message/input_message_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: HomePage, initial: true),
    AutoRoute(page: InputMessagePage, path: '/input'),
  ],
)
class AppRouter extends _$AppRouter {}
