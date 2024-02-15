import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/search/search.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/generated/assets.gen.dart';

class ExploreControls extends HookWidget {
  const ExploreControls({super.key});
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> focused = useState(false);

    return Row(
      children: <Widget>[
        Expanded(
          child: Search(
            onTextChanged: (String st) {},
          ),
        ),
        if (!focused.value)
          Button.icon(
            type: ButtonType.outlined,
            size: 40.0.s,
            onPressed: () {},
            icon: ButtonIcon(Assets.images.icons.iconLoginApplelogo.path),
          ),
        Button.icon(
          type: ButtonType.outlined,
          size: 40.0.s,
          onPressed: () {},
          icon: ButtonIcon(Assets.images.icons.iconLoginApplelogo.path),
        ),
      ],
    );
  }
}
