import 'package:app/widgets/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                leading: Icon(
                  Icons.notifications,
                  color: Theme.of(context).hintColor,
                ),
                title: Text(
                  'Notifications',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ),
            ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 15),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: 6,
              separatorBuilder: (context, index) {
                return SizedBox(height: 15);
              },
              itemBuilder: (context, index) {
                return NotificationItemWidget();
              },
            ),
          ],
        ),
      ),
    );
  }
}
