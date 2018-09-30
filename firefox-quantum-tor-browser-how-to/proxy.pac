function FindProxyForURL(url, host) { 
  if (shExpMatch(host, "*.i2p")) { return "PROXY 127.0.0.1:4444"; }
  if (shExpMatch(host, "localhost")) { return "DIRECT"; }
  if (shExpMatch(host, "127.0.0.*")) { return "DIRECT"; }
  if (shExpMatch(host, "192.168.*.*")) { return "DIRECT"; }
  return "SOCKS 127.0.0.1:9050";
}
