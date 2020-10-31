import 'dart:io';

import 'package:formatter/core/symbols_unit.dart';
/// create by 张风捷特烈 on 2020/10/30
/// contact me by email 1981462002@qq.com
/// 说明:
import 'package:string_scanner/string_scanner.dart';

import 'node.dart';

// var str = "hello张风捷特烈";

// var str = "你好hello张风捷特烈";
// var str = "你好123张风捷特烈";

// var str = "你好，hello张风捷特烈";

// var str = "你好，hello张风捷特烈 。 my哈哈";

// var str = "你好hello           张风捷特烈。    my名字";

var str = "你好hello  张风捷特烈,你好by张风.捷特;烈。fine谢谢";

// var str = "张风捷特烈。  fine谢谢";

// var str = "你好hello   。fine谢谢";

// var str = "你好hello  张风捷特烈，你好by张风捷特烈。fine谢谢";
// var str = "  你好hello  ，张风捷特烈。";

main() {
  // StringScanner scanner = StringScanner(str);
  //
  // // bool scan = scanner.scan(RegExp(r'.*'));
  // // //======true====0====12=
  // // print('======$scan====${scanner.lastMatch.start}====${ scanner.lastMatch.end}=');
  //
  // bool scan = scanner.scan(RegExp(r'\w+'));
  // print(
  //     '======$scan====${scanner.lastMatch.start}====${scanner.lastMatch.end}=');

  // for (int i = 0; i < str.length; i++) {}

  final String path = "/Volumes/coder/file/markdown/translation/test.md";
  File file = File(path);
  var strResult = file.readAsStringSync();
  print(strResult);
  //
  print(strResult.codeUnits.join(" "));
  // print('--------${"\n".codeUnitAt(0)}--------');

  // for (int i = 0; i < strResult.length; i++) {
  //   print("${strResult[i].codeUnitAt(0)}");
  // }

  // print('====input:\n$str');
  // final TextParser parser = TextParser();
  //
  // for (int i = 0; i < str.length; i++) {
  //   parser.addFirst(str[i]);
  // }
  // parser.parser();
  // print('====output:\n$parser');
}

// 使用双向链表
// 每个字符为一个节点
// 初始化时，读取文件，形成链表
// 遍历 当遇到 需要空个的字符时， 校验前驱是否为空行
// 不是，则在前方插入空格

class TextParser {
  CharNode head = CharNode('');
  CharNode tail = CharNode('');

  TextParser() {
    head.next = tail;
    tail.prev = head;
  }

  bool isAlphabet(String char) {
    // 码表数值： A-z      65-122
    return char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 122;
  }

  bool isNumber(String char) {
    // 码表数值： 0-9      48-57
    return char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57;
  }

  bool shouldSpace(String char) {
    if (isAlphabet(char)) {
      return true;
    }

    if (isNumber(char)) {
      return true;
    }

    return false;
  }

  void parser() {
    CharNode current = tail.prev;
    _removeMoreSpace();
    print("===head=====${head.next.data}====");
    while (current.type != CharType.none) {

      _doJudge(current);
      current = current.prev;
    }

    // while (!shouldSpace(current.data) || current == null) {
    //   print(current.data);
    //   current = current.prev;
    // }
    // if (shouldSpace(current.data)) {
    //   final Node newNode = Node(" ", next: current.next, prev: current);
    //   current.next.prev = newNode;
    //   current.next = newNode;
    // }
  }

  addFirst(String target) {
    addNext(head, target);
  }

  addTail(String target) {
    addPrev(tail, target);
  }

  @override
  String toString() {
    var result = '';
    CharNode current = tail.prev;

    while (current.type != CharType.none) {
      result += current.data;
      current = current.prev;
    }
    return result;
  }

  void _doJudge(CharNode current) {
    CharType myType = current.type;
    CharType prevType = current.prev.type;
    CharType nextType = current.next.type;


    // 中英文之间需要增加空格
    // 英文字母和中文相连 o张 在当前节点prev添加空格
    if (myType == CharType.letter && prevType == CharType.common) {
      addPrev(current, " ");
      myType = current.type;
      prevType = current.prev.type;
      nextType = current.next.type;
    }

    // 中文和英文字母相连 好h 在当前节点prev添加空格
    if (myType == CharType.common && prevType == CharType.letter) {
      addPrev(current, " ");
      prevType = current.prev.type;
      nextType = current.next.type;
    }

    // 中文与数字之间需要增加空格
    if (myType == CharType.number &&
            prevType == CharType.common // 英文字母和中文相连 o张 在当前节点prev添加空格
        ) {
      addPrev(current, " ");

      prevType = current.prev.type;
      nextType = current.next.type;
    }

    //好h
    if (myType == CharType.common &&
            prevType == CharType.number // 中文和英文字母相连 好h 在当前节点next添加空格
        ) {
      addPrev(current, " ");

      prevType = current.prev.type;
      nextType = current.next.type;
    }

    // 全角符号和其他字符间不空行,如果有则去除
    if (myType == CharType.fullSymbol && prevType == CharType.space) {
      print('-myType-${myType}-prevType-${prevType}------${current.data}------${current.prev.data}------');
      // 移除前节点
      removePrev(current);
      prevType = current.prev.type;
      nextType = current.next.type;

    }
    if (myType == CharType.fullSymbol && nextType == CharType.space) {
      // 移除前节点
      removeNext(current);
      prevType = current.prev.type;
      nextType = current.next.type;
    }
  }

  void removePrev(CharNode target) {
    CharNode tempPrev = target.prev;

    target.prev = target.prev.prev;
    target.prev.next = target;

    tempPrev.next = null;
    tempPrev.prev = null;
    tempPrev = null;
  }

  void removeNext(CharNode target) {
    CharNode tempPrev = target.next;

    target.next = target.next.next;
    target.next.prev = target;

    tempPrev.next = null;
    tempPrev.prev = null;
    tempPrev = null;
  }

  void addPrev(CharNode target, String char) {
    final CharNode newNode = CharNode(char);
    newNode.prev = target.prev;
    target.prev.next = newNode;
    target.prev = newNode;
    newNode.next = target;
  }

  void addNext(CharNode target, String char) {
    addPrev(target.next, char);
  }

  void _removeMoreSpace() {
    CharNode current = tail.prev;
    while (current.type != CharType.none) {

      if(SymbolUnit.halfSymbols.contains(current.data)){
        current.data = SymbolUnit.fullSymbols[SymbolUnit.halfSymbols.indexOf(current.data)];
      }

      CharType myType = current.type;
      CharType prevType = current.prev.type;
      CharType nextType = current.next.type;

      if (myType == CharType.space && nextType == CharType.space) {
        // 移除后节点
        removeNext(current);
        prevType = current.prev.type;
        nextType = current.next.type;
      }
      if (myType == CharType.space && prevType == CharType.space) {
        // 移除前节点
        removePrev(current);
        prevType = current.prev.type;
        nextType = current.next.type;
      }
      current = current.prev;
    }

  }
}
