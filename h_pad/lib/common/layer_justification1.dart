// /*
//  * @Description: Do not edit
//  * @Author: haojieyu (haojieyu@novastar.tech)
//  * @Date: 2020-06-16 15:20:56
//  * @LastEditors: haojieyu
//  * @LastEditTime: 2020-06-16 21:23:20
//  */ 
// /*
//  * @Description: Do not edit
//  * @Author: haojieyu (haojieyu@novastar.tech)
//  * @Date: 2020-06-12 11:42:37
//  * @LastEditors: haojieyu
//  * @LastEditTime: 2020-06-16 15:19:07
//  */ 
// import 'package:flutter/cupertino.dart';
// import 'package:h_pad/common/component_index.dart';
// import 'package:h_pad/models/screen/LayerPosition.dart';
// import 'package:h_pad/states/edit/LayerProvider.dart';
// import 'package:h_pad/states/edit/RenderBoxProvider.dart';
// import 'package:provider/provider.dart';

// class LayerJustification{
//   static const justifiedDistance = 5;
//   static adsorb(BuildContext context, CustomerLayer layer, double currOffsetX, double currOffsetY, double preOffsetX, double preOffsetY){ 
//     AdsorbedPosition ret;
//     RenderBoxProvider renderBoxProvider = Provider.of<RenderBoxProvider>(context, listen: false);
//     List<Position> outoutcards = renderBoxProvider.outputCardPositionList;
//     List<Position> layers = renderBoxProvider.layerPositionList;
//     var currLayer = layers.firstWhere((p)=>p.layerId == layer.screenLayer.layerId, orElse:() => null);
//     if(currLayer != null){
//       print('移除自己');
//       layers.remove(currLayer);
//     }
//     // outoutcards.addAll(layers);
//     // print('比对的数组长度----------${outoutcards.length}');
    
//     print('当前值------x:${currOffsetX}------y:${currOffsetY}------${layer.layerPosition.left}----${layer.layerPosition.top}');
//     print('前一个值------x:${layer.layerPosition.left}----y:${layer.layerPosition.top}');
//     print('===========================================================================>>>>>>>>>>>>>>>>>>>');
//     MoveDirection direction = movingDirection(preOffsetX, preOffsetY, currOffsetX, currOffsetY);
//     if(direction == MoveDirection.top){
//       // print('top');
//       List<Position> findOutPutCard = outoutcards.where((p) => (currOffsetY - p.top).abs() <= Utils.setHeight(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.top);
//       if(p != null){
//         double dis = (currOffsetY - p.top).abs();
//         print('top-------------------${p.top}---------------${currOffsetY + dis}----------$dis');
//         ret = new AdsorbedPosition(vertical: p.top);//currOffsetY + dis
//       }
//     }
//     else if(direction == MoveDirection.bottom){
//       print('bottom');
//       List<Position> findOutPutCard = outoutcards.where((p) => (p.top + p.height - (currOffsetY + layer.layerPosition.height)).abs()  <= Utils.setHeight(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.bottom);
//       if(p!=null){
//         double dis = p.top + p.height - (currOffsetY + layer.layerPosition.height);
//         print('bottom------------------${p.top + p.height - layer.layerPosition.height}');
//         ret = new AdsorbedPosition(vertical: p.top + p.height - layer.layerPosition.height);//currOffsetY + dis
//       }
//     }
//     else if(direction == MoveDirection.left){
//       print('left');
//       List<Position> findOutPutCard = outoutcards.where((p) => (currOffsetX - p.left).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.left);
//       if(p!=null){
//         double dis = (currOffsetX - p.left).abs();
//         ret = new AdsorbedPosition(horizontal: p.left);//currOffsetX + dis
//       }
//     }else if(direction == MoveDirection.right){
//       print('right');
//       List<Position> findOutPutCard = outoutcards.where((p) => (p.left + p.width - (currOffsetX + layer.layerPosition.width)).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       Position p = findMin(findOutPutCard, MoveDirection.right);
//       if(p!=null){
//         double dis = (p.left + p.width - (currOffsetX + layer.layerPosition.width)).abs();
//         ret = new AdsorbedPosition(horizontal: p.left + p.width - layer.layerPosition.width);//currOffsetX + dis

//       }
//     }else if(direction == MoveDirection.leftTop){
//       print('leftTop');
//       List<Position> findOutPutCardLeft = outoutcards.where((p) => (currOffsetX - p.left).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       List<Position> findOutPutCardTop = outoutcards.where((p) => (currOffsetY - p.top).abs() <= Utils.setHeight(justifiedDistance)).toList();
//       Position pLeft = findMin(findOutPutCardLeft, MoveDirection.left);
//       Position pTop = findMin(findOutPutCardTop, MoveDirection.top);
//       print('lefttop---------${pLeft?.left}----------${pLeft?.top}');
//       print('lefttop---------${pTop?.left}----------${pTop?.top}');
//       ret = new AdsorbedPosition(horizontal: pLeft?.left, vertical: pTop?.top);
//       // if(pLeft!=null){
//       //   double dis = (currOffsetX - pLeft.left).abs();
//       //   ret.horizontal = currOffsetX + dis;
//       // }
//       // if(pTop!=null){
//       //   double dis = (currOffsetY - pTop.top).abs();
//       //   ret.vertical = currOffsetY + dis;
//       // }
//     }else if(direction == MoveDirection.leftBottom){
//       print('leftBottom');
//       List<Position> findOutPutCardLeft = outoutcards.where((p) => (currOffsetX - p.left).abs() <= Utils.setWidth(justifiedDistance)).toList();
//       List<Position> findOutPutCardBottom = outoutcards.where((p) => (p.top + p.height - (currOffsetY + layer.layerPosition.height)).abs()  <= Utils.setHeight(justifiedDistance)).toList();
//       Position pLeft = findMin(findOutPutCardLeft, MoveDirection.left);
//       Position pBottom = findMin(findOutPutCardBottom, MoveDirection.bottom);
//       ret = new AdsorbedPosition(horizontal: pLeft?.left, vertical: pBottom?.top);
//       if(ret.vertical!=null){
//         double dis = (pBottom.top + pBottom.height - (currOffsetY + layer.layerPosition.height)).abs();
//         ret.vertical =  ret.vertical + pBottom.height - layer.layerPosition.height;//currOffsetY + dis;
//       }
//     }else if(direction == MoveDirection.rightTop){
//       print('rightTop');
//       List<Position> findOutPutCardRight = outoutcards.where((p) => (p.left + p.width - (currOffsetX + layer.layerPosition.width)).abs()  <= Utils.setWidth(justifiedDistance)).toList();
//       List<Position> findOutPutCardTop = outoutcards.where((p) => (currOffsetY - p.top).abs() <= Utils.setHeight(justifiedDistance)).toList();
//       Position pRight = findMin(findOutPutCardRight, MoveDirection.right);
//       Position pTop = findMin(findOutPutCardTop, MoveDirection.top);
//       ret = new AdsorbedPosition(horizontal: pRight?.left, vertical: pTop?.top);
//       if(ret.horizontal!=null){
//         double dis = (pRight.left + pRight.width - (currOffsetX + layer.layerPosition.width)).abs();
//         ret.horizontal = ret.horizontal + pRight.width - layer.layerPosition.width;//currOffsetX + dis;
//       }

//     }else if(direction == MoveDirection.rightBottom){
//       print('rightBottom');
//       List<Position> findOutPutCardRight = outoutcards.where((p) => (p.left + p.width - (currOffsetX + layer.layerPosition.width)).abs()  <= Utils.setWidth(justifiedDistance)).toList();
//       List<Position> findOutPutCardBottom = outoutcards.where((p) => (p.top + p.height - (currOffsetY + layer.layerPosition.height)).abs()  <= Utils.setHeight(justifiedDistance)).toList();
//       Position pRight = findMin(findOutPutCardRight, MoveDirection.right);
//       Position pBottom = findMin(findOutPutCardBottom, MoveDirection.bottom);
//       ret = new AdsorbedPosition(horizontal: pRight?.left, vertical: pBottom?.top);
//       if(ret.horizontal!=null){
//         double dis = (pRight.left + pRight.width - (currOffsetX + layer.layerPosition.width)).abs();
//         ret.horizontal = ret.horizontal + pRight.width - layer.layerPosition.width;//currOffsetX + dis;
//       }
//       if(ret.vertical!=null){
//         double dis = (pBottom.top + pBottom.height - (currOffsetY + layer.layerPosition.height)).abs();
//         ret.vertical = ret.vertical + pBottom.height - layer.layerPosition.height;//currOffsetY + dis;
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
//           case MoveDirection.bottom:
//             findOutPutCard.sort((a,b) => (a.top).compareTo(b.top));
//             break;
//           case MoveDirection.left:
//           case MoveDirection.right:
//             findOutPutCard.sort((a,b) => (a.left).compareTo(b.left));
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
//     if(currOffsetX - preOffsetX > 0) { //向右
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

// // enum MoveDirection{
// //   left,
// //   right,
// //   top,
// //   bottom,
// //   leftTop,
// //   leftBottom,
// //   rightTop,
// //   rightBottom,
// //   none
// // }