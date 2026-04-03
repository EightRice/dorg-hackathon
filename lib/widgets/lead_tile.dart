import 'package:flutter/material.dart';
import '../models.dart';

class LeadTile extends StatelessWidget {
  final Lead lead;

  const LeadTile({super.key, required this.lead});

  IconData _channelIcon(String channel) {
    switch (channel.toLowerCase()) {
      case 'linkedin':
        return Icons.business;
      case 'twitter':
      case 'x':
        return Icons.alternate_email;
      case 'email':
        return Icons.email_outlined;
      case 'discord':
        return Icons.forum_outlined;
      case 'telegram':
        return Icons.send_outlined;
      case 'github':
        return Icons.code;
      default:
        return Icons.language;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'claimed':
        return const Color(0xFF8E8E93);
      case 'surfaced':
        return const Color(0xFF57F287);
      case 'converted':
        return const Color(0xFFFFD700);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(lead.status);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
            // Channel icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF5865F2).withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _channelIcon(lead.channel),
                color: const Color(0xFF5865F2),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Lead details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          lead.identifier,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          lead.status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.smart_toy_outlined,
                          size: 12, color: Colors.white.withAlpha(100)),
                      const SizedBox(width: 4),
                      Text(
                        lead.agentId,
                        style: TextStyle(
                          color: Colors.white.withAlpha(100),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.tag,
                          size: 12, color: Colors.white.withAlpha(80)),
                      const SizedBox(width: 2),
                      Text(
                        lead.channel,
                        style: TextStyle(
                          color: Colors.white.withAlpha(80),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (lead.brief != null && lead.brief!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      lead.brief!,
                      style: TextStyle(
                        color: Colors.white.withAlpha(140),
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
          ],
        ),
      ),
    );
  }
}
