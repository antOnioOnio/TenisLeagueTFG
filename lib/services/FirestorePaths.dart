class FirestorePath {
  //static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String createUser(String uid) => 'users/$uid';
  static String users = 'users/';
  static String chats(String idUser) => 'chats/$idUser/messages';

  //static String entry(String uid, String entryId) =>
  //    'users/$uid/entries/$entryId';
  //static String entries(String uid) => 'users/$uid/entries';
}
