class UserHelper{

}

class User{

  String id;
  String name;
  String email;
  String password;

  User({this.id, this.name, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json){
        return User(
          id: json['_id'], name: json["name"], email: json["email"], password: json["password"],
        );
  }



}