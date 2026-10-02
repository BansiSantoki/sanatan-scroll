import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationItem {
  final int id;
  final String title;
  final String body;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
  });
}

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const int notificationHour = 8;
  static const int notificationMinute = 0;

  static const String _keyCycleStartDate = 'notification_cycle_start_date';
  static const String _keyLastScheduledDate = 'last_scheduled_date';

  /// Exact 15 push notifications as provided in specification.
  static const List<NotificationItem> notificationsList = [
    NotificationItem(
      id: 1,
      title: 'Got a few minutes?',
      body: 'Open Sanatan Scroll and read a shlok or two.',
    ),
    NotificationItem(
      id: 2,
      title: 'What feels right today?',
      body: 'Choose a text and read from wherever you want.',
    ),
    NotificationItem(
      id: 3,
      title: 'A small moment to read',
      body: 'Pick up a chapter, a shlok, or your last reading.',
    ),
    NotificationItem(
      id: 4,
      title: 'Back to Sanatan Scroll?',
      body: 'Take a few minutes and continue in your own way.',
    ),
    NotificationItem(
      id: 5,
      title: 'Back to where you stopped?',
      body: 'Your reading is right where you left it.',
    ),
    NotificationItem(
      id: 6,
      title: 'Ready for the next shlok?',
      body: 'Pick up from where you finished last time.',
    ),
    NotificationItem(
      id: 7,
      title: 'Your chapter is still there',
      body: 'Continue whenever you have a few minutes.',
    ),
    NotificationItem(
      id: 8,
      title: 'One more day of reading',
      body: 'A few minutes is all it takes to keep the rhythm going.',
    ),
    NotificationItem(
      id: 9,
      title: 'Keep the streak growing',
      body: 'Come back for a little reading today.',
    ),
    NotificationItem(
      id: 10,
      title: 'Reading the same one lately?',
      body: 'Try opening a different text today.',
    ),
    NotificationItem(
      id: 11,
      title: 'Maybe something different today',
      body: 'Explore another text in Sanatan Scroll and see where it takes you.',
    ),
    NotificationItem(
      id: 12,
      title: 'Not in the mood to read?',
      body: 'Listen to the Sanskrit instead.',
    ),
    NotificationItem(
      id: 13,
      title: 'Try listening this time',
      body: 'Put the text down and hear the shlok in Sanskrit.',
    ),
    NotificationItem(
      id: 14,
      title: 'Read it once more',
      body: 'Sometimes a shlok lands differently the second time.',
    ),
    NotificationItem(
      id: 15,
      title: 'Don\'t rush the next one',
      body: 'Stay with what you just read for a moment.',
    ),
  ];

  /// Initialize local notification plugin, permissions, and schedule morning notification.
  static Future<void> initialize() async {
    try {
      tz.initializeTimeZones();

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: iosInit,
      );

      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (response) {
          if (kDebugMode) {
            print('[NOTIFICATION LOG] User tapped notification: ${response.payload}');
          }
        },
      );

      await requestPermissions();
      await scheduleNextMorningNotification();
    } catch (e) {
      if (kDebugMode) {
        print('[NOTIFICATION LOG] Error initializing NotificationService: $e');
      }
    }
  }

  /// Request permissions for Android 13+ and iOS.
  static Future<void> requestPermissions() async {
    try {
      final androidPlatform = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlatform != null) {
        await androidPlatform.requestNotificationsPermission();
      }

      final iosPlatform = _notificationsPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (iosPlatform != null) {
        await iosPlatform.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('[NOTIFICATION LOG] Error requesting notification permissions: $e');
      }
    }
  }

  static const List<int> allowedWeekdays = [
    DateTime.monday,
    DateTime.wednesday,
    DateTime.friday,
  ];

  /// Get or initialize the start date of the notification cycle.
  /// Standardized to the Monday of the starting week for consistent week-aligned calculation.
  static Future<DateTime> _getCycleStartDate(SharedPreferences prefs) async {
    final storedDateStr = prefs.getString(_keyCycleStartDate);
    final now = DateTime.now();

    if (storedDateStr != null && storedDateStr.isNotEmpty) {
      final parsed = DateTime.tryParse(storedDateStr);
      if (parsed != null) {
        return DateTime(parsed.year, parsed.month, parsed.day);
      }
    }

    // Find the Monday of the current week as reference start
    var startMon = DateTime(now.year, now.month, now.day);
    while (startMon.weekday != DateTime.monday) {
      startMon = startMon.subtract(const Duration(days: 1));
    }

    await prefs.setString(_keyCycleStartDate, startMon.toIso8601String());
    return startMon;
  }

  static int _countScheduledDaysBetween(DateTime startDateClean, DateTime targetDateClean) {
    int count = 0;
    var cur = startDateClean;
    while (cur.isBefore(targetDateClean)) {
      if (allowedWeekdays.contains(cur.weekday)) {
        count++;
      }
      cur = cur.add(const Duration(days: 1));
    }
    return count;
  }

  /// Schedule upcoming notifications for 3 days/week (Mon, Wed, Fri) at 8:00 AM local device time.
  /// Rotates strictly sequentially through all 15 notification messages (5-week cycle).
  static Future<void> scheduleNextMorningNotification() async {
    await scheduleNotifications();
  }

  static Future<void> scheduleNotifications() async {
    try {
      tz.initializeTimeZones();
      final prefs = await SharedPreferences.getInstance();
      final startDate = await _getCycleStartDate(prefs);

      // Cancel all existing scheduled notifications to prevent duplicate scheduling
      await _notificationsPlugin.cancelAll();

      final now = DateTime.now();

      // Find initial target date (today at 8:00 AM or next candidate day)
      var candidate = DateTime(
        now.year,
        now.month,
        now.day,
        notificationHour,
        notificationMinute,
      );

      if (now.isAfter(candidate) || now.isAtSameMomentAs(candidate)) {
        candidate = candidate.add(const Duration(days: 1));
      }

      int scheduledCount = 0;
      var cur = candidate;

      // Schedule the next 6 notification slots (2 weeks ahead)
      while (scheduledCount < 6) {
        if (allowedWeekdays.contains(cur.weekday)) {
          final curDateClean = DateTime(cur.year, cur.month, cur.day);
          final startDateClean = DateTime(startDate.year, startDate.month, startDate.day);

          final countBetween = _countScheduledDaysBetween(startDateClean, curDateClean);
          final cycleIndex = (countBetween % 15 + 15) % 15;

          final notification = notificationsList[cycleIndex];
          final notificationId = 1000 + cycleIndex;

          final targetTime = DateTime(
            cur.year,
            cur.month,
            cur.day,
            notificationHour,
            notificationMinute,
          );

          // Always use tz.local to ensure notification fires at 8:00 AM in user's device LOCAL TIME
          final tzTarget = tz.TZDateTime.from(targetTime, tz.local);

          const androidDetails = AndroidNotificationDetails(
            'sanatan_morning_channel',
            'Sanatan Scroll Morning Wisdom',
            channelDescription: 'Daily morning reminder to read or listen to sacred scriptures',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

          const iosDetails = DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          );

          const details = NotificationDetails(
            android: androidDetails,
            iOS: iosDetails,
          );

          await _notificationsPlugin.zonedSchedule(
            notificationId,
            notification.title,
            notification.body,
            tzTarget,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );

          await prefs.setString(_keyLastScheduledDate, curDateClean.toIso8601String());

          if (kDebugMode) {
            print('[NOTIFICATION LOG] Scheduled Notif ${cycleIndex + 1}/15 ("${notification.title}") for $tzTarget (Local Timezone: ${tz.local.name})');
          }

          scheduledCount++;
        }
        cur = cur.add(const Duration(days: 1));
      }
    } catch (e) {
      if (kDebugMode) {
        print('[NOTIFICATION LOG] Error scheduling notifications: $e');
      }
    }
  }

  /// Helper for testing the 15-day sequence simulation.
  /// Returns a map of Day Number (1..N) to the scheduled NotificationItem.
  static Map<int, NotificationItem> testNotificationCycle([int totalDaysToSimulate = 17]) {
    final Map<int, NotificationItem> simulated = {};
    for (int day = 1; day <= totalDaysToSimulate; day++) {
      final index = (day - 1) % 15;
      simulated[day] = notificationsList[index];
      if (kDebugMode) {
        print('[TEST CYCLE LOG] Day $day -> Notif ${index + 1} ("${notificationsList[index].title}")');
      }
    }
    return simulated;
  }
}
