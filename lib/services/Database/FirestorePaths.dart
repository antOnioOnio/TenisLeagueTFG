class FirestorePath {
  static String userPath(String uid) => 'users/$uid';
  static String users = 'users/';
  static String chats(String idUser) => 'chats/$idUser/messages';
  static String posts(String idPost) => 'posts/$idPost';
  static String commentCollection(String idPost) => 'posts/$idPost/comments';
  static String commentDoc(String idPost, String commentId) => 'posts/$idPost/comments/$commentId';
  static String postsCollection() => 'posts';
  static String places(String idPlace) => 'places/$idPlace';
  static String placesCollection() => 'places/';

  static String leaguesStream = 'leagues/';
  static String tournamentStream = 'tournament/';
  static String leagues(String idLeague) => 'leagues/$idLeague';
  static String matches(String idLeague) => 'leagues/$idLeague/matches/';
  static String match(String idLeague, String idMatch) => 'leagues/$idLeague/matches/$idMatch';

  static String tournament(String idLeague) => 'tournament/$idLeague';
  static String matchesTournament(String idTournament) => 'tournament/$idTournament/matches/';
  static String matchTournament(String idTournament, String idMatch) => 'tournament/$idTournament/matches/$idMatch';
}
