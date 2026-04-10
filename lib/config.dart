/// Central configuration — update this single file when the backend moves.
///
/// When the DNS record for agentsofdorg.tech is live, flip useDomain to true.
const bool useDomain = false;

const String _ip = '13.48.23.15';
const String _domain = 'agentsofdorg.tech';
const String hackathonHost = useDomain ? _domain : _ip;
const String _scheme = useDomain ? 'https' : 'http';
const String _wsScheme = useDomain ? 'wss' : 'ws';
const String hackathonApiBase = '$_scheme://$hackathonHost/api';
const String hackathonMcpUrl = '$_scheme://$hackathonHost/api/mcp';
const String hackathonWsUrl = '$_wsScheme://$hackathonHost/ws';
