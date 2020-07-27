/*
 * @Description: Do not edit
 * @Author: haojieyu (haojieyu@novastar.tech)
 * @Date: 2020-06-02 18:29:42
 * @LastEditors: haojieyu
 * @LastEditTime: 2020-06-03 12:13:31
 */ 
// class ConnectCapacityModel{
//   int screenId;
//   List<ScreenSlotCard> slotList;
//   ConnectCapacityModel({this.screenId, this.slotList});
// }

class ScreenConnectCapacityModel{
  int screenId;
  int totalConnectCapacity;
  int occupiedConnectCapacity;
  ScreenConnectCapacityModel({this.screenId, this.totalConnectCapacity, this.occupiedConnectCapacity});
}

class SlotCard{
  int slotId;
  int totalConnectCapacity;
  int occupiedConnectCapacity;
  SlotCard({this.slotId, this.totalConnectCapacity, this.occupiedConnectCapacity});
}

class ScreenSlotCard{
  int slotId;
  int occupiedConnectCapacity;
  ScreenSlotCard({this.slotId, this.occupiedConnectCapacity});
}

// enum ConnectCapacity{
//   sl,
//   dl,
//   fourk
// }