class UserInfor {
  late final String userName;
  late final String email;

  UserInfor(this.userName,this.email);

  UserInfor.emtpy(){
    userName = '';
    email = '';
  }
  factory UserInfor.fromRTDB(Map<String, dynamic> data){
    return UserInfor(data['userName'], data['email']);
  }

}