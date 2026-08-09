import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavNotifier extends StateNotifier<int>{
  BottomNavNotifier(super.state);



  void changeIndex(int index){
    state = index;
  }

  void backToHome(){
    state = 0;
  }


}