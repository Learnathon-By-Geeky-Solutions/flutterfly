import 'package:flutter/material.dart';
import '../../../../../../common/widget/getLogoWidget.dart';

class InitialAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onHelpPressed;

  const InitialAppbar({
    super.key,
    this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: false,
      leading: null,
      automaticallyImplyLeading: false,

      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo on the left
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: getLogoBasedOnTheme(context, width: 100, height: 100),
            ),
            // "Need Help?" button on the right
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton(
                onPressed: onHelpPressed,
                child: Text(
                  'Need help?',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}