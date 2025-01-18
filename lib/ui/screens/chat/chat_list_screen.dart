import 'package:ebroker/exports/main_export.dart';
import 'package:ebroker/ui/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  static Route route(RouteSettings settings) {
    return BlurredRouter(
      builder: (context) {
        return const ChatListScreen();
      },
    );
  }

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    chatScreenController.addListener(() {
      if (chatScreenController.isEndReached()) {
        if (context.read<GetChatListCubit>().hasMoreData()) {
          context.read<GetChatListCubit>().loadMore();
        }
      }
    });
    if (context.read<GetChatListCubit>().state is! GetChatListSuccess) {
      context.read<GetChatListCubit>().fetch();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness:
            context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                ? Brightness.light
                : Brightness.dark,
        //
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
          title: UiUtils.translate(context, 'message'),
        ),
        body: BlocBuilder<GetChatListCubit, GetChatListState>(
          builder: (context, state) {
            if (state is GetChatListFailed) {
              if (state.error is NoInternetConnectionError) {
                return NoInternet(
                  onRetry: () {
                    context.read<GetChatListCubit>().fetch();
                  },
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<GetChatListCubit>().fetch();
                  },
                  color: context.color.tertiaryColor,
                  child: const SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Center(child: SomethingWentWrong())),
                );
              }
            }

            if (state is GetChatListInProgress) {
              return buildChatListLoadingShimmer();
            }
            if (state is GetChatListSuccess) {
              if (state.chatedUserList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<GetChatListCubit>().fetch();
                  },
                  color: context.color.tertiaryColor,
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          SvgPicture.asset(AppIcons.no_chat_found),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(UiUtils.translate(context, 'noChats'))
                              .color(context.color.tertiaryColor)
                              .size(context.font.extraLarge)
                              .bold(weight: FontWeight.w600),
                          const SizedBox(
                            height: 14,
                          ),
                          Text('startConversation'.translate(context))
                              .size(context.font.larger)
                              .centerAlign(),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<GetChatListCubit>().fetch();
                },
                color: context.color.tertiaryColor,
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: chatScreenController,
                            shrinkWrap: true,
                            itemCount: state.chatedUserList.length,
                            padding: const EdgeInsetsDirectional.all(16),
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              final chatedUser = state.chatedUserList[index];

                              return Padding(
                                padding: const EdgeInsets.only(top: 9),
                                child: ChatTile(
                                  id: chatedUser.userId.toString(),
                                  propertyId: chatedUser.propertyId.toString(),
                                  profilePicture: chatedUser.profile ?? '',
                                  userName: chatedUser.name ?? '',
                                  propertyPicture: chatedUser.titleImage ?? '',
                                  propertyName: chatedUser.title ?? '',
                                  pendingMessageCount: '5',
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 150,
                        ),
                        if (state.isLoadingMore) UiUtils.progress(),
                      ],
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<GetChatListCubit>().fetch();
              },
              color: context.color.tertiaryColor,
              child: const SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Center(child: SomethingWentWrong())),
            );
          },
        ),
      ),
    );
  }

  Widget buildChatListLoadingShimmer() {
    return ListView.builder(
      itemCount: 10,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.all(16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 9),
          child: SizedBox(
            height: 74,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.shimmerBaseColor,
                    highlightColor:
                        Theme.of(context).colorScheme.shimmerHighlightColor,
                    child: Stack(
                      children: [
                        const SizedBox(
                          width: 58,
                          height: 58,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 42,
                            height: 42,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(
                                width: 1.5,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        PositionedDirectional(
                          end: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: context.color.tertiaryColor,
                                // backgroundImage: NetworkImage(profilePicture),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomShimmer(
                        height: 10,
                        borderRadius: 5,
                        width: context.screenWidth * 0.53,
                      ),
                      CustomShimmer(
                        height: 10,
                        borderRadius: 5,
                        width: context.screenWidth * 0.3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class ChatTile extends StatelessWidget {
  const ChatTile({
    required this.profilePicture,
    required this.userName,
    required this.propertyPicture,
    required this.propertyName,
    required this.pendingMessageCount,
    required this.id,
    required this.propertyId,
    super.key,
  });

  final String profilePicture;
  final String userName;
  final String propertyPicture;
  final String propertyName;
  final String propertyId;
  final String pendingMessageCount;
  final String id;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          BlurredRouter(
            builder: (context) {
              currentlyChatingWith = id;
              currentlyChatPropertyId = propertyId;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => LoadChatMessagesCubit(),
                  ),
                  BlocProvider(
                    create: (context) => DeleteMessageCubit(),
                  ),
                ],
                child: Builder(
                  builder: (context) {
                    return ChatScreen(
                      profilePicture: profilePicture,
                      proeprtyTitle: propertyName,
                      userId: id,
                      propertyImage: propertyPicture,
                      userName: userName,
                      propertyId: propertyId,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
      child: AbsorbPointer(
        child: Container(
          height: 74,
          decoration: BoxDecoration(
            color: context.color.secondaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: context.color.borderColor,
              width: 1.5,
            ),
          ),
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    const SizedBox(
                      width: 58,
                      height: 58,
                    ),
                    Container(
                      width: 42,
                      height: 42,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: propertyPicture,
                        fit: BoxFit.cover,
                      ),
                    ),
                    PositionedDirectional(
                      end: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.color.secondaryColor,
                            width: 2,
                          ),
                        ),
                        child: profilePicture == ''
                            ? CircleAvatar(
                                radius: 15,
                                backgroundColor: context.color.tertiaryColor,
                                child: LoadAppSettings().svg(
                                  appSettings.placeholderLogo!,
                                  color: context.color.buttonColor,
                                ),
                              )
                            : CircleAvatar(
                                radius: 15,
                                backgroundColor: context.color.tertiaryColor,
                                backgroundImage: NetworkImage(profilePicture),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        overflow: TextOverflow.ellipsis,
                      ).bold().color(context.color.textColorDark),
                      Expanded(
                        child: Text(
                          propertyName,
                          overflow: TextOverflow.ellipsis,
                        )
                            .color(context.color.textColorDark)
                            .setMaxLines(lines: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
