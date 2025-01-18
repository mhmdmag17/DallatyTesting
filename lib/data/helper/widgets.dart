import 'package:ebroker/utils/Extensions/extensions.dart';
import 'package:ebroker/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Widgets {
  static bool isLoaderShowing = false;
  static Future<void> showLoader(BuildContext context) async {
    if (isLoaderShowing == true) return;
    FocusScope.of(context).unfocus();
    isLoaderShowing = true;
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.black.withOpacity(0),
          ),
          child: SafeArea(
            child: PopScope(
              canPop: false,
              child: Center(
                child: UiUtils.progress(
                  normalProgressColor: context.color.tertiaryColor,
                ),
              ),
              onPopInvokedWithResult: (didPop, _) async {
                if (didPop) return;
                return Future(
                  () => false,
                );
              },
            ),
          ),
        );
      },
    );
  }

  static void hideLoder(BuildContext context) {
    if (!isLoaderShowing) return;
    FocusScope.of(context).unfocus();
    isLoaderShowing = false;
    Navigator.of(context).pop();
  }

  static Center noDataFound(String errorMsg) {
    return Center(child: Text(errorMsg));
  }
}
