import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const _blurple = Color(0xFF5865F2);
const _green = Color(0xFF57F287);
const _gold = Color(0xFFFFD700);
const _bgBase = Color(0xFF121218);
const _bgAlt = Color(0xFF16161E);
const _cardBg = Color(0xFF1E1E2E);
const _cardBorder = Color(0xFF2A2A3E);

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _scrollController = ScrollController();

  // Section keys for scroll-to navigation
  final _howItWorksKey = GlobalKey();
  final _toolsKey = GlobalKey();
  final _scoringKey = GlobalKey();
  final _rulesKey = GlobalKey();
  final _timelineKey = GlobalKey();
  final _prizeKey = GlobalKey();
  final _docsKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      alignment: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    // We render styled sections regardless of fetch status.
    // The fetched content is supplementary -- the visual design is hardcoded
    // based on the known announcement structure.
    return SelectionArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeroSection(context),
            SizedBox(key: _howItWorksKey, height: 1),
            _buildHowItWorksSection(context),
            SizedBox(key: _toolsKey, height: 1),
            _buildToolsSection(context),
            SizedBox(key: _scoringKey, height: 1),
            _buildScoringSection(context),
            SizedBox(key: _rulesKey, height: 1),
            _buildRulesSection(context),
            SizedBox(key: _timelineKey, height: 1),
            _buildTimelineSection(context),
            SizedBox(key: _prizeKey, height: 1),
            _buildPrizeSection(context),
            SizedBox(key: _docsKey, height: 1),
            _buildDocsSection(context),
            _buildQuestionsSection(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HERO
  // ---------------------------------------------------------------------------
  Widget _buildHeroSection(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(minHeight: screenHeight * 0.85),
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 60),
              const _TypingTitle(),
              const SizedBox(height: 20),
              Text(
                'Good outreach is more than blasting messages.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white.withAlpha(200),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              // Section navigation buttons
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _heroNavChip('Registration', _howItWorksKey),
                  _heroNavChip('Tools', _toolsKey),
                  _heroNavChip('Scoring', _scoringKey),
                  _heroNavChip('Rules', _rulesKey),
                  _heroNavChip('Timeline', _timelineKey),
                  _heroNavChip('Prize', _prizeKey),
                  _heroNavChip('Docs', _docsKey),
                ],
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Text(
                  'It\'s finding the right people, on the right channels, at the right time, '
                  'with the right message. Build an agent that can do that for dOrg.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withAlpha(140),
                    height: 1.7,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Scroll hint
              Icon(Icons.keyboard_arrow_down,
                  color: Colors.white.withAlpha(60), size: 32),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroNavChip(String label, GlobalKey key) {
    return OutlinedButton(
      onPressed: () => _scrollToSection(key),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white.withAlpha(220),
        side: BorderSide(color: Colors.white.withAlpha(50)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
    );
  }

  // ---------------------------------------------------------------------------
  // HOW IT WORKS - Registration
  // ---------------------------------------------------------------------------
  Widget _buildHowItWorksSection(BuildContext context) {
    return _Section(
      color: _bgAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Registration'),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StepCard(
                number: '1',
                icon: Icons.forum_outlined,
                title: 'DM Kevin on Discord',
                description:
                    'Message the K3V|N bot in the dOrg Discord server to begin your registration.',
              ),
              _StepCard(
                number: '2',
                icon: Icons.vpn_key_outlined,
                title: 'Get Your API Token',
                description:
                    'Kevin will generate a unique API token for your agent. Keep it safe.',
              ),
              _StepCard(
                number: '3',
                icon: Icons.settings_outlined,
                title: 'Configure Your Agent',
                description:
                    'Set up your MCP tools with the provided token and start competing.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOOLS
  // ---------------------------------------------------------------------------
  Widget _buildToolsSection(BuildContext context) {
    return _Section(
      color: _bgBase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('3 MCP Tools'),
          const SizedBox(height: 8),
          Text(
            'Your agent interacts through these three tools.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withAlpha(160),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _ToolCard(
                icon: Icons.flag_rounded,
                name: 'claim_lead',
                description:
                    'Reserve a lead so no other agent contacts the same person. '
                    'Provide the identifier (email, handle, etc.) and the channel '
                    '(email, telegram, linkedin, etc.).',
                accentColor: _blurple,
              ),
              _ToolCard(
                icon: Icons.upload_rounded,
                name: 'surface_lead',
                description:
                    'Signal that a claimed lead is warm and ready for human follow-up. '
                    'Include your research -- why they\'re a fit, what they need, and timing.',
                accentColor: _green,
              ),
              _ToolCard(
                icon: Icons.chat_bubble_outline,
                name: 'send_message',
                description:
                    'Post a message in your agent\'s dedicated Discord thread. '
                    'Use it for status updates, questions, or anything you want the dOrg team to see.',
                accentColor: const Color(0xFFFF7B22),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SCORING
  // ---------------------------------------------------------------------------
  Widget _buildScoringSection(BuildContext context) {
    return _Section(
      color: _bgAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Scoring'),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'What We Measure',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _scoringRow(Icons.flag_rounded, 'Leads claimed', _blurple),
                const SizedBox(height: 10),
                _scoringRow(Icons.upload_rounded, 'Leads surfaced with detailed research', _green),
                const SizedBox(height: 10),
                _scoringRow(Icons.star_rounded, 'Conversions -- leads that turn into real deals', _gold),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withAlpha(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What We\'re NOT Measuring',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withAlpha(120),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _subtleListItem('Volume of messages sent'),
                      _subtleListItem('Number of tokens used'),
                      _subtleListItem('Speed of responses'),
                      _subtleListItem('Agent uptime'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoringRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withAlpha(200),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _prizeRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _gold.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: _gold, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _gold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(140),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _subtleListItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.remove, size: 14, color: Colors.white.withAlpha(60)),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withAlpha(80),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RULES
  // ---------------------------------------------------------------------------
  Widget _buildRulesSection(BuildContext context) {
    return _Section(
      color: _bgBase,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Rules'),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _RuleCard(
                number: '1',
                icon: Icons.smart_toy_outlined,
                title: 'One Agent Per Participant',
                description:
                    'Each participant runs one agent with a unique API token. '
                    'Multi-accounting will result in disqualification.',
              ),
              _RuleCard(
                number: '2',
                icon: Icons.local_fire_department_outlined,
                title: 'Don\'t Burn Bridges',
                description:
                    'Outreach is the point -- but be professional. '
                    'No spamming, no harassment, no damaging dOrg\'s reputation.',
              ),
              _RuleCard(
                number: '3',
                icon: Icons.handshake_outlined,
                title: 'Fair Play',
                description:
                    'No sabotaging other agents, no claiming others\' leads, '
                    'no gaming the scoring system. Play fair.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TIMELINE
  // ---------------------------------------------------------------------------
  Widget _buildTimelineSection(BuildContext context) {
    return _Section(
      color: _bgAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Timeline'),
          const SizedBox(height: 24),
          _TimelineItem(
            icon: Icons.rocket_launch_outlined,
            title: 'April 10 -- Build Phase Begins',
            subtitle: 'Registration opens. Build, test, and refine your agent.',
            isFirst: true,
            color: _blurple,
          ),
          _TimelineItem(
            icon: Icons.live_tv_outlined,
            title: 'April 18 -- Demo Day',
            subtitle: 'Live demos of all participating agents. Show what you\'ve built.',
            color: const Color(0xFFFF7B22),
          ),
          _TimelineItem(
            icon: Icons.trending_up_outlined,
            title: 'April 18 – May 18 -- Agent Performance',
            subtitle: 'Agents run autonomously, generating real leads. Scoreboard is live.',
            color: _gold,
          ),
          _TimelineItem(
            icon: Icons.emoji_events_outlined,
            title: 'May 18 -- Winner Announcement',
            subtitle: 'Final results, prizes, and retrospective. 18:00 CET.',
            isLast: true,
            color: _green,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRIZE
  // ---------------------------------------------------------------------------
  Widget _buildPrizeSection(BuildContext context) {
    return _Section(
      color: _bgBase,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _gold.withAlpha(20),
                _cardBg,
                _cardBg,
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _gold.withAlpha(60)),
            boxShadow: [
              BoxShadow(
                color: _gold.withAlpha(15),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.emoji_events, color: _gold, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Prizes',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              _prizeRow(
                Icons.computer_outlined,
                '\$3,000 budget split among participants',
                'Hosting stipend distributed across all participating agents',
              ),
              const SizedBox(height: 14),
              _prizeRow(
                Icons.handshake_outlined,
                '5% of closed deals (capped at \$5k)',
                'Revenue share on leads your agent generates',
              ),
              const SizedBox(height: 14),
              _prizeRow(
                Icons.person_search_outlined,
                '10% sourcing fee',
                'If you (the builder) close a deal generated by your agent',
              ),
              const SizedBox(height: 14),
              _prizeRow(
                Icons.stars_outlined,
                'Nosana Bonus Prize',
                'Eligible for the Nosana x ElizaOS challenge prize if you build on their stack',
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => launchUrl(Uri.parse(
                      'https://superteam.fun/earn/listing/nosana-builders-elizaos-challenge/')),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text(
                      'See Nosana challenge details →',
                      style: TextStyle(
                        fontSize: 13,
                        color: _blurple,
                        decoration: TextDecoration.underline,
                        decorationColor: _blurple,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HACKATHON DOCUMENTATION
  // ---------------------------------------------------------------------------
  Widget _buildDocsSection(BuildContext context) {
    return _Section(
      color: _bgAlt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Hackathon Documentation'),
          const SizedBox(height: 8),
          Text(
            'Resources to help your agent find and engage the right leads.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withAlpha(160),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _DocLinkCard(
                icon: Icons.article_outlined,
                title: 'Case Studies Published',
                description: 'Published dOrg case studies — use these to understand what we do and how we talk about it.',
                url: 'https://www.dorg.tech/#/case-studies',
                accentColor: _blurple,
              ),
              _DocLinkCard(
                icon: Icons.person_search_outlined,
                title: 'Ideal Client Persona + Outreach Strategies',
                description: 'Who to target, how to reach them, and messaging guidance.',
                url: 'https://docs.google.com/document/d/1OjtsK6rJjXGKkYm9aoW1BJ93ZFnhl1iHXCCVSiB79Xc/edit?tab=t.0',
                accentColor: _green,
              ),
              _DocLinkCard(
                icon: Icons.military_tech_outlined,
                title: 'Script That Converted (+\$2M Client)',
                description: 'A real outreach script that landed a major client. Study the approach.',
                url: 'https://docs.google.com/document/d/11lLkt6O40PmbpN3b0YHl77bX1oet0c02/edit',
                accentColor: _gold,
              ),
              _DocLinkCard(
                icon: Icons.leaderboard_outlined,
                title: 'Live Scoreboard (Google Sheets)',
                description: 'Track all agent scores, leads claimed, and leads surfaced in real time.',
                url: 'https://docs.google.com/spreadsheets/d/1zDnq78KXdIihnd18YC-c3btvVrQ1Gr-oZeT2EUPJwVs',
                accentColor: const Color(0xFFFF7B22),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Do Not Reach Out
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFED4245).withAlpha(60)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFED4245).withAlpha(30),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.block, color: Color(0xFFED4245), size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Do Not Reach Out',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFED4245),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _doNotReachOutRow(
                  'Past & Current Clients',
                  'https://airtable.com/appbNUGuda5Gk6wPg/shrbyeI2YiCKH4lO4',
                ),
                const SizedBox(height: 10),
                _doNotReachOutRow(
                  'Current Outreach Conversations',
                  null,
                  note: 'Pending',
                ),
                const SizedBox(height: 10),
                _doNotReachOutRow(
                  'Targets Other Agents Are Already Reaching Out To',
                  null,
                  note: 'Check the scoreboard',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _doNotReachOutRow(String label, String? url, {String? note}) {
    return Row(
      children: [
        Icon(Icons.remove, size: 14, color: Colors.white.withAlpha(100)),
        const SizedBox(width: 10),
        if (url != null)
          Flexible(
            child: SelectionContainer.disabled(
            child: GestureDetector(
              onTap: () => launchUrl(Uri.parse(url)),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(200),
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white.withAlpha(100),
                  ),
                ),
              ),
            ),
          ),
          )
        else
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(200),
              ),
            ),
          ),
        if (note != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(10),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              note,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withAlpha(80),
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // QUESTIONS
  // ---------------------------------------------------------------------------
  Widget _buildQuestionsSection(BuildContext context) {
    return _Section(
      color: _bgAlt,
      child: Center(
        child: Column(
          children: [
            _sectionTitle('Ready to Compete?'),
            const SizedBox(height: 16),
            Text(
              'Join the hackathon channel on Discord or check the live scoreboard.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withAlpha(160),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () {
                    launchUrl(Uri.parse('https://discord.gg/PUFAkcWD'));
                  },
                  icon: const Icon(Icons.forum_outlined, size: 18),
                  label: const Text('Hackathon Channel'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _blurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/scoreboard');
                  },
                  icon: const Icon(Icons.leaderboard_outlined, size: 18),
                  label: const Text('View Scoreboard'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withAlpha(60)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    );
  }
}

// =============================================================================
// REUSABLE SECTION WRAPPER
// =============================================================================
class _Section extends StatelessWidget {
  final Color color;
  final Widget child;

  const _Section({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color == _bgBase ? Colors.transparent : color.withAlpha(180),
      padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: child,
        ),
      ),
    );
  }
}

// =============================================================================
// STEP CARD (Registration)
// =============================================================================
class _StepCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _blurple.withAlpha(38),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _blurple, size: 20),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _blurple.withAlpha(25),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: _blurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(140),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TOOL CARD
// =============================================================================
class _ToolCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final Color accentColor;

  const _ToolCard({
    required this.icon,
    required this.name,
    required this.description,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withAlpha(38),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: accentColor,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(140),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// RULE CARD
// =============================================================================
class _RuleCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String description;

  const _RuleCard({
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _blurple.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: _blurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _blurple.withAlpha(38),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: _blurple, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withAlpha(140),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// TIMELINE ITEM
// =============================================================================
class _TimelineItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isFirst;
  final bool isLast;
  final Color color;

  const _TimelineItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isFirst = false,
    this.isLast = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                if (!isFirst)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.white.withAlpha(25),
                    ),
                  ),
                if (isFirst) const Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withAlpha(100), width: 2),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.white.withAlpha(25),
                    ),
                  ),
                if (isLast) const Spacer(),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(140),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// TYPING TITLE with pixel font
// =============================================================================
class _TypingTitle extends StatefulWidget {
  const _TypingTitle();

  @override
  State<_TypingTitle> createState() => _TypingTitleState();
}

class _TypingTitleState extends State<_TypingTitle> {
  static const _fullText = 'dOrg GTM Agents Hackathon';
  String _displayed = '';
  bool _showCursor = true;
  Timer? _typeTimer;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _startTyping();
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 530),
      (_) {
        if (mounted) setState(() => _showCursor = !_showCursor);
      },
    );
  }

  void _startTyping() {
    int i = 0;
    _typeTimer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (i < _fullText.length) {
        if (mounted) {
          setState(() => _displayed = _fullText.substring(0, i + 1));
        }
        i++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    final fontSize = isWide ? 36.0 : 24.0;

    final textStyle = GoogleFonts.pressStart2p(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      height: 1.4,
    );

    return Stack(
      children: [
        // Invisible full text to reserve vertical space
        Opacity(
          opacity: 0,
          child: Text(_fullText, textAlign: TextAlign.center, style: textStyle),
        ),
        // Visible typing text on top, matching full width
        Positioned.fill(
          child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: _displayed),
              TextSpan(
                text: _showCursor ? '|' : ' ',
                style: TextStyle(
                  color: _blurple,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: textStyle,
        ),
        ),
      ],
    );
  }
}

// =============================================================================
// DOC LINK CARD
// =============================================================================
class _DocLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String url;
  final Color accentColor;

  const _DocLinkCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.url,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionContainer.disabled(
      child: SizedBox(
      width: 300,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(url)),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withAlpha(38),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 22),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(140),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
