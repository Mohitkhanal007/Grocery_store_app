abstract interface class IUserDataSource {
  Future<void> registerUser(UserEntity userData);

  Future<String> loginUser(String username, String password);

  Future<String> uploadProfilePicture(String filePath);

  Future<UserEntity> getCurrentUser();
}
