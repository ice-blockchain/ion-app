String shortenAddress(String address) {
  assert(address.length == 42, 'Address must be 42 characters long');

  return '${address.substring(0, 12)}...'
      '${address.substring(address.length - 14, address.length)}';
}
