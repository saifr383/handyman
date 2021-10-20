import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/LastMessegeChat.dart';
import 'package:booking_system_flutter/model/ContactModel.dart';
import 'package:booking_system_flutter/model/UserData.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'ChatScreen.dart';

class ChatFragment extends StatefulWidget {
  const ChatFragment({Key? key}) : super(key: key);


  @override
  _ChatFragmentState createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<ChatFragment> {

  String id = '';

  @override
  void initState() {
    print('hi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('hellofdhvfdhfdhbfjbdfjk f///////////////');
    print(UID);
    return Scaffold(
      appBar: appBarWidget(language!.lblchat, textColor: white, showBack: false, elevation: 3.0, color: context.primaryColor),
      body: StreamBuilder<QuerySnapshot>(
        stream: appStore.isLoggedIn ? chatMessageService.fetchContacts(userId: getStringAsync(UID)) : null,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text(snapshot.error.toString(), style: boldTextStyle()).center();
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0) {
              return noDataFound().center();
            } else {
              return _buildChatItemListView(docList: snapshot.data!.docs);
            }
          }
          return snapWidgetHelper(snapshot);
        },
      ),
    );
  }

  Widget _buildChatItemListView({required List<QueryDocumentSnapshot> docList}) {
    return ListView.separated(
      itemCount: docList.length,
      itemBuilder: (context, index) {
        ContactModel contact = ContactModel.fromJson(docList[index].data() as Map<String, dynamic>);
        return _buildChatItemWidget(contact: contact);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(indent: 80, height: 0);
      },
    );
  }

  StreamBuilder<List<UserData>> _buildChatItemWidget({contact}) {
    return StreamBuilder(
      stream: chatMessageService.getUserDetailsById(id: contact.uid),
      builder: (context, snap) {
        if (snap.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              UserData data = snap.data![index];

              if (snap.data!.length == 0) {
                return noDataFound();
              }
              return InkWell(
                onTap: () async {
                  if (id != data.uid) {
                    hideKeyboard(context);
                    ChatScreen(userData: data).launch(context);
                  }
                },
                onLongPress: () async {
                  //
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Hero(
                          tag: data.uid.validate(),
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: EdgeInsets.all(10),
                            color: primaryColor,
                            child: Text(data.display_name![0].validate().toUpperCase(), style: secondaryTextStyle(color: Colors.white)).center().fit(),
                          ).cornerRadiusWithClipRRect(50)),
                      10.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data.display_name.validate(), style: primaryTextStyle(size: 18), maxLines: 1, textAlign: TextAlign.start, overflow: TextOverflow.ellipsis).expand(),
                              StreamBuilder<int>(
                                stream: chatMessageService.getUnReadCount(senderId: getStringAsync(UID), receiverId: contact.uid!),
                                builder: (context, snap) {
                                  if (snap.hasData) {
                                    if (snap.data != 0) {
                                      return Container(
                                        height: 18,
                                        width: 18,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: primaryColor),
                                        child: Text(snap.data.validate().toString(), style: secondaryTextStyle(size: 12, color: white)).fit().center(),
                                      );
                                    }
                                  }
                                  return Offstage();
                                },
                              ),
                            ],
                          ),
                          2.height,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LastMessageChat(
                                stream: chatMessageService.fetchLastMessageBetween(senderId: getStringAsync(UID), receiverId: contact.uid!),
                              ),
                            ],
                          ),
                        ],
                      ).expand(),
                    ],
                  ),
                ),
              );
            },
            itemCount: snap.data!.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            dragStartBehavior: DragStartBehavior.start,
          );
        }
        return snapWidgetHelper(snap, loadingWidget: Offstage());
      },
    );
  }
}
