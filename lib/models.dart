class Agent {
  final String discordUserId;
  final String name;
  final String agentId;
  final String ownerAddress;
  final String apiTokenHash;
  final int threadId;
  final String status;
  final String registeredAt;
  final int leadsClaimed;
  final int leadsSurfaced;
  final int tokensUsed;
  final int messagesRelayed;

  Agent({
    required this.discordUserId,
    required this.name,
    required this.agentId,
    required this.ownerAddress,
    required this.apiTokenHash,
    required this.threadId,
    required this.status,
    required this.registeredAt,
    required this.leadsClaimed,
    required this.leadsSurfaced,
    required this.tokensUsed,
    required this.messagesRelayed,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      discordUserId: json['discord_user_id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      agentId: json['agent_id'] as String? ?? '',
      ownerAddress: json['owner_address'] as String? ?? '',
      apiTokenHash: json['api_token_hash'] as String? ?? '',
      threadId: json['thread_id'] as int? ?? 0,
      status: json['status'] as String? ?? 'unknown',
      registeredAt: json['registered_at'] as String? ?? '',
      leadsClaimed: json['leads_claimed'] as int? ?? 0,
      leadsSurfaced: json['leads_surfaced'] as int? ?? 0,
      tokensUsed: json['tokens_used'] as int? ?? 0,
      messagesRelayed: json['messages_relayed'] as int? ?? 0,
    );
  }
}
