import 'package:ebroker/app/app_theme.dart';
import 'package:ebroker/data/cubits/property/fetch_my_properties_cubit.dart';
import 'package:ebroker/data/cubits/system/app_theme_cubit.dart';
import 'package:ebroker/ui/screens/proprties/Property%20tab/sell_rent_screen.dart';
import 'package:ebroker/utils/Extensions/extensions.dart';
import 'package:ebroker/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

int propertyScreenCurrentPage = 0;
ValueNotifier<Map> emptyCheckNotifier =
    ValueNotifier({'isSellEmpty': false, 'isRentEmpty': false});

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => MyPropertyState();
}

class MyPropertyState extends State<PropertiesScreen>
    with TickerProviderStateMixin {
  int offset = 0;
  int total = 0;
  late TabController _tabController;
  final PageController _pageController = PageController();
  bool isSellEmpty = false;
  bool isRentEmpty = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        propertyScreenCurrentPage = _tabController.index;
      });
      _pageController.jumpToPage(_tabController.index);
      cubitReference = context.read<FetchMyPropertiesCubit>();
      final tabIndex = _tabController.index;
      if (tabIndex == 0) {
        propertyType = 'sell';
      } else if (tabIndex == 1) {
        propertyType = 'rent';
      } else if (tabIndex == 2) {
        propertyType = 'sold';
      } else if (tabIndex == 3) {
        propertyType = 'rented';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                ? Brightness.light
                : Brightness.dark,
        statusBarColor: Theme.of(context).colorScheme.secondaryColor,
        statusBarBrightness:
            context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                ? Brightness.dark
                : Brightness.light,
        statusBarIconBrightness:
            context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: context.color.backgroundColor,
        appBar: UiUtils.buildAppBar(
          context,
          title: UiUtils.translate(context, 'myProperty'),
        ),
        body: ScrollConfiguration(
          behavior: RemoveGlow(),
          child: Column(
            children: [
              CustomTabBar(
                controller: _tabController,
                tabs: [
                  UiUtils.translate(context, 'sell'),
                  UiUtils.translate(context, 'rent'),
                  UiUtils.translate(context, 'sold'),
                  UiUtils.translate(context, 'rented'),
                ],
              ),
              Expanded(
                child: PageView(
                  onPageChanged: (value) {
                    _tabController.animateTo(value);
                  },
                  controller: _pageController,
                  children: [
                    BlocProvider(
                      create: (context) => FetchMyPropertiesCubit(),
                      child: const SellRentScreen(
                        type: 'sell',
                        key: Key('0'),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => FetchMyPropertiesCubit(),
                      child: const SellRentScreen(
                        type: 'rent',
                        key: Key('1'),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => FetchMyPropertiesCubit(),
                      child: const SellRentScreen(
                        type: 'sold',
                        key: Key('2'),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => FetchMyPropertiesCubit(),
                      child: const SellRentScreen(
                        type: 'rented',
                        key: Key('3'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    required this.controller,
    required this.tabs,
    this.isScrollable,
    super.key,
  });
  final TabController controller;
  final List<String> tabs;
  final bool? isScrollable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.color.tertiaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        isScrollable: isScrollable ?? false,
        labelPadding: EdgeInsets.zero,
        indicatorWeight: 0,
        controller: controller,
        indicator: BoxDecoration(
          color: context.color.tertiaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: context.color.primaryColor,
        unselectedLabelColor: context.color.textColorDark,
        tabs: List.generate(tabs.length, (index) {
          return Container(
            height: 35,
            margin: const EdgeInsets.symmetric(vertical: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: (index == controller.index) ||
                      (index == tabs.length - 1) ||
                      index == controller.index - 1
                  ? null
                  : Border(
                      right: BorderSide(
                        color: context.color.inverseSurface.withOpacity(0.2),
                      ),
                    ),
            ),
            child: Text(tabs[index]),
          );
        }),
      ),
    );
  }
}
