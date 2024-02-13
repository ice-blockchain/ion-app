import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/modal_wrapper/modal_wrapper.dart';

class ScaffoldWithBottomSheet extends StatefulWidget {
  const ScaffoldWithBottomSheet({
    super.key,
    required this.builder,
    required this.child,
  });

  final Widget child;
  final Widget Function() builder;

  @override
  State<StatefulWidget> createState() => ScaffoldWithBottomSheetState();
}

class ScaffoldWithBottomSheetState extends State<ScaffoldWithBottomSheet> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => ModalWrapper(
            child: widget.child,
          ),
        ).then((_) {
          if (context.canPop()) {
            context.pop();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder();
  }
}
