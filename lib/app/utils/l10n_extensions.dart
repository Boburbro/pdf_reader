import 'package:flutter/material.dart';
import 'package:pdf_reader/generated/l10n/app_localizations.dart';

extension LocalizedContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
