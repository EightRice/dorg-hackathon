import 'dart:async';
import 'package:flutter/material.dart';
import '../api_client.dart';
import '../models.dart';
import '../widgets/lead_tile.dart';

class LeadsScreen extends StatefulWidget {
  final ApiClient apiClient;

  const LeadsScreen({super.key, required this.apiClient});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  List<Lead> _leads = [];
  bool _loading = true;
  bool _refreshing = false;
  String _filter = 'all';
  Timer? _timer;

  static const List<String> _filters = [
    'all',
    'claimed',
    'surfaced',
    'converted',
  ];

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
      final leads = await widget.apiClient.fetchLeads();
      if (mounted) {
        setState(() {
          _leads = leads;
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
            content: Text('Failed to load leads: $e'),
            backgroundColor: const Color(0xFFED4245),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  List<Lead> get _filteredLeads {
    if (_filter == 'all') return _leads;
    return _leads.where((l) => l.status.toLowerCase() == _filter).toList();
  }

  Color _chipColor(String filter) {
    switch (filter) {
      case 'claimed':
        return const Color(0xFF8E8E93);
      case 'surfaced':
        return const Color(0xFF57F287);
      case 'converted':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF5865F2);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF5865F2)),
      );
    }

    final filtered = _filteredLeads;

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
            // Filter chips
            _buildFilterBar(),
            // Lead list
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _fetchData,
                      color: const Color(0xFF5865F2),
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 4, bottom: 24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          return LeadTile(lead: filtered[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: _filters.map((f) {
          final isSelected = _filter == f;
          final color = _chipColor(f);
          final count = f == 'all'
              ? _leads.length
              : _leads.where((l) => l.status.toLowerCase() == f).length;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                '${f[0].toUpperCase()}${f.substring(1)} ($count)',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white.withAlpha(160),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() => _filter = f),
              backgroundColor: const Color(0xFF1E1E2E),
              selectedColor: color.withAlpha(40),
              side: BorderSide(
                color: isSelected ? color.withAlpha(120) : const Color(0xFF2A2A3E),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_search_outlined,
            size: 64,
            color: Colors.white.withAlpha(40),
          ),
          const SizedBox(height: 16),
          Text(
            _filter == 'all'
                ? 'No leads yet'
                : 'No $_filter leads',
            style: TextStyle(
              color: Colors.white.withAlpha(100),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Leads will appear here once agents start claiming them.',
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
