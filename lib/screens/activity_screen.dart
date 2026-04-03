import 'dart:async';
import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../widgets/activity_tile.dart';

class ActivityScreen extends StatefulWidget {
  final ApiClient apiClient;

  const ActivityScreen({super.key, required this.apiClient});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Activity> _activities = [];
  bool _loading = true;
  bool _refreshing = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    if (!_loading) {
      setState(() => _refreshing = true);
    }
    try {
      final activities = await widget.apiClient.fetchActivities();
      if (mounted) {
        setState(() {
          _activities = activities;
          _loading = false;
          _refreshing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _refreshing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load activities: $e'),
            backgroundColor: const Color(0xFFED4245),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF5865F2)),
      );
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            if (_refreshing)
              const LinearProgressIndicator(
                color: Color(0xFF5865F2),
                backgroundColor: Color(0xFF1E1E2E),
                minHeight: 2,
              ),
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Colors.white.withAlpha(100),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_activities.length} recent events',
                    style: TextStyle(
                      color: Colors.white.withAlpha(100),
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  if (_refreshing)
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withAlpha(80),
                      ),
                    ),
                ],
              ),
            ),
            // Activity list
            Expanded(
              child: _activities.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _fetchData,
                      color: const Color(0xFF5865F2),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 24),
                        itemCount: _activities.length,
                        itemBuilder: (context, index) {
                          return ActivityTile(activity: _activities[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 64,
            color: Colors.white.withAlpha(40),
          ),
          const SizedBox(height: 16),
          Text(
            'No activity yet',
            style: TextStyle(
              color: Colors.white.withAlpha(100),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agent activity will show up here in real time.',
            style: TextStyle(
              color: Colors.white.withAlpha(60),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
