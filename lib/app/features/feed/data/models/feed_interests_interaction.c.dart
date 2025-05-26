enum FeedInterestInteraction {
  likeReply(1),
  likePostOrArticle(2),
  addNestedReply(3),
  addTopReply(4),
  repost(5),
  quote(6),
  createPost(10),
  createArticle(20);

  const FeedInterestInteraction(this.score);

  final int score;
}
