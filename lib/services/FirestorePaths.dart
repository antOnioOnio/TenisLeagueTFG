class FirestorePath {
  //static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String createUser(String uid) => 'users/$uid';
  static String users = 'users/';
  static String chats(String idUser) => 'chats/$idUser/messages';
  static String posts(String idPost) => 'posts/$idPost';
  static String commentCollection(String idPost) => 'posts/$idPost/comments';
  static String commentDoc(String idPost, String commentId) => 'posts/$idPost/comments/$commentId';
  static String postsCollection() => 'posts';

  //static String entry(String uid, String entryId) =>
  //    'users/$uid/entries/$entryId';
  //static String entries(String uid) => 'users/$uid/entries';
}
