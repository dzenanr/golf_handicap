library modal_success_dialog;

import 'package:polymer/polymer.dart';

@CustomTag('modal-success-dialog')
class ModalSuccessDialog extends PolymerElement {
  @published String message;
  @published bool showDialog = false;
  
  ModalSuccessDialog.created() : super.created();
  
  confirm() {
    showDialog = false;
  }

}