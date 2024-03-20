class PostData {
  PostData({
    required this.id,
    required this.body,
  });

  String id;
  String body;

  @override
  String toString() => 'PostData(id: $id, body: $body)';
}
