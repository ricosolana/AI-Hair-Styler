import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_project_hair_ai/preferences_provider.dart';

// Code borrowed from https://pub.dev/packages/app_tutorial/example

const String tutorialCompletedPrefKey = 'tutorial-completed';

void setTutorialCompletedPref(BuildContext context, bool isCompleted) {
  Provider.of<PreferencesProvider>(context, listen: false)
      .set(tutorialCompletedPrefKey, isCompleted);
}

class TutorialItemContent extends StatelessWidget {
  const TutorialItemContent({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10.0),
              Text(
                content,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    // TODO determine whether this calls completer handler
                    onPressed: () {
                      Tutorial.skipAll(context);
                      setTutorialCompletedPref(context, true);
                    },
                    child: const Text(
                      'Skip All',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const TextButton(
                    onPressed: null,
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
