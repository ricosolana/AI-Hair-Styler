import 'package:app_tutorial/app_tutorial.dart';
import 'package:flutter/material.dart';

// Code borrowed from https://pub.dev/packages/app_tutorial/example

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
                      //_MyHomePageState.markTutorialCompleted();
                    },
                    child: const Text(
                      'Skip onboarding',
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
