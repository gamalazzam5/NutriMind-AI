import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

/// Holds the app's active [Locale] and persists the user's choice.
class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._prefs) : super(_readLocale(_prefs));

  final SharedPreferences _prefs;

  static const _localeKey = 'app_locale';

  static Locale _readLocale(SharedPreferences prefs) {
    final code = prefs.getString(_localeKey);
    return AppLocalizations.supportedLocales.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => AppLocalizations.supportedLocales.first,
    );
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode == state.languageCode) return;
    emit(locale);
    await _prefs.setString(_localeKey, locale.languageCode);
  }
}
