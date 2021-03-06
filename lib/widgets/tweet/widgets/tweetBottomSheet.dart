import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/helper/constant.dart';
import 'package:flutter_twitter_clone/helper/enum.dart';
import 'package:flutter_twitter_clone/helper/theme.dart';
import 'package:flutter_twitter_clone/helper/utility.dart';
import 'package:flutter_twitter_clone/model/feedModel.dart';
import 'package:flutter_twitter_clone/model/user.dart';
import 'package:flutter_twitter_clone/state/authState.dart';
import 'package:flutter_twitter_clone/state/feedState.dart';
import 'package:flutter_twitter_clone/widgets/customWidgets.dart';
import 'package:provider/provider.dart';

class TweetBottomSheet {
  Widget tweetOptionIcon(BuildContext context,
      {FeedModel model, TweetType type, GlobalKey<ScaffoldState> scaffoldKey}) {
    return customInkWell(
        radius: BorderRadius.circular(20),
        context: context,
        onPressed: () {
          _openbottomSheet(context,
              type: type, model: model, scaffoldKey: scaffoldKey);
        },
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: customIcon(context,
              icon: AppIcon.arrowDown,
              istwitterIcon: true,
              iconColor: AppColor.lightGrey),
        ));
  }

  void _openbottomSheet(BuildContext context,
      {TweetType type,
      FeedModel model,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    var authState = Provider.of<AuthState>(context, listen: false);
    bool isMyTweet = authState.userId == model.userId;
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context) *
                (type == TweetType.Tweet
                    ? (isMyTweet ? .50 : .44)
                    : (isMyTweet ? .38 : .52)),
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: type == TweetType.Tweet
                ? _tweetOptions(context,
                    scaffoldKey: scaffoldKey,
                    isMyTweet: isMyTweet,
                    model: model,
                    type: type)
                : _tweetDetailOptions(context,
                    scaffoldKey: scaffoldKey,
                    isMyTweet: isMyTweet,
                    model: model,
                    type: type));
      },
    );
  }

  Widget _tweetDetailOptions(BuildContext context,
      {bool isMyTweet,
      FeedModel model,
      TweetType type,
      GlobalKey<ScaffoldState> scaffoldKey}) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(context, AppIcon.link,
            text: 'Copy link to tweet', isEnable: true, onPressed: () async {
          var uri = await createLinkToShare(
            context,
            "tweet/${model.key}",
            socialMetaTagParameters: SocialMetaTagParameters(
                description: model.description ??
                    "${model.user.displayName} posted a tweet on Fwitter.",
                title: "Tweet on Fwitter app",
                imageUrl: Uri.parse(
                    "https://play-lh.googleusercontent.com/e66XMuvW5hZ7HnFf8R_lcA3TFgkxm0SuyaMsBs3KENijNHZlogUAjxeu9COqsejV5w=s180-rw")),
          );

          Navigator.pop(context);
          copyToClipBoard(
              scaffoldKey: scaffoldKey,
              text: uri.toString(),
              message: "Tweet link copy to clipboard");
        }),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Pin to profile',
              )
            : _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Unfollow ${model.user.userName}',
              ),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.delete,
                text: 'Delete Tweet',
                onPressed: () {
                  _deleteTweet(
                    context,
                    type,
                    model.key,
                    parentkey: model.parentkey,
                  );
                },
                isEnable: true,
              )
            : Container(),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.mute,
                text: 'Mute ${model.user.userName}',
              ),
        _widgetBottomSheetRow(
          context,
          AppIcon.mute,
          text: 'Mute this convertion',
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.viewHidden,
          text: 'View hidden replies',
        ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.block,
                text: 'Block ${model.user.userName}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.report,
                text: 'Report Tweet',
              ),
      ],
    );
  }

  Widget _tweetOptions(BuildContext context,
      {bool isMyTweet,
      FeedModel model,
      TweetType type,
      GlobalKey<ScaffoldState> scaffoldKey}) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(context, AppIcon.link,
            text: 'Copy link to tweet', isEnable: true, onPressed: () async {
          var uri = await createLinkToShare(
            context,
            "tweet/${model.key}",
            socialMetaTagParameters: SocialMetaTagParameters(
                description: model.description ??
                    "${model.user.displayName} posted a tweet on Fwitter.",
                title: "Tweet on Fwitter app",
                imageUrl: Uri.parse(
                    "https://play-lh.googleusercontent.com/e66XMuvW5hZ7HnFf8R_lcA3TFgkxm0SuyaMsBs3KENijNHZlogUAjxeu9COqsejV5w=s180-rw")),
          );
          Navigator.pop(context);
          copyToClipBoard(
              scaffoldKey: scaffoldKey,
              text: uri.toString(),
              message: "Tweet link copy to clipboard");
        }),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.thumbpinFill,
                text: 'Pin to profile',
              )
            : _widgetBottomSheetRow(
                context,
                AppIcon.sadFace,
                text: 'Not interested in this',
              ),
        isMyTweet
            ? _widgetBottomSheetRow(
                context,
                AppIcon.delete,
                text: 'Delete Tweet',
                onPressed: () {
                  _deleteTweet(
                    context,
                    type,
                    model.key,
                    parentkey: model.parentkey,
                  );
                },
                isEnable: true,
              )
            : Container(),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.unFollow,
                text: 'Unfollow ${model.user.userName}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.mute,
                text: 'Mute ${model.user.userName}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.block,
                text: 'Block ${model.user.userName}',
              ),
        isMyTweet
            ? Container()
            : _widgetBottomSheetRow(
                context,
                AppIcon.report,
                text: 'Report Tweet',
              ),
      ],
    );
  }

  Widget _widgetBottomSheetRow(BuildContext context, int icon,
      {String text, Function onPressed, bool isEnable = false}) {
    return Expanded(
      child: customInkWell(
        context: context,
        onPressed: () {
          if (onPressed != null)
            onPressed();
          else {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              customIcon(
                context,
                icon: icon,
                istwitterIcon: true,
                size: 25,
                paddingIcon: 8,
                iconColor:
                    onPressed != null ? AppColor.darkGrey : AppColor.lightGrey,
              ),
              SizedBox(
                width: 15,
              ),
              customText(
                text,
                context: context,
                style: TextStyle(
                  color: isEnable ? AppColor.secondary : AppColor.lightGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTweet(BuildContext context, TweetType type, String tweetId,
      {String parentkey}) {
    var state = Provider.of<FeedState>(context, listen: false);
    state.deleteTweet(tweetId, type, parentkey: parentkey);
    // CLose bottom sheet
    Navigator.of(context).pop();
    if (type == TweetType.Detail) {
      // Close Tweet detail page
      Navigator.of(context).pop();
      // Remove last tweet from tweet detail stack page
      state.removeLastTweetDetail(tweetId);
    }
  }

  void openRetweetbottomSheet(BuildContext context,
      {TweetType type,
      FeedModel model,
      GlobalKey<ScaffoldState> scaffoldKey}) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
            padding: EdgeInsets.only(top: 5, bottom: 0),
            height: 130,
            width: fullWidth(context),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomSheetTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: _retweet(context, model, type));
      },
    );
  }

  Widget _retweet(BuildContext context, FeedModel model, TweetType type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.heartEmpty,
          isEnable: true,
          text: 'Ka?? Kapak bas??yorsunuz?',
          onPressed: () {
            // var state = Provider.of<FeedState>(context, listen: false);
            // var authState = Provider.of<AuthState>(context, listen: false);
            // var myUser = authState.userModel;
            // myUser = UserModel(
            //     displayName: myUser.displayName ?? myUser.email.split('@')[0],
            //     profilePic: myUser.profilePic,
            //     userId: myUser.userId,
            //     isVerified: authState.userModel.isVerified,
            //     userName: authState.userModel.userName);
            // // Prepare current Tweet model to reply
            // FeedModel post = new FeedModel(
            //     childRetwetkey: model.key,
            //     createdAt: DateTime.now().toUtc().toString(),
            //     user: myUser,
            //     userId: myUser.userId);
            // state.createReTweet(post);
            // Navigator.pop(context);
          },
        ),
        SliderInNavigationBar(model:model),

      ],
    );
  }
}

class SliderInNavigationBar extends StatefulWidget {
  final FeedModel model;
  SliderInNavigationBar({Key key, @required this.model}) : super(key: key);
  @override
  _SliderInNavigationBarScreenState createState() => new _SliderInNavigationBarScreenState();

}

class _SliderInNavigationBarScreenState extends State<SliderInNavigationBar> {
  int _currentIndex = 0;

  //List<Widget> _children;
  int _period = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(children: <Widget>[
      SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: Colors.red[700],
          inactiveTrackColor: Colors.red[100],
          trackShape: RoundedRectSliderTrackShape(),
          trackHeight: 4.0,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
          thumbColor: Colors.redAccent,
          overlayColor: Colors.red.withAlpha(32),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
          tickMarkShape: RoundSliderTickMarkShape(),
          activeTickMarkColor: Colors.red[700],
          inactiveTickMarkColor: Colors.red[100],
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.redAccent,
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        child: Slider(
            value: _period.toDouble(),
            min: 0.0,
            max: 10000.0,
            divisions: 1000,
            label: '$_period',
            onChanged: (double value) {
              print('OnChanged');
              setState(() {
                _period = value.round();
              });
            }),
      ),
      FlatButton(
        color: Colors.orange,
        padding: EdgeInsets.all(10.0),
        child: Column( // Replace with a Row for horizontal icon + text
          children: <Widget>[
            Icon(Icons.add),
            Text("Add")
          ],
        ),
        onPressed: () {
          var state = Provider.of<FeedState>(context, listen: false);
          var authState = Provider.of<AuthState>(context, listen: false);
          state.addLikeToTweet(widget.model, authState.userId, _period);
          // Prepare current Tweet model to reply
          state.setTweetToReply = widget.model;
          Navigator.pop(context);

          /// `/ComposeTweetPage/retweet` route is used to identify that tweet is going to be retweet.
          /// To simple reply on any `Tweet` use `ComposeTweetPage` route.
          //Navigator.of(context).pushNamed('/ComposeTweetPage/retweet');
        },
      )
    ]);
  }
}
