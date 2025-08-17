/// Notification service for scheduling local notifications.
///
/// This file provides a service for managing local notifications,
/// including scheduling daily reminders.
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../constants/strings.dart';
import '../error/exceptions.dart';

/// Service for managing local notifications
class NotificationService {
  /// Flutter Local Notifications plugin
  final FlutterLocalNotificationsPlugin _notifications;
  
  /// Creates a new [NotificationService] with the given notifications plugin
  NotificationService(this._notifications);
  
  /// Initialize the notification service
  Future<void> initialize() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid = 
      AndroidInitializationSettings('app_icon');
      
    final DarwinInitializationSettings initializationSettingsIOS = 
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification,
      );
      
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    
    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationResponse,
    );
  }
  
  /// Request notification permissions
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final result = await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
      return result ?? false;
    } else if (Platform.isAndroid) {
      final result = await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
      return result ?? false;
    }
    
    return false;
  }
  
  /// Check if notification permissions are granted
  Future<bool> checkPermission() async {
    try {
      if (Platform.isAndroid) {
        final result = await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
        return result ?? false;
      } else if (Platform.isIOS) {
        // For iOS, we'll just try to request permissions again
        // which will return the current status
        return await requestPermission();
      }
    } catch (e) {
      debugPrint('Failed to check notification permissions: $e');
    }
    
    return false;
  }
  
  /// Schedule daily reminders at the specified times
  Future<void> scheduleDailyReminders() async {
    // Check if we have permission first
    final hasPermission = await checkPermission();
    if (!hasPermission) {
      throw const PermissionException(
        'Notification permission not granted',
        permission: 'notification',
      );
    }
    
    // Cancel any existing notifications first
    await _notifications.cancelAll();
    
    // Schedule the first reminder at 3:00 PM
    await _scheduleNotification(
      id: 1,
      title: AppStrings.notificationTitle,
      body: AppStrings.notificationBody,
      hour: 15, // 3 PM
      minute: 0,
    );
    
    // Schedule the second reminder at 7:00 PM
    await _scheduleNotification(
      id: 2,
      title: AppStrings.notificationTitle,
      body: AppStrings.notificationBody,
      hour: 19, // 7 PM
      minute: 0,
    );
  }
  
  /// Schedule a notification at a specific time
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    
    // If the scheduled time has passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminders',
          channelDescription: 'Daily reminders to create ambigrams',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'Ambigram reminder',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }
  
  /// Show an immediate notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: const AndroidNotificationDetails(
          'general',
          'General Notifications',
          channelDescription: 'General notifications from the app',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }
  
  /// Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
  
  /// Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  /// Callback for iOS notifications received while the app is in the foreground
  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    debugPrint('Notification received: $id, $title, $body, $payload');
  }
  
  /// Callback for handling notification responses
  void onNotificationResponse(NotificationResponse response) {
    debugPrint('Notification response: ${response.payload}');
    // Handle notification tap
  }
}
