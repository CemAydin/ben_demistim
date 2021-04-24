import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/helper/constant.dart';
import 'package:flutter_twitter_clone/helper/enum.dart';
import 'package:flutter_twitter_clone/helper/theme.dart';
import 'package:flutter_twitter_clone/model/feedModel.dart';
import 'package:flutter_twitter_clone/state/authState.dart';
import 'package:flutter_twitter_clone/state/feedState.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';
import 'package:flutter_twitter_clone/widgets/newWidget/customLoader.dart';
import 'package:flutter_twitter_clone/widgets/newWidget/emptyList.dart';
import 'package:flutter_twitter_clone/widgets/tweet/tweet.dart';
import 'package:flutter_twitter_clone/widgets/tweet/widgets/tweetBottomSheet.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key key, this.scaffoldKey, this.refreshIndicatorKey})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
      },
      child: customIcon(
        context,
        icon: AppIcon.fabTweet,
        istwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(context),
      backgroundColor: TwitterColor.mystic,
      body: SafeArea(
        child: Container(
          height: fullHeight(context),
          width: fullWidth(context),
          child: RefreshIndicator(
            key: refreshIndicatorKey,
            onRefresh: () async {
              /// refresh home page feed
              var feedState = Provider.of<FeedState>(context, listen: false);
              feedState.getDataFromDatabase();
              return Future.value(true);
            },
            child: _FeedPageBody(
              refreshIndicatorKey: refreshIndicatorKey,
              scaffoldKey: scaffoldKey,
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedPageBody extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final TextEditingController textController;
  final ValueChanged<String> onSearchChanged;

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;

  const _FeedPageBody(
      {Key key,
      this.scaffoldKey,
      this.refreshIndicatorKey,
      this.textController,
      this.onSearchChanged})
      : super(key: key);

  Widget _getUserAvatar(BuildContext context) {
    var authState = Provider.of<AuthState>(context);
    return Padding(
      padding: EdgeInsets.all(10),
      child: customInkWell(
        context: context,
        onPressed: () {
          /// Open up sidebaar drawer on user avatar tap
          scaffoldKey.currentState.openDrawer();
        },
        child:
            customImage(context, authState.userModel?.profilePic, height: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<AuthState>(context, listen: false);
    final List<String> _tabs = <String>["Gündem", "Ekonomi", "Eğlence", "Spor", "Siyaset"];
    return DefaultTabController(
      length: _tabs.length,
      child: Consumer<FeedState>(
        builder: (context, state, child) {
          final List<FeedModel> list = state.getTweetList(authstate.userModel);
          return CustomScrollView(
            slivers: <Widget>[
              child,
              state.isBusy && list == null
                  ? SliverToBoxAdapter(
                      child: Container(
                        height: fullHeight(context) - 135,
                        child: CustomScreenLoader(
                          height: double.infinity,
                          width: fullWidth(context),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    )
                  : !state.isBusy && list == null
                      ? SliverToBoxAdapter(
                          child: EmptyList(
                            'No Tweet added',
                            subTitle:
                                'When new Tweet added, they\'ll show up here \n Tap tweet button to add new',
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildListDelegate(
                            list.map(
                              (model) {
                                return Container(
                                  color: Colors.white,
                                  child: Tweet(
                                    model: model,
                                    trailing: TweetBottomSheet()
                                        .tweetOptionIcon(context,
                                            model: model,
                                            type: TweetType.Tweet,
                                            scaffoldKey: scaffoldKey),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        )
            ],
          );
        },
        child: SliverAppBar(
          floating: true,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
          ),
          title: Container(
              height: 50,
              padding: EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                onChanged: onSearchChanged,
                controller: textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25.0),
                    ),
                  ),
                  hintText: 'Search..',
                  fillColor: AppColor.extraLightGrey,
                  filled: true,
                  focusColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                ),
              )),
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          backgroundColor: Theme.of(context).appBarTheme.color,
          actions: [
            _getUserAvatar(context),
          ],
          bottom: TabBar(
            tabs: _tabs.map((String name) => Tab(text: name)).toList(),
          ),
        ),
      ),
    );

    return Consumer<FeedState>(
      builder: (context, state, child) {
        final List<FeedModel> list = state.getTweetList(authstate.userModel);
        return CustomScrollView(
          slivers: <Widget>[
            child,
            state.isBusy && list == null
                ? SliverToBoxAdapter(
                    child: Container(
                      height: fullHeight(context) - 135,
                      child: CustomScreenLoader(
                        height: double.infinity,
                        width: fullWidth(context),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : !state.isBusy && list == null
                    ? SliverToBoxAdapter(
                        child: EmptyList(
                          'No Tweet added yet',
                          subTitle:
                              'When new Tweet added, they\'ll show up here \n Tap tweet button to add new',
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildListDelegate(
                          list.map(
                            (model) {
                              return Container(
                                color: Colors.white,
                                child: Tweet(
                                  model: model,
                                  trailing: TweetBottomSheet().tweetOptionIcon(
                                      context,
                                      model: model,
                                      type: TweetType.Tweet,
                                      scaffoldKey: scaffoldKey),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
          ],
        );
      },
      child: SliverAppBar(
        floating: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Container(
            height: 50,
            padding: EdgeInsets.symmetric(vertical: 5),
            child: TextField(
              onChanged: onSearchChanged,
              controller: textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(25.0),
                  ),
                ),
                hintText: 'Search..',
                fillColor: AppColor.extraLightGrey,
                filled: true,
                focusColor: Colors.white,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
            )),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: [
          _getUserAvatar(context),
        ],
        bottom: TabBar(
          tabs: [
            Tab(text: "Tab1"),
            Tab(text: "Tab2"),
            Tab(text: "Tab3"),
            Tab(text: "Tab4"),
          ],
        ),
      ),
    );
  }
}
