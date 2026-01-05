import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';


class CustomSearchDropDown<T> extends StatelessWidget {

  final String hintText;
  void Function(T?)? onChanged;
  String Function(T)? itemAsString;
  Future<List<T>> Function(String)? asyncItems;
  String? Function(T?)? validator;
  bool enabled;
  List<T>? items;
  Key? key;
  bool showSearchBox;
  T? selectedItem;

  CustomSearchDropDown(
      {
      required this.hintText,
      this.asyncItems,
      this.onChanged,
      this.itemAsString,
      this.validator,
      this.enabled = true,
      this.items,
      this.showSearchBox = false,
      this.selectedItem,
      this.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 21),
      child: DropdownSearch<T>(
        selectedItem: selectedItem,
        key: key,
        popupProps: PopupProps.modalBottomSheet(
          fit: FlexFit.loose,
          modalBottomSheetProps: ModalBottomSheetProps(
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0))),
        ),
        enabled: enabled,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        dropdownDecoratorProps: DropDownDecoratorProps(
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              errorStyle: TextStyle(height: 2),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              hintText: hintText,
            )),
        asyncItems: asyncItems,
        onChanged: onChanged,
        itemAsString: itemAsString,
        validator: validator,
        items: items!,
      ),
    );
  }
}
