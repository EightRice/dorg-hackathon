/// Central configuration — update this single file when the backend moves.
///
/// For production behind nginx on the same origin, use '/api'.
/// For direct access to the EC2, use 'http://13.48.23.15:8000'.
const String hackathonHost = '13.48.23.15';
const String hackathonApiBase = 'http://$hackathonHost/api';
const String hackathonMcpUrl = 'http://$hackathonHost/api/mcp';
const String hackathonWsUrl = 'ws://$hackathonHost/ws';
