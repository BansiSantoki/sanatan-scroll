import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/admin_colors.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/loading_state_widget.dart';
import '../../../models/notification_admin_model.dart';
import '../../../providers/notifications_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _targetAudience = 'all';

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    final model = NotificationAdminModel(
      id: '',
      title: _titleController.text.trim(),
      message: _messageController.text.trim(),
      targetAudience: _targetAudience,
      status: 'sent',
      createdAt: DateTime.now(),
    );

    final success = await context.read<NotificationsProvider>().sendNotification(model);
    if (mounted && success) {
      _titleController.clear();
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Push notification queued and dispatched successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsProvider = context.watch<NotificationsProvider>();

    if (notificationsProvider.isLoading) {
      return const LoadingStateWidget(message: 'Loading Notifications Queue...');
    }

    final notifications = notificationsProvider.notifications;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Card: Send Notification Form
          Expanded(
            flex: 2,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Compose Push Notification',
                        style: GoogleFonts.cinzel(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AdminColors.primaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Dispatch real-time announcements or daily wisdom reminders to mobile seekers.',
                        style: GoogleFonts.inter(fontSize: 13, color: AdminColors.textSecondary),
                      ),
                      const Divider(height: 28),

                      Text('Target Audience', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _targetAudience,
                        decoration: const InputDecoration(),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Registered Mobile Users')),
                          DropdownMenuItem(value: 'active', child: Text('Active Streak Seekers')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _targetAudience = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      Text('Notification Title', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(hintText: '✨ Today\'s Sacred Wisdom Scroll is Ready!'),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Title is required' : null,
                      ),
                      const SizedBox(height: 16),

                      Text('Message Content', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Tap to reflect on today\'s shloka from Bhagavad Gita...',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Message is required' : null,
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _handleSendNotification,
                          icon: const Icon(Icons.send_rounded, size: 18),
                          label: const Text('Dispatch Notification Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),

          // Right Card: Sent History
          Expanded(
            flex: 3,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notification History & Log',
                      style: GoogleFonts.cinzel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AdminColors.primaryDark,
                      ),
                    ),
                    const Divider(height: 28),

                    Expanded(
                      child: notifications.isEmpty
                          ? const EmptyStateWidget(
                              title: 'No Notifications Dispatched',
                              message: 'Dispatched notification records will appear here.',
                            )
                          : ListView.separated(
                              itemCount: notifications.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = notifications[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                                  leading: CircleAvatar(
                                    backgroundColor: AdminColors.saffron.withAlpha(30),
                                    child: const Icon(Icons.notifications, color: AdminColors.saffron),
                                  ),
                                  title: Text(
                                    item.title,
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    '${item.message}\nAudience: ${item.targetAudience} • ${item.createdAt?.toString().substring(0, 16) ?? ''}',
                                    style: GoogleFonts.inter(fontSize: 12, color: AdminColors.textSecondary),
                                  ),
                                  isThreeLine: true,
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AdminColors.error, size: 18),
                                    onPressed: () {
                                      notificationsProvider.deleteNotification(item.id);
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
