import 'package:ebroker/app/routes.dart';
import 'package:ebroker/data/model/property_model.dart';
import 'package:ebroker/utils/AppIcon.dart';
import 'package:ebroker/utils/Extensions/extensions.dart';
import 'package:ebroker/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PropertyAddSuccess extends StatelessWidget {
  const PropertyAddSuccess({required this.model, super.key});

  final PropertyModel model;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        Navigator.popUntil(context, (Route route) => route.isFirst);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: context.color.backgroundColor,
        body: SizedBox(
          width: context.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppIcons.propertySubmittedc),
              const SizedBox(
                height: 32,
              ),
              Text('congratulations'.translate(context))
                  .size(context.font.extraLarge)
                  .bold()
                  .color(context.color.tertiaryColor),
              const SizedBox(
                height: 18,
              ),
              Text('submittedSuccess'.translate(context))
                  .centerAlign()
                  .size(context.font.larger),
              const SizedBox(
                height: 68,
              ),
              MaterialButton(
                elevation: 0,
                onPressed: () {
                  HelperUtils.goToNextPage(
                    Routes.propertyDetails,
                    context,
                    false,
                    args: {
                      'propertyData': model,
                      'fromMyProperty': false,
                      'fromSuccess': true,
                    },
                  );
                },
                height: 48,
                minWidth: MediaQuery.of(context).size.width * 0.6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: context.color.tertiaryColor),
                ),
                color: context.color.backgroundColor,
                child: Text(
                  'previewProperty'.translate(context),
                ).size(context.font.larger).color(context.color.tertiaryColor),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.popUntil(context, (Route route) => route.isFirst);
                },
                child: Text('backToHome'.translate(context))
                    .size(context.font.large),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
