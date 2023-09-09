import 'package:flutter/material.dart';

Future pushScreen(BuildContext context, String route,
    {Object? arguments}) async {
  return await Navigator.of(context).pushNamed(
    route,
    arguments: arguments,
  );
}

Future moveToScreen(BuildContext context, String routeName,
    {Object? arguments}) async {
  return await Navigator.of(context).pushNamedAndRemoveUntil(
    routeName,
    arguments: arguments,
    (route) => false,
  );
}
