import 'package:formatter/core/symbols_unit.dart';

/// create by 张风捷特烈 on 2020/10/30
/// contact me by email 1981462002@qq.com
/// 说明:

class CharNode {
  String data;
  CharNode next;
  CharNode prev;

  CharNode(this.data, {this.next, this.prev});

  CharType get type {
    if (data.isEmpty) return CharType.none;
    if (_isAlphabet(data)) return CharType.letter;
    if (_isNumber(data)) return CharType.number;
    if (data == " ") return CharType.space;
    if (SymbolUnit.fullSymbols.contains(data)) return CharType.fullSymbol;
    if (SymbolUnit.halfSymbols.contains(data)) return CharType.halfSymbol;
    return CharType.common;
  }

  bool _isAlphabet(String char) {
    // 码表数值： A-z      65-122
    return char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 122;
  }

  bool _isNumber(String char) {
    // 码表数值： 0-9      48-57
    return char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
  }
}

// 字符类型
enum CharType {
  fullSymbol, // 全角符号
  halfSymbol, // 全角符号
  number, // 数字
  letter, // 字母
  common,
  space,
  none
}
