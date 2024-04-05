String shortenAddress(String address) {
  assert(address.length == 42);

  final int lastIndex = address.length - 1;
  return '${address.substring(0, 12)}...${address.substring(lastIndex - 14, lastIndex)}';
}
