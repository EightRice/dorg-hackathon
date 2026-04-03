import 'package:flutter/material.dart';
import '../models.dart';

class ActivityTile extends StatelessWidget {
  final Activity activity;

  const ActivityTile({super.key, required this.activity});

  Color _typeColor(String type) {
    final t = type.toLowerCase();
    if (t.contains('lead') || t.contains('surfac') || t.contains('convert')) {
      return const Color(0xFF57F287);
    }
    if (t.contains('message') || t.contains('relay')) {
      return const Color(0xFF5865F2);
    }
    return const Color(0xFF8E8E93);
  }

  IconData _typeIcon(String type) {
    final t = type.toLowerCase();
    if (t.contains('claim')) return Icons.flag_rounded;
    if (t.contains('surfac')) return Icons.upload_rounded;
    if (t.contains('convert')) return Icons.star_rounded;
    if (t.contains('message') || t.contains('relay')) return Icons.chat_bubble_outline;
    if (t.contains('register')) return Icons.person_add_outlined;
    return Icons.circle;
  }

  String _formatType(String type) {
    return type.replaceAll('_', ' ');
  }

  String _relativeTime(String isoString) {
    try {
      final dt = DateTime.parse(isoString);
      final now = DateTime.now().toUtc();
      final diff = now.difference(dt);

      if (diff.isNegative) return 'just now';
      if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
      return '${(diff.inDays / 30).floor()}mo ago';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(activity.type);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A3E), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _typeIcon(activity.type),
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            // Activity info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        activity.agentId,
                        style: const TextStyle(
                          color: Color(0xFF5865F2),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: color.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _formatType(activity.type),
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (activity.details.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      activity.details,
                      style: TextStyle(
                        color: Colors.white.withAlpha(160),
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Timestamp
            const SizedBox(width: 8),
            Text(
              _relativeTime(activity.createdAt),
              style: TextStyle(
                color: Colors.white.withAlpha(80),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
