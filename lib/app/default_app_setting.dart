import 'dart:developer';
import 'dart:ui';

import 'package:ebroker/exports/main_export.dart';
import 'package:ebroker/utils/hive_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

AppSettingsDataModel fallbackSettingAppSettings = AppSettingsDataModel(
  appHomeScreen: AppIcons.fallbackHomeLogo,
  placeholderLogo: AppIcons.fallbackPlaceholderLogo,
  lightPrimary: primaryColor_,
  lightSecondary: secondaryColor_,
  lightTertiary: tertiaryColor_,
  darkPrimary: primaryColorDark,
  darkSecondary: secondaryColorDark,
  darkTertiary: tertiaryColorDark,
);

///DO not touch this
class LoadAppSettings {
  Future<void> load(initBox) async {
    try {
      try {
        if (initBox) {
          await HiveUtils.initBoxes();
        }
        final response = await Api.get(
          url: Api.apiGetAppSettings,
          queryParameters: {
            if (HiveUtils.getUserId() != null) 'user_id': HiveUtils.getUserId(),
          },
        );
        appSettings = AppSettingsDataModel.fromJson(response['data']);
        HiveUtils.setAppThemeSetting(response['data']);
        appSettings.placeholderLogo =
            await loadIconIfChange(appSettings.placeholderLogo!);
      } catch (e) {
        appSettings =
            AppSettingsDataModel.fromJson(HiveUtils.getAppThemeSettings());
        appSettings.placeholderLogo =
            await loadIconIfChange(appSettings.placeholderLogo!);
      }
    } catch (ee) {
      log('Issue in load default setting $ee');
    }
  }

  Future<String> loadIconIfChange(String svgURL) async {
    try {
      final box = Hive.box(HiveKeys.svgBox);
      final isAvailable = box.containsKey(svgURL);
      if (isAvailable) {
        return box.get(svgURL) as String;
      } else {
        final localSVG = await NetworkToLocalSvg().convert(svgURL);
        await box.put(svgURL, localSVG);

        return await Future.value(localSVG);
      }
    } catch (e) {
      rethrow;
    }
  }

  SvgPicture svg(
    String svg, {
    Color? color,
    double? width,
    double? height,
  }) {
    if (svg.startsWith('assets/svg/')) {
      return SvgPicture.asset(
        svg,
        colorFilter:
            color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
        width: width,
        height: height,
      );
    } else {
      return SvgPicture.string(
        svg,
        colorFilter:
            color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
        width: width,
        height: height,
      );
    }
  }

  dynamic loadHomeLogo(String homeLogoURL) {
    return UiUtils.getImage(
      appSettings.appHomeScreen ?? homeLogoURL,
      width: 90,
      height: 45,
      fit: BoxFit.scaleDown,
    );
  }
}
