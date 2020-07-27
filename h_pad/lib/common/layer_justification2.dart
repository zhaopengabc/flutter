// /*
//  * @Description: Do not edit
//  * @Author: haojieyu (haojieyu@novastar.tech)
//  * @Date: 2020-06-12 11:42:37
//  * @LastEditors: haojieyu
//  * @LastEditTime: 2020-06-17 15:10:27
//  */ 
// import 'package:flutter/cupertino.dart';
// import 'package:h_pad/common/component_index.dart';
// import 'package:h_pad/models/screen/LayerPosition.dart';
// import 'package:h_pad/states/edit/LayerProvider.dart';
// import 'package:h_pad/states/edit/RenderBoxProvider.dart';
// import 'package:provider/provider.dart';

// class LayerJustification{
//   static const justifiedDistance = 5;
//   static List<Position> compareList;
//   static setCompareList(List<Position> value){
//     compareList = value;
//   }

//   static adsorb(BuildContext context, CustomerLayer layer, double currOffsetX, double currOffsetY, double preOffsetX, double preOffsetY){ 
//     AdsorbedPosition ret;
    
//     // print('比对的数组长度----------${outoutcards.length}');
//     if(compareList == null) return ret;
//     // print('前一个值------x:${layer.layerPosition.left}----y:${layer.layerPosition.top}');
//     // print('当前值------x:${currOffsetX}------y:${currOffsetY}');
//     // print('===========================================================================>>>>>>>>>>>>>>>>>>>');
//     MoveDirection direction = movingDirection(preOffsetX, preOffsetY, currOffsetX, currOffsetY);
//     if(direction == MoveDirection.top){
//       // print('top');
//       List<Position> findOutPutCard = compareList.where((p) => (currOffsetY - p.top).abs() <= Utils.setHeight(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.top);
//       if(p != null){
//         print('top-------------------${p.top}');
//         ret = new AdsorbedPosition(vertical: p.top, moveDirection: MoveDirection.top);
//       }
//     }
//     else if(direction == MoveDirection.bottom){
//       print('bottom');
//       List<Position> findOutPutCard = compareList.where((p) => (p.top - (currOffsetY + layer.layerPosition.height)).abs()  <= Utils.setHeight(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.bottom);
//       if(p!=null){
//         print('bottom------------------${p.top + p.height - layer.layerPosition.height}');
//         ret = new AdsorbedPosition(vertical: p.top - layer.layerPosition.height, moveDirection: MoveDirection.bottom);
//       }
//     }
//     else if(direction == MoveDirection.left){
//       print('left');
//       List<Position> findOutPutCard = compareList.where((p) => (currOffsetX - p.left).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.left);
//       if(p!=null){
//         ret = new AdsorbedPosition(horizontal: p.left, moveDirection: MoveDirection.left);
//       }
//     }else if(direction == MoveDirection.right){
//       print('right');
//       List<Position> findOutPutCard = compareList.where((p) => (p.left - (currOffsetX + layer.layerPosition.width)).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.right);
//       if(p!=null){
//         ret = new AdsorbedPosition(horizontal: p.left - layer.layerPosition.width, moveDirection: MoveDirection.right);
//       }
//     }else if(direction == MoveDirection.leftTop){
//       print('leftTop');
//       List<Position> findOutPutCardLeft = compareList.where((p) => (currOffsetX - p.left).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       List<Position> findOutPutCardTop = compareList.where((p) => (currOffsetY - p.top).abs() <= Utils.setHeight(justifiedDistance)).toList();
//       Position pLeft = findMin(findOutPutCardLeft, MoveDirection.left);
//       Position pTop = findMin(findOutPutCardTop, MoveDirection.top);
//       print('lefttop---------${pLeft?.left}----------${pLeft?.top}');
//       print('lefttop---------${pTop?.left}----------${pTop?.top}');
//       ret = new AdsorbedPosition(horizontal: pLeft?.left, vertical: pTop?.top);
//     }else if(direction == MoveDirection.leftBottom){
//       print('leftBottom');
//       List<Position> findOutPutCardLeft = compareList.where((p) => (currOffsetX - p.left).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       List<Position> findOutPutCardBottom = compareList.where((p) => (p.top - (currOffsetY + layer.layerPosition.height)).abs()  <= Utils.setHeight(justifiedDistance)).toList();
//       Position pLeft = findMin(findOutPutCardLeft, MoveDirection.left);
//       Position pBottom = findMin(findOutPutCardBottom, MoveDirection.bottom);
//       ret = new AdsorbedPosition(horizontal: pLeft?.left, vertical: pBottom?.top);
//       if(ret.vertical!=null){
//         ret.vertical =  ret.vertical - layer.layerPosition.height;//currOffsetY + dis;
//       }
//     }else if(direction == MoveDirection.rightTop){
//       print('rightTop');
//       List<Position> findOutPutCardRight = compareList.where((p) => (p.left - (currOffsetX + layer.layerPosition.width)).abs()  <= Utils.setWidth(justifiedDistance)).toList();
//       List<Position> findOutPutCardTop = compareList.where((p) => (currOffsetY - p.top).abs() <= Utils.setHeight(justifiedDistance)).toList();
//       Position pRight = findMin(findOutPutCardRight, MoveDirection.right);
//       Position pTop = findMin(findOutPutCardTop, MoveDirection.top);
//       ret = new AdsorbedPosition(horizontal: pRight?.left, vertical: pTop?.top);
//       if(ret.horizontal!=null){
//         ret.horizontal = ret.horizontal - layer.layerPosition.width;//currOffsetX + dis;
//       }

//     }else if(direction == MoveDirection.rightBottom){
//       print('rightBottom');
//       List<Position> findOutPutCardRight = compareList.where((p) => (p.left - (currOffsetX + layer.layerPosition.width)).abs()  <= Utils.setWidth(justifiedDistance)).toList();
//       List<Position> findOutPutCardBottom = compareList.where((p) => (p.top - (currOffsetY + layer.layerPosition.height)).abs()  <= Utils.setHeight(justifiedDistance)).toList();
//       Position pRight = findMin(findOutPutCardRight, MoveDirection.right);
//       Position pBottom = findMin(findOutPutCardBottom, MoveDirection.bottom);
//       ret = new AdsorbedPosition(horizontal: pRight?.left, vertical: pBottom?.top);
//       if(ret.horizontal!=null){
//         ret.horizontal = ret.horizontal - layer.layerPosition.width;//currOffsetX + dis;
//       }
//       if(ret.vertical!=null){
//         ret.vertical = ret.vertical - layer.layerPosition.height;//currOffsetY + dis;
//       }
//     }
//     else{
//       print('other');
//       ret = null;
//     }
//     return ret;                   
//   }

//   static Position findMin(List<Position> findOutPutCard, MoveDirection direction){
//     Position ret;
//     if(findOutPutCard == null) return ret;
//     if(findOutPutCard.length > 0) {
//       if(findOutPutCard.length > 1) {
//         switch(direction){
//           case MoveDirection.top:
//             findOutPutCard.sort((a,b) => (a.top).compareTo(b.top));
//             break;
//           case MoveDirection.bottom:
//             findOutPutCard.sort((a,b) => (b.top).compareTo(a.top));
//             break;
//           case MoveDirection.left:
//             findOutPutCard.sort((a,b) => (a.left).compareTo(b.left));
//             break;
//           case MoveDirection.right:
//             findOutPutCard.sort((a,b) => (b.left).compareTo(a.left));
//             break;
//           default:
//             break;
//         }
//       }
//       ret = findOutPutCard[0];
//     }
//     return ret;
//   }

//   static MoveDirection movingDirection(double preOffsetX, double preOffsetY, double currOffsetX, double currOffsetY){
//     MoveDirection direction = MoveDirection.none;
//     MoveDirection verticalDirection = movingDirectionVertical(preOffsetY, currOffsetY);
//     if(currOffsetX - preOffsetX >= 0) { //向右
//       switch(verticalDirection) {
//         case MoveDirection.top:
//           direction = MoveDirection.rightTop;
//           break;
//         case MoveDirection.bottom:
//           direction = MoveDirection.rightBottom;
//           break;
//         case MoveDirection.left:  
//         case MoveDirection.right:
//         case MoveDirection.rightTop:
//         case MoveDirection.rightBottom:
//         case MoveDirection.leftTop:
//         case MoveDirection.leftBottom:
//         case MoveDirection.none:
//           direction = MoveDirection.right;
//           break;  
//       }
//     }else if(currOffsetX - preOffsetX < 0){ //向左
//       switch(verticalDirection) {
//         case MoveDirection.top:
//           direction = MoveDirection.leftTop;
//           break;
//         case MoveDirection.bottom:
//           direction = MoveDirection.leftBottom;
//           break;
//         case MoveDirection.left:  
//         case MoveDirection.right:
//         case MoveDirection.rightTop:
//         case MoveDirection.rightBottom:
//         case MoveDirection.leftTop:
//         case MoveDirection.leftBottom:
//         case MoveDirection.none:
//           direction = MoveDirection.left;
//           break;  
//       }

//     }else{ //水平无偏移
//       switch(verticalDirection) {
//         case MoveDirection.top:
//           direction = MoveDirection.top;
//           break;
//         case MoveDirection.bottom:
//           direction = MoveDirection.bottom;
//           break;
//         case MoveDirection.left:  
//         case MoveDirection.right:
//         case MoveDirection.rightTop:
//         case MoveDirection.rightBottom:
//         case MoveDirection.leftTop:
//         case MoveDirection.leftBottom:
//         case MoveDirection.none:
//           direction = MoveDirection.none;
//           break;  
//       }
//     }
    
//     // direction = verticalDirection;
//     return direction;
//   }
//   static MoveDirection movingDirectionVertical(double preOffsetY, double currOffsetY){
//     MoveDirection direction = MoveDirection.none;
//     if(currOffsetY - preOffsetY > 0){ //向下
//       direction = MoveDirection.bottom;
//     }else if(currOffsetY - preOffsetY < 0){ //向上
//       direction = MoveDirection.top;
//     }else{ //垂直无偏移
//       direction = MoveDirection.none;
//     }
//     return direction;
//   }

// }

// enum MoveDirection{
//   left,
//   right,
//   top,
//   bottom,
//   leftTop,
//   leftBottom,
//   rightTop,
//   rightBottom,
//   none
// }