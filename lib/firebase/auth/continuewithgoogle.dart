import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContinueWithGoogle extends StatelessWidget {
  final VoidCallback onTap;
  const ContinueWithGoogle({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        child: Card(
          color: const Color.fromARGB(255, 32, 16, 91),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      'assets/google.png',
                      height: 30,
                    ),
                  ),
                  Expanded(
                    child: AutoSizeText(
                      AppLocalizations.of(context)!.continueWithGoogle,
                      style: const TextStyle(fontSize: 22, color: Colors.white),
                      maxLines: 1,
                      minFontSize: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
