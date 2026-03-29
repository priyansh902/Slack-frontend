
import 'package:flutter_riverpod/flutter_riverpod.dart';


class NotificationState {
  final int unreadCount;
  final List<Map<String, dynamic>> notifications;
  
  NotificationState({
    this.unreadCount = 0,
    this.notifications = const [],
  });
  
  NotificationState copyWith({
    int? unreadCount,
    List<Map<String, dynamic>>? notifications,
  }) {
    return NotificationState(
      unreadCount: unreadCount ?? this.unreadCount,
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(NotificationState());
  
  void addNotification(Map<String, dynamic> notification) {
    state = state.copyWith(
      notifications: [notification, ...state.notifications],
      unreadCount: state.unreadCount + 1,
    );
  }
  
  void markAsRead(int index) {
    final notifications = List<Map<String, dynamic>>.from(state.notifications);
    notifications[index]['read'] = true;
    state = state.copyWith(
      notifications: notifications,
      unreadCount: state.unreadCount - 1,
    );
  }
  
  void markAllAsRead() {
    final notifications = state.notifications.map((n) {
      n['read'] = true;
      return n;
    }).toList();
    state = state.copyWith(
      notifications: notifications,
      unreadCount: 0,
    );
  }
  
  void clearAll() {
    state = NotificationState();
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});