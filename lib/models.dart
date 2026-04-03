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

class Lead {
  final String agentId;
  final String channel;
  final String identifier;
  final String status;
  final String? claimedAt;
  final String? brief;
  final String? surfacedAt;
  final bool converted;
  final String? convertedAt;
  final String id;

  Lead({
    required this.agentId,
    required this.channel,
    required this.identifier,
    required this.status,
    this.claimedAt,
    this.brief,
    this.surfacedAt,
    required this.converted,
    this.convertedAt,
    required this.id,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      agentId: json['agent_id'] as String? ?? '',
      channel: json['channel'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      status: json['status'] as String? ?? 'claimed',
      claimedAt: json['claimed_at'] as String?,
      brief: json['brief'] as String?,
      surfacedAt: json['surfaced_at'] as String?,
      converted: json['converted'] as bool? ?? false,
      convertedAt: json['converted_at'] as String?,
      id: json['id'] as String? ?? '',
    );
  }
}

class Activity {
  final String agentId;
  final String type;
  final String details;
  final String? leadId;
  final int tokens;
  final String createdAt;
  final int id;

  Activity({
    required this.agentId,
    required this.type,
    required this.details,
    this.leadId,
    required this.tokens,
    required this.createdAt,
    required this.id,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      agentId: json['agent_id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      details: json['details'] as String? ?? '',
      leadId: json['lead_id'] as String?,
      tokens: json['tokens'] as int? ?? 0,
      createdAt: json['created_at'] as String? ?? '',
      id: json['id'] as int? ?? 0,
    );
  }
}
