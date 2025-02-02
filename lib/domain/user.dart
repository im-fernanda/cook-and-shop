abstract class User {
  static String currentUserEmail = '';
  static Map<String, String> users = {};

  static void addUser(String email) {
    if (!users.containsKey(email)) {
      currentUserEmail = email;
    } else {
      print('O email já está registrado.');
    }
  }

  static void getUserByEmail(String email) {
    if (users.containsKey(email)) {
      currentUserEmail = email;
    } else {
      print('Usuário não encontrado.');
    }
  }
}
