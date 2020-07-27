// /*
//  * @Description: Do not edit
//  * @Author: haojieyu (haojieyu@novastar.tech)
//  * @Date: 2020-06-17 11:07:48
//  * @LastEditors: haojieyu
//  * @LastEditTime: 2020-06-17 16:42:24
//  */ 
// /*
//  * @Description: Do not edit
//  * @Author: haojieyu (haojieyu@novastar.tech)
//  * @Date: 2020-06-12 11:42:37
//  * @LastEditors: haojieyu
//  * @LastEditTime: 2020-06-17 10:47:38
//  */ 
// import 'package:flutter/cupertino.dart';
// import 'package:h_pad/common/component_index.dart';
// import 'package:h_pad/models/screen/LayerPosition.dart';

// class LayerJustification{
//   static const justifiedDistance = 8;
//   static List<Position> compareList;
//   static setCompareList(List<Position> value){
//     compareList = value;
//   }
//   static List<Point> points = new List();
//   static List<MoveDirection> directions = new List();
//   static clearPoints(){
//     points.clear();
//     directions.clear();
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
//       List<Position> findOutPutCardTop = compareList.where((p) => (currOffsetY - p.top).abs() <= Utils.setHeight(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCardTop, MoveDirection.top);
//       if(p != null){
//         print('top-----------------$currOffsetX-------------------${p.top}');
//         ret = new AdsorbedPosition(vertical: p.top, moveDirection: MoveDirection.top);
//       }
//     }
//     else if(direction == MoveDirection.bottom){
//       List<Position> findOutPutCard = compareList.where((p) => (p.top - (currOffsetY + layer.layerPosition.height)).abs()  <= Utils.setHeight(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.bottom);
//       if(p!=null){
//         print('bottom-------$currOffsetX------------------${p.top - layer.layerPosition.height}');
//         ret = new AdsorbedPosition(vertical: p.top - layer.layerPosition.height, moveDirection: MoveDirection.bottom);
//       }
//     }
//     else if(direction == MoveDirection.left){
//       List<Position> findOutPutCard = compareList.where((p) => (currOffsetX - p.left).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.left);
//       if(p!=null){
//         print('left-----------${p.left}---------$currOffsetY');
//         ret = new AdsorbedPosition(horizontal: p.left, moveDirection: MoveDirection.left);
//       }
//     }else if(direction == MoveDirection.right){
//       List<Position> findOutPutCard = compareList.where((p) => (p.left - (currOffsetX + layer.layerPosition.width)).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.right);
//       if(p!=null){
//         print('right---------${p.left - layer.layerPosition.width}--------$currOffsetY');

//         ret = new AdsorbedPosition(horizontal: p.left - layer.layerPosition.width, moveDirection: MoveDirection.right);
//       }
//     }
//     else{
//       print('other');
//       ret = new AdsorbedPosition(moveDirection: MoveDirection.none);
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
//     points.add(new Point(offsetX: currOffsetX, offsetY: currOffsetY));
//     if(points.length < 6) return direction;
//     double horizitalDis = points[points.length -1].offsetX - points[0].offsetX;
//     double verticalDis = points[points.length -1].offsetY - points[0].offsetY;
//     // double horizitalDis = currOffsetX - preOffsetX;
//     // double verticalDis = currOffsetY - preOffsetY;

//     if(horizitalDis.abs()!=0){
//       if(horizitalDis.abs() > verticalDis.abs()){
//         if(horizitalDis > 0){
//           direction = MoveDirection.right;
//         }else{
//           direction = MoveDirection.left;
//         }
//       } else {
//         if(verticalDis >= 0){ //向下
//           direction = MoveDirection.bottom;
//         }else { //向上
//           direction = MoveDirection.top;
//         }
//       }
//     } else {
//       if(verticalDis!=0){
//         if(verticalDis > 0){ //向下
//           direction = MoveDirection.bottom;
//         }else { //向上
//           direction = MoveDirection.top;
//         }
//       } else {
//         direction = MoveDirection.none;
//       }
//     }
//     points.removeAt(0);
//     directions.add(direction);
//     if(directions.length > 6){
//       if(directions[directions.length-1] != directions[0]){
//         direction = MoveDirection.none;
//       }
//       directions.removeAt(0);
//     }
//     return direction;
//   }
  
// }

// enum MoveDirection{
//   left,
//   right,
//   top,
//   bottom,
//   // leftTop,
//   // leftBottom,
//   // rightTop,
//   // rightBottom,
//   none
// }