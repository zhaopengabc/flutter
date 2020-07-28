class UserExtral{
  String token;
  int deviceid;
  int userId;
  String userName;
  int isAdmin;
  List<UserFuncs> userFuncs;

  UserExtral(
      {this.token,
      this.deviceid,
      this.userId,
      this.userName,
      this.isAdmin,
      this.userFuncs});

  UserExtral.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    deviceid = json['deviceid'];
    userId = json['userId'];
    userName = json['userName'];
    isAdmin = json['isAdmin'];
    if (json['userFuncs'] != null) {
      userFuncs = new List<UserFuncs>();
      json['userFuncs'].forEach((v) {
        userFuncs.add(new UserFuncs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['deviceid'] = this.deviceid;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['isAdmin'] = this.isAdmin;
    if (this.userFuncs != null) {
      data['userFuncs'] = this.userFuncs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserFuncs {
  int active;
  int authed;
  Null brief;
  int display;
  String endpoint;
  int id;
  int level;
  String name;
  int parentId;
  List<Funcs> funcs;

  UserFuncs(
      {this.active,
      this.authed,
      this.brief,
      this.display,
      this.endpoint,
      this.id,
      this.level,
      this.name,
      this.parentId,
      this.funcs});

  UserFuncs.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    authed = json['authed'];
    brief = json['brief'];
    display = json['display'];
    endpoint = json['endpoint'];
    id = json['id'];
    level = json['level'];
    name = json['name'];
    parentId = json['parentId'];
    if (json['funcs'] != null) {
      funcs = new List<Funcs>();
      json['funcs'].forEach((v) {
        funcs.add(new Funcs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['authed'] = this.authed;
    data['brief'] = this.brief;
    data['display'] = this.display;
    data['endpoint'] = this.endpoint;
    data['id'] = this.id;
    data['level'] = this.level;
    data['name'] = this.name;
    data['parentId'] = this.parentId;
    if (this.funcs != null) {
      data['funcs'] = this.funcs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Funcs {
  int active;
  Null brief;
  int display;
  String endpoint;
  int id;
  int level;
  String name;
  int parentId;

  Funcs(
      {this.active,
      this.brief,
      this.display,
      this.endpoint,
      this.id,
      this.level,
      this.name,
      this.parentId});

  Funcs.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    brief = json['brief'];
    display = json['display'];
    endpoint = json['endpoint'];
    id = json['id'];
    level = json['level'];
    name = json['name'];
    parentId = json['parentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['brief'] = this.brief;
    data['display'] = this.display;
    data['endpoint'] = this.endpoint;
    data['id'] = this.id;
    data['level'] = this.level;
    data['name'] = this.name;
    data['parentId'] = this.parentId;
    return data;
  }
}