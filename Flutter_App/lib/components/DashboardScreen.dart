import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memory_tagz/models/MemoryTag.dart';
import 'package:memory_tagz/components/Notify_button.dart';
import 'package:memory_tagz/components/animation_rect_tween.dart';
import 'package:memory_tagz/components/hero_dialog_route.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({required Key key, required this.lst})
      : super(key: key);
  final List<MemoryTag> lst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (lst != null)
            ? Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 230, 193, 114),
                          Color.fromARGB(255, 221, 194, 120),
                        ],
                        stops: [0.0, 1],
                      ),
                    ),
                  ),
                  SafeArea(
                    child: _TodoListContent(
                        // todos: fakeData,
                        memorytags: lst),
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: NotifyButton(),
                  )
                ],
              )
            : Container());
  }
}

/// {@template todo_list_content}
/// List of [Todo]s.
/// {@endtemplate}
class _TodoListContent extends StatelessWidget {
  _TodoListContent({Key? key, required this.memorytags}) : super(key: key);

  //final List<Todo> todos;
  final List<MemoryTag> memorytags;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 4 / 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      itemCount: memorytags.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        //final _todo = todos[index];
        final _tag = memorytags[index];
        return _MemoryCard(tag: _tag);
      },
    );
  }
}

/// {@template todo_card}
/// Card that display a [Todo]'s content.
///
/// On tap it opens a [HeroDialogRoute] with [_TodoPopupCard] as the content.
/// {@endtemplate}
class _MemoryCard extends StatelessWidget {
  /// {@macro todo_card}
  @override
  const _MemoryCard({Key? key, required this.tag}) : super(key: key);

  final MemoryTag tag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) => Center(
                child: _PopupCard(tag: tag),
              ),
            ),
          );
        },
        child: Container(
            child: Hero(
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          tag: tag.id,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: Material(
                  color: Color(0xFF1F2426),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        _CardTitle(title: tag.title),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          height: 18,
                          child: Text(
                            tag.description!,
                            style: TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image(
                                image: FileImage(File(
                                  tag.image.path,
                                )),
                                fit: BoxFit.contain,
                              )),
                        )
                      ],
                    ),
                  ))

              // if (todo.items != null) ...[
              //   const Divider(),
              //   //_TodoItemsBox(items: todo.items),
              // ]

              ),
        )));

    //       ),
    //     ),

    // );
  }
}

/// {@template todo_title}
/// Title of a [Todo].
/// {@endtemplate}
class _CardTitle extends StatelessWidget {
  /// {@macro todo_title}
  const _CardTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
    );
  }
}

/// {@template todo_popup_card}
/// Popup card to expand the content of a [Todo] card.
///
/// Activated from [_TodoCard].
/// {@endtemplate}
class _PopupCard extends StatelessWidget {
  _PopupCard({Key? key, required this.tag}) : super(key: key);
  // final Todo todo;
  final MemoryTag tag;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag.id,
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin, end: end);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xFF1F2426),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CardTitle(title: tag.title),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: Column(children: [
                        const TextField(
                          style: const TextStyle(color: Colors.white),
                          maxLines: 2,
                          cursorColor: Color.fromRGBO(255, 255, 255, 1),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(8),
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: 'Write a note...',
                              border: InputBorder.none),
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: FileImage(File(
                                tag.image.path,
                              )),
                              fit: BoxFit.fill,
                            ))
                      ]),
                    ),
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
