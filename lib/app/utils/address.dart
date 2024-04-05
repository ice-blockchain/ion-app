String shortenAddress(String address) {
  assert(address.length == 42);

  return '${address.substring(0, 12)}...${address.substring(address.length - 14, address.length)}';
}
