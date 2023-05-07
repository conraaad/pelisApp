
import 'package:flutter/material.dart';

class AppContext {
  static BuildContext? _context;

  static void setContext(BuildContext context) {
    _context = context;
  }

  static BuildContext getContext() {
    return _context!;
  }
}
