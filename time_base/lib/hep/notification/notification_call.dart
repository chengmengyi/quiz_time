class NotificationCall{
  const NotificationCall({required this.userClickNotification});

  final void Function(int notificationId) userClickNotification;
}