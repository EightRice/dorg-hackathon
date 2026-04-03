import 'package:flutter/material.dart';
import '../models.dart';

class AgentCard extends StatelessWidget {
  final Agent agent;
  final int rank;

  const AgentCard({super.key, required this.agent, required this.rank});

  bool get _isTopThree => rank <= 3;

  Color get _medalColor {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.transparent;
    }
  }

  IconData get _medalIcon {
    switch (rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events;
      case 3:
        return Icons.emoji_events;
      default:
        return Icons.person;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'registered':
        return const Color(0xFF5865F2);
      case 'active':
        return const Color(0xFF57F287);
      case 'paused':
        return const Color(0xFFFEE75C);
      case 'disqualified':
        return const Color(0xFFED4245);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final blurple = const Color(0xFF5865F2);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: _isTopThree
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _medalColor.withAlpha(40),
                  const Color(0xFF1E1E2E),
                  const Color(0xFF1E1E2E),
                ],
              )
            : null,
        color: _isTopThree ? null : const Color(0xFF1E1E2E),
        border: _isTopThree
            ? Border.all(color: _medalColor.withAlpha(80), width: 1.5)
            : Border.all(color: const Color(0xFF2A2A3E), width: 1),
        boxShadow: _isTopThree
            ? [
                BoxShadow(
                  color: _medalColor.withAlpha(30),
                  blurRadius: 16,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank badge
            SizedBox(
              width: 48,
              child: _isTopThree
                  ? Icon(_medalIcon, color: _medalColor, size: 32)
                  : Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: blurple.withAlpha(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '#$rank',
                        style: TextStyle(
                          color: blurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Agent info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          agent.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight:
                                _isTopThree ? FontWeight.bold : FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _statusColor(agent.status).withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          agent.status,
                          style: TextStyle(
                            color: _statusColor(agent.status),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    agent.agentId,
                    style: TextStyle(
                      color: Colors.white.withAlpha(100),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Stats
            _StatChip(
              icon: Icons.upload_rounded,
              label: 'Surfaced',
              value: agent.leadsSurfaced.toString(),
              color: const Color(0xFF57F287),
            ),
            const SizedBox(width: 16),
            _StatChip(
              icon: Icons.flag_rounded,
              label: 'Claimed',
              value: agent.leadsClaimed.toString(),
              color: blurple,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(100),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
