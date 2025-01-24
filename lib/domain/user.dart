abstract class User {
  static String currentUserEmail = '';
  static String currentUserName = '';
  static Map<String, String> users = {};

  static void addUser(String email, String username) {
    if (!users.containsKey(email)) {
      users[email] = username;
      currentUserEmail = email;
      currentUserName = username;
    } else {
      print('O email já está registrado.');
    }
  }

  static void getUserByEmail(String email) {
    if (users.containsKey(email)) {
      currentUserName = users[email]!;
      currentUserEmail = email;
    } else {
      print('Usuário não encontrado.');
    }
  }
}
