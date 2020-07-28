class DeviceDetail {
	int deviceId;
	int ethernetStatus;
	String name;
	int status;
	String protoVersion;
	String mAC;
	int volt;
	int temp;
	int extSignal;
	int dataVersion;
	List<SlotList> slotList;
	List<PowerList> powerList;
	List<FanList> fanList;
	Genlock genlock;
	Genlock network;

	DeviceDetail({this.deviceId, this.ethernetStatus, this.name, this.status, this.protoVersion, this.mAC, this.volt, this.temp, this.extSignal, this.dataVersion, this.slotList, this.powerList, this.fanList, this.genlock, this.network});

	DeviceDetail.fromJson(Map<String, dynamic> json) {
		deviceId = json['deviceId'];
		ethernetStatus = json['ethernetStatus'];
		name = json['name'];
		status = json['status'];
		protoVersion = json['protoVersion'];
		mAC = json['MAC'];
		volt = json['volt'];
		temp = json['temp'];
		extSignal = json['extSignal'];
		dataVersion = json['dataVersion'];
		if (json['slotList'] != null) {
			slotList = new List<SlotList>();
			json['slotList'].forEach((v) { slotList.add(new SlotList.fromJson(v)); });
		}
		if (json['powerList'] != null) {
			powerList = new List<PowerList>();
			json['powerList'].forEach((v) { powerList.add(new PowerList.fromJson(v)); });
		}
		if (json['fanList'] != null) {
			fanList = new List<FanList>();
			json['fanList'].forEach((v) { fanList.add(new FanList.fromJson(v)); });
		}
		genlock = json['genlock'] != null ? new Genlock.fromJson(json['genlock']) : null;
		network = json['network'] != null ? new Genlock.fromJson(json['network']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['deviceId'] = this.deviceId;
		data['ethernetStatus'] = this.ethernetStatus;
		data['name'] = this.name;
		data['status'] = this.status;
		data['protoVersion'] = this.protoVersion;
		data['MAC'] = this.mAC;
		data['volt'] = this.volt;
		data['temp'] = this.temp;
		data['extSignal'] = this.extSignal;
		data['dataVersion'] = this.dataVersion;
		if (this.slotList != null) {
      data['slotList'] = this.slotList.map((v) => v.toJson()).toList();
    }
		if (this.powerList != null) {
      data['powerList'] = this.powerList.map((v) => v.toJson()).toList();
    }
		if (this.fanList != null) {
      data['fanList'] = this.fanList.map((v) => v.toJson()).toList();
    }
		if (this.genlock != null) {
      data['genlock'] = this.genlock.toJson();
    }
		if (this.network != null) {
      data['network'] = this.network.toJson();
    }
		return data;
	}
}
//slot列表
class SlotList {
	int slotId;
	int modelId;
	int cardType;
	List<Interfaces> interfaces;
	Linkstatus linkstatus;
	Lightstatus lightstatus;

	SlotList({this.slotId, this.modelId, this.cardType, this.interfaces, this.linkstatus, this.lightstatus});

	SlotList.fromJson(Map<String, dynamic> json) {
		slotId = json['slotId'];
		modelId = json['modelId'];
		cardType = json['cardType'];
		if (json['interfaces'] != null) {
			interfaces = new List<Interfaces>();
			json['interfaces'].forEach((v) { interfaces.add(new Interfaces.fromJson(v)); });
		}
		linkstatus = json['linkstatus'] != null ? new Linkstatus.fromJson(json['linkstatus']) : null;
		lightstatus = json['lightstatus'] != null ? new Lightstatus.fromJson(json['lightstatus']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['slotId'] = this.slotId;
		data['modelId'] = this.modelId;
		data['cardType'] = this.cardType;
		if (this.interfaces != null) {
      data['interfaces'] = this.interfaces.map((v) => v.toJson()).toList();
    }
		if (this.linkstatus != null) {
      data['linkstatus'] = this.linkstatus.toJson();
    }
		if (this.lightstatus != null) {
      data['lightstatus'] = this.lightstatus.toJson();
    }
		return data;
	}
}
//接口列表
class Interfaces {
	int interfaceId;
	int interfaceType;
	int iSignal;
	int isUsed;

	Interfaces({this.interfaceId, this.interfaceType, this.iSignal, this.isUsed});

	Interfaces.fromJson(Map<String, dynamic> json) {
		interfaceId = json['interfaceId'];
		interfaceType = json['interfaceType'];
		iSignal = json['iSignal'];
		isUsed = json['isUsed'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['interfaceId'] = this.interfaceId;
		data['interfaceType'] = this.interfaceType;
		data['iSignal'] = this.iSignal;
		data['isUsed'] = this.isUsed;
		return data;
	}
}

class Linkstatus {
	int link0;
	int link1;
	int link10;
	int link11;
	int link12;
	int link13;
	int link14;
	int link15;
	int link2;
	int link3;
	int link4;
	int link5;
	int link6;
	int link7;
	int link8;
	int link9;

	Linkstatus({this.link0, this.link1, this.link10, this.link11, this.link12, this.link13, this.link14, this.link15, this.link2, this.link3, this.link4, this.link5, this.link6, this.link7, this.link8, this.link9});

	Linkstatus.fromJson(Map<String, dynamic> json) {
		link0 = json['link0'];
		link1 = json['link1'];
		link10 = json['link10'];
		link11 = json['link11'];
		link12 = json['link12'];
		link13 = json['link13'];
		link14 = json['link14'];
		link15 = json['link15'];
		link2 = json['link2'];
		link3 = json['link3'];
		link4 = json['link4'];
		link5 = json['link5'];
		link6 = json['link6'];
		link7 = json['link7'];
		link8 = json['link8'];
		link9 = json['link9'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['link0'] = this.link0;
		data['link1'] = this.link1;
		data['link10'] = this.link10;
		data['link11'] = this.link11;
		data['link12'] = this.link12;
		data['link13'] = this.link13;
		data['link14'] = this.link14;
		data['link15'] = this.link15;
		data['link2'] = this.link2;
		data['link3'] = this.link3;
		data['link4'] = this.link4;
		data['link5'] = this.link5;
		data['link6'] = this.link6;
		data['link7'] = this.link7;
		data['link8'] = this.link8;
		data['link9'] = this.link9;
		return data;
	}
}

class Lightstatus {
	int link0;
	int link1;

	Lightstatus({this.link0, this.link1});

	Lightstatus.fromJson(Map<String, dynamic> json) {
		link0 = json['link0'];
		link1 = json['link1'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['link0'] = this.link0;
		data['link1'] = this.link1;
		return data;
	}
}
//参考电源对象列表
class PowerList {
	int powerId;
	int iSignal;

	PowerList({this.powerId, this.iSignal});

	PowerList.fromJson(Map<String, dynamic> json) {
		powerId = json['powerId'];
		iSignal = json['iSignal'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['powerId'] = this.powerId;
		data['iSignal'] = this.iSignal;
		return data;
	}
}
//风扇状态
class FanList {
	int fanId;
	int status;

	FanList({this.fanId, this.status});

	FanList.fromJson(Map<String, dynamic> json) {
		fanId = json['fanId'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['fanId'] = this.fanId;
		data['status'] = this.status;
		return data;
	}
}

//genlock
class Genlock {
  int deviceId;
  int enable;
  int type;
  int inputId;
  int extSignal;

  Genlock(
      {this.deviceId, this.enable, this.type, this.inputId, this.extSignal});

  Genlock.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    enable = json['enable'];
    type = json['type'];
    inputId = json['inputId'];
    extSignal = json['extSignal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['enable'] = this.enable;
    data['type'] = this.type;
    data['inputId'] = this.inputId;
    data['extSignal'] = this.extSignal;
    return data;
  }
}
//网络
class Network {
  int mode;
  int dhcp;
  int deviceId;
  Ip ip;
  SubnetMask subnetMask;
  Gateway gateway;

  Network(
      {this.mode,
      this.dhcp,
      this.deviceId,
      this.ip,
      this.subnetMask,
      this.gateway});

  Network.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    dhcp = json['dhcp'];
    deviceId = json['deviceId'];
    ip = json['ip'] != null ? new Ip.fromJson(json['ip']) : null;
    subnetMask = json['subnetMask'] != null
        ? new SubnetMask.fromJson(json['subnetMask'])
        : null;
    gateway =
        json['gateway'] != null ? new Gateway.fromJson(json['gateway']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mode'] = this.mode;
    data['dhcp'] = this.dhcp;
    data['deviceId'] = this.deviceId;
    if (this.ip != null) {
      data['ip'] = this.ip.toJson();
    }
    if (this.subnetMask != null) {
      data['subnetMask'] = this.subnetMask.toJson();
    }
    if (this.gateway != null) {
      data['gateway'] = this.gateway.toJson();
    }
    return data;
  }
}

class Ip {
  int ip0;
  int ip1;
  int ip2;
  int ip3;

  Ip({this.ip0, this.ip1, this.ip2, this.ip3});

  Ip.fromJson(Map<String, dynamic> json) {
    ip0 = json['ip0'];
    ip1 = json['ip1'];
    ip2 = json['ip2'];
    ip3 = json['ip3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip0'] = this.ip0;
    data['ip1'] = this.ip1;
    data['ip2'] = this.ip2;
    data['ip3'] = this.ip3;
    return data;
  }
}

class SubnetMask {
  int subnetMask0;
  int subnetMask1;
  int subnetMask2;
  int subnetMask3;

  SubnetMask(
      {this.subnetMask0, this.subnetMask1, this.subnetMask2, this.subnetMask3});

  SubnetMask.fromJson(Map<String, dynamic> json) {
    subnetMask0 = json['subnetMask0'];
    subnetMask1 = json['subnetMask1'];
    subnetMask2 = json['subnetMask2'];
    subnetMask3 = json['subnetMask3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subnetMask0'] = this.subnetMask0;
    data['subnetMask1'] = this.subnetMask1;
    data['subnetMask2'] = this.subnetMask2;
    data['subnetMask3'] = this.subnetMask3;
    return data;
  }
}

class Gateway {
  int gateway0;
  int gateway1;
  int gateway2;
  int gateway3;

  Gateway({this.gateway0, this.gateway1, this.gateway2, this.gateway3});

  Gateway.fromJson(Map<String, dynamic> json) {
    gateway0 = json['gateway0'];
    gateway1 = json['gateway1'];
    gateway2 = json['gateway2'];
    gateway3 = json['gateway3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gateway0'] = this.gateway0;
    data['gateway1'] = this.gateway1;
    data['gateway2'] = this.gateway2;
    data['gateway3'] = this.gateway3;
    return data;
  }
}
//编码
class Encoding {
  String mvrUrl;
  String echoUrl;

  Encoding({this.mvrUrl, this.echoUrl});

  Encoding.fromJson(Map<String, dynamic> json) {
    mvrUrl = json['mvrUrl'];
    echoUrl = json['echoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mvrUrl'] = this.mvrUrl;
    data['echoUrl'] = this.echoUrl;
    return data;
  }
}