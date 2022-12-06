import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:restorant/home/explore.dart';

import '../data/model/list_restaurant_model.dart';
import '../main.dart';

class SettingScreen extends StatefulWidget {
  ReceivedAction? receivedAction;
  SettingScreen({super.key, this.receivedAction});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool switched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading:
              IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
          title: const Text('Settings')),
      body: ListTile(
        title: const Text('Scheduling News Restaurant'),
        trailing: Switch(
          value: switched,
          activeColor: Colors.blue,
          onChanged: (bool value) {
            AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
              if (!isAllowed) {
                // This is just a basic example. For real apps, you must show some
                // friendly dialog box before call the request method.
                // This is very important to not harm the user experience
                AwesomeNotifications().requestPermissionToSendNotifications();
              }
            });

            setState(() {
              switched = value;
            });

            if (!switched) {
              AwesomeNotifications().cancelAll();
            } else {
              Restaurants restaurant = ExplorePage.listRestaurant!.restaurants![
                  ExplorePage.listRestaurant!.restaurants!.length -
                      NotificationController.decrement];

              Future.delayed(
                const Duration(seconds: 10),
                () {
                  AwesomeNotifications().createNotification(
                      content: NotificationContent(
                          id: 10,
                          channelKey: 'basic_channel',
                          title: 'Resto Baru! namanya: ${restaurant.name}',
                          body: restaurant.description,
                          actionType: ActionType.Default));
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class NotificationController {
  static int decrement = 1;
  static int lengt = ExplorePage.listRestaurant!.restaurants!.length - 5;

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    Restaurants restaurant = ExplorePage.listRestaurant!.restaurants![
        ExplorePage.listRestaurant!.restaurants!.length - decrement];
    decrement++;
    if (lengt > -1 ||
        lengt <= ExplorePage.listRestaurant!.restaurants!.length) {
      lengt++;
    }

    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil('/detail-resto',
        (route) => (route.settings.name != '/detail-resto') || route.isFirst,
        arguments: restaurant);
  }
}
