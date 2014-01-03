library modal_ok_cancel_dialog;

import 'package:polymer/polymer.dart';
import "package:dartling/dartling.dart"; 

@CustomTag('modal-ok-cancel-dialog')
class ModalOkCancelDialog extends PolymerElement {
  @published String message;
  @published bool showDialog = false;
  @published Function functionIfOk;
  @published Oid oidConfirm;
  
  ModalOkCancelDialog.created() : super.created();
  
  confirm() {
    functionIfOk(oidConfirm);
    showDialog = false;
  }
  
  cancel() {
    showDialog = false;
  }

}