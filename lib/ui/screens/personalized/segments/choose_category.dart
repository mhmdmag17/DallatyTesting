part of '../personalized_property_screen.dart';

class CategoryInterestChoose extends StatefulWidget {
  const CategoryInterestChoose({
    required this.controller,
    required this.onInteraction,
    required this.type,
    required this.onClearFilter,
    super.key,
  });
  final PageController controller;
  final VoidCallback onClearFilter;
  final PersonalizedVisitType type;
  final Function(List<int> selectedCategoryId) onInteraction;

  @override
  State<CategoryInterestChoose> createState() => _CategoryInterestChooseState();
}

class _CategoryInterestChooseState extends State<CategoryInterestChoose>
    with AutomaticKeepAliveClientMixin {
  List<int> selectedCategoryId = personalizedInterestSettings.categoryIds;

  @override
  Widget build(BuildContext context) {
    final isFirstTime = widget.type == PersonalizedVisitType.FirstTime;
    super.build(context);
    return Scaffold(
      appBar: UiUtils.buildAppBar(
        context,
        showBackButton: true,
        title: 'chooseYourInterest'.translate(context),
        actions: [
          if (!isFirstTime && selectedCategoryId.isNotEmpty)
            GestureDetector(
              onTap: () {
                widget.onClearFilter.call();
              },
              child: Container(
                margin: const EdgeInsetsDirectional.only(end: 18),
                child: Text('clear'.translate(context))
                    .color(context.color.inverseSurface)
                    .size(16)
                    .underline()
                    .bold(),
              ),
            ),
          if (isFirstTime)
            GestureDetector(
              onTap: () {
                HelperUtils.killPreviousPages(
                  context,
                  Routes.main,
                  {'from': 'login'},
                );
              },
              child: Chip(
                label: Text('skip'.translate(context))
                    .color(context.color.buttonColor),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          const SizedBox(
            height: 25,
          ),
          Wrap(
            children: List.generate(
                context.watch<FetchCategoryCubit>().getCategories().length,
                (index) {
              final categorie =
                  context.watch<FetchCategoryCubit>().getCategories()[index];
              final isSelected = selectedCategoryId
                  .contains(int.parse(categorie.id!.toString()));
              return Padding(
                padding: const EdgeInsets.all(3),
                child: GestureDetector(
                  onTap: () {
                    selectedCategoryId
                        .addOrRemove(int.parse(categorie.id!.toString()));
                    widget.onInteraction.call(selectedCategoryId);
                    setState(() {});
                  },
                  child: Chip(
                    shape: StadiumBorder(
                      side: BorderSide(color: context.color.borderColor),
                    ),
                    backgroundColor: isSelected
                        ? context.color.tertiaryColor
                        : context.color.secondaryColor,
                    padding: const EdgeInsets.all(5),
                    label: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(categorie.category.toString()).color(
                        isSelected
                            ? context.color.buttonColor
                            : context.color.textColorDark,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
