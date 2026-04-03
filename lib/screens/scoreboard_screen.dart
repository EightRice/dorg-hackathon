import 'dart:async';
import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../widgets/agent_card.dart';

class ScoreboardScreen extends StatefulWidget {
  final ApiClient apiClient;

  const ScoreboardScreen({super.key, required this.apiClient});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  List<Agent> _agents = [];
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
      final agents = await widget.apiClient.fetchScores();
      if (mounted) {
        setState(() {
          _agents = agents;
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
            content: Text('Failed to load scores: $e'),
            backgroundColor: const Color(0xFFED4245),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  int get _totalLeads =>
      _agents.fold(0, (sum, a) => sum + a.leadsClaimed);

  int get _totalSurfaced =>
      _agents.fold(0, (sum, a) => sum + a.leadsSurfaced);

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
            // Refresh indicator bar
            if (_refreshing)
              const LinearProgressIndicator(
                color: Color(0xFF5865F2),
                backgroundColor: Color(0xFF1E1E2E),
                minHeight: 2,
              ),
            // Summary bar
            _buildSummaryBar(),
            // Agent list
            Expanded(
              child: _agents.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _fetchData,
                      color: const Color(0xFF5865F2),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 8, bottom: 24),
                        itemCount: _agents.length,
                        itemBuilder: (context, index) {
                          return AgentCard(
                            agent: _agents[index],
                            rank: index + 1,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5865F2), Color(0xFF4752C4)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5865F2).withAlpha(40),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryItem(
            icon: Icons.smart_toy_outlined,
            label: 'Agents',
            value: _agents.length.toString(),
          ),
          Container(
            width: 1,
            height: 32,
            color: Colors.white.withAlpha(40),
          ),
          _SummaryItem(
            icon: Icons.flag_rounded,
            label: 'Leads Claimed',
            value: _totalLeads.toString(),
          ),
          Container(
            width: 1,
            height: 32,
            color: Colors.white.withAlpha(40),
          ),
          _SummaryItem(
            icon: Icons.upload_rounded,
            label: 'Leads Surfaced',
            value: _totalSurfaced.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.smart_toy_outlined,
            size: 64,
            color: Colors.white.withAlpha(40),
          ),
          const SizedBox(height: 16),
          Text(
            'No agents registered yet',
            style: TextStyle(
              color: Colors.white.withAlpha(100),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agents will appear here once they register.',
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

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(180),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
