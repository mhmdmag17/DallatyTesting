import 'dart:async';

import 'package:ebroker/data/model/project_model.dart';
import 'package:ebroker/data/repositories/project_repository.dart';
import 'package:ebroker/data/repositories/system_repository.dart';
import 'package:ebroker/exports/main_export.dart';
import 'package:flutter/material.dart';

class ProjectHorizontalCard extends StatelessWidget {
  const ProjectHorizontalCard({
    required this.project,
    super.key,
    this.useRow,
    this.addBottom,
    this.additionalHeight,
    this.additionalImageWidth,
  });
  final ProjectModel project;
  final List<Widget>? addBottom;
  final double? additionalHeight;
  final bool? useRow;
  final double? additionalImageWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      child: GestureDetector(
        onTap: () async {
          try {
            GuestChecker.check(
              onNotGuest: () async {
                unawaited(Widgets.showLoader(context));
                final systemRepository = SystemRepository();
                final settings = await systemRepository.fetchSystemSettings(
                  isAnonymouse: false,
                );
                if (project.addedBy.toString() == HiveUtils.getUserId()) {
                  try {
                    unawaited(Widgets.showLoader(context));
                    final projectRepository = ProjectRepository();
                    final projectDetails = await projectRepository
                        .getProjectDetails(id: project.id!);
                    Future.delayed(
                      Duration.zero,
                      () {
                        Widgets.hideLoder(context);
                        HelperUtils.goToNextPage(
                          Routes.projectDetailsScreen,
                          context,
                          false,
                          args: {
                            'project': projectDetails,
                          },
                        );
                      },
                    );
                  } catch (e) {
                    Widgets.hideLoder(context);
                  }
                } else if (project.addedBy.toString() !=
                        HiveUtils.getUserId() &&
                    settings['data']['is_premium'] == true) {
                  try {
                    unawaited(Widgets.showLoader(context));
                    final projectRepository = ProjectRepository();
                    final projectDetails = await projectRepository
                        .getProjectDetails(id: project.id!);
                    Future.delayed(
                      Duration.zero,
                      () {
                        Widgets.hideLoder(context);
                        HelperUtils.goToNextPage(
                          Routes.projectDetailsScreen,
                          context,
                          false,
                          args: {
                            'project': projectDetails,
                          },
                        );
                      },
                    );
                  } catch (e) {
                    Widgets.hideLoder(context);
                  }
                } else {
                  await UiUtils.showBlurredDialoge(
                    context,
                    dialoge: BlurredDialogBox(
                      title: 'Subscription needed',
                      isAcceptContainesPush: true,
                      onAccept: () async {
                        await Navigator.popAndPushNamed(
                          context,
                          Routes.subscriptionPackageListRoute,
                          arguments: {'from': 'home'},
                        );
                      },
                      content: Text(
                        'subscribeToUseThisFeature'.translate(context),
                      ),
                    ),
                  );
                  Widgets.hideLoder(context);
                }
                Widgets.hideLoder(context);
              },
            );
            Widgets.hideLoder(context);
          } catch (e) {
            Widgets.hideLoder(context);
          } finally {
            Widgets.hideLoder(context);
          }
        },
        child: Container(
          height: addBottom == null ? 115 : (115 + (additionalHeight ?? 0)),
          decoration: BoxDecoration(
            border: Border.all(width: 1.5, color: context.color.borderColor),
            color: context.color.secondaryColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Stack(
                                children: [
                                  UiUtils.getImage(
                                    project.image ?? '',
                                    height: 111,
                                    width: 100 + (additionalImageWidth ?? 0),
                                    fit: BoxFit.cover,
                                  ),
                                  // Text(property.promoted.toString()),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                              left: 12,
                              bottom: 5,
                              right: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    UiUtils.imageType(
                                      project.category!.image ?? '',
                                      width: 18,
                                      height: 18,
                                      color: Constant.adaptThemeColorSvg
                                          ? context.color.tertiaryColor
                                          : null,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(project.category!.category!)
                                          .setMaxLines(lines: 1)
                                          .size(
                                            context.font.small.rf(context),
                                          )
                                          .bold(
                                            weight: FontWeight.w400,
                                          )
                                          .color(
                                            context.color.textLightColor,
                                          ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 19,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        color: context.color.buttonColor
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        child: Center(
                                          child: Text(
                                            project.type!.translate(context),
                                          )
                                              .color(
                                                context.color.textColorDark,
                                              )
                                              .bold()
                                              .size(context.font.smaller),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      project.title!.firstUpperCase(),
                                    )
                                        .setMaxLines(lines: 1)
                                        .size(context.font.large)
                                        .color(context.color.textColorDark),
                                    Text(
                                      project.description!.firstUpperCase(),
                                    )
                                        .setMaxLines(lines: 1)
                                        .size(context.font.small)
                                        .color(
                                          context.color.textColorDark
                                              .withOpacity(0.80),
                                        ),
                                  ],
                                ),
                                if (project.city != '')
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 16,
                                        color: context.color.textLightColor,
                                      ),
                                      Expanded(
                                        child: Text(project.city?.trim() ?? '')
                                            .setMaxLines(lines: 1)
                                            .color(
                                              context.color.textLightColor,
                                            ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (useRow == false || useRow == null) ...addBottom ?? [],

                  if (useRow == true) ...{Row(children: addBottom ?? [])},

                  // ...addBottom ?? []
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
