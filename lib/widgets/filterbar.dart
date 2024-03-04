import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterBar extends StatelessWidget {
  final Function(String value) onChanged;
  const FilterBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(CupertinoIcons.search),
        hintText: appLocalizations.search,
      ),
      onChanged: onChanged,
    );
  }
}
