import 'package:flutter/material.dart';

import 'animation_rect_tween.dart';
import 'hero_dialog_route.dart';

class NotifyButton extends StatelessWidget {
  const NotifyButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const _NotifyPopupCard();
          }));
        },
        child: Hero(
          tag: _heroNotify,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Color(0xFFef8354),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: const Icon(
              Icons.factory,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

/// Tag-value used for the Notify button.
const String _heroNotify = 'Get Set Go';

class _NotifyPopupCard extends StatelessWidget {
  const _NotifyPopupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Hero(
          tag: _heroNotify,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: Color(0xFFef8354),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text('Pull a Memory Tag!!',
                        style: TextStyle(
                          color: Color.fromARGB(221, 24, 23, 23),
                          fontSize: 25,
                        )),
                    ListTile()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
