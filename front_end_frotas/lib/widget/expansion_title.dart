import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:simple_grid/simple_grid.dart';

class ExpansionTitleController extends GetxController {
  RxBool isExpanded = false.obs;

  void setExpanded(bool expanded) {
    isExpanded.value = expanded;
  }
}

SpGridItem defaultGrid({required Widget child}) {
  return SpGridItem(xs: 12, sm: 12, md: 6, lg: 6, child: child);
}

SpGridItem listGrid({required Widget child}) {
  return SpGridItem(xs: 12, sm: 12, md: 6, lg: 6, child: child);
}
