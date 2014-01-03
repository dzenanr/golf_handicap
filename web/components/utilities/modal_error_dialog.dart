library modal_error_dialog;

import 'package:polymer/polymer.dart';

@CustomTag('modal-error-dialog')
class ModalErrorDialog extends PolymerElement {
  @published String message;
  @published bool showDialog = false;
  
  ModalErrorDialog.created() : super.created();
  
  confirm() {
    showDialog = false;
  }

}