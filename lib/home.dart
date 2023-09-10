import 'package:calculator/bottons.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String num1 = "";
  String operand = "";
  String num2 = "";
  bool isdark = true;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: isdark == true ? Colors.blueGrey[900] : Colors.white54,
      appBar: AppBar(
          backgroundColor: isdark == true ? Colors.grey[800] : Colors.grey[300],
          centerTitle: true,
          title: Text(
            'ماشین حساب',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: isdark == true ? Colors.white70 : Colors.black,
            ),
          ),
          actions: [
            IconTheme(
              data: IconThemeData(
                  color: isdark == true ? Colors.black : Colors.deepOrange),
              child: Icon(isdark == true
                  ? (Icons.dark_mode_outlined)
                  : Icons.light_mode_outlined),
            )
          ],

          
          leading: Switch(
            inactiveThumbColor: Colors.amber,
            inactiveTrackColor: Colors.black,
            activeTrackColor: Colors.grey[700],
            activeColor: Colors.white,
            value: isdark,
            onChanged: (value) {
              setState(() {
                isdark = value;
              });
            },
          )),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(17),
                  child: Text(
                    '$num1$operand$num2'.isEmpty ? '0' : '$num1$operand$num2',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 70,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.btnName
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? MediaQuery.of(context).size.width / 2
                          : (MediaQuery.of(context).size.width / 4),
                      height: screenSize.width / 4,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Material(
        color: isdark == true ? getBtncdark(value) : getBtnclight(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: isdark == true ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  // ##############
  // calculates the result
  void calculate() {
    if (num1.isEmpty) return;
    if (operand.isEmpty) return;
    if (num2.isEmpty) return;

    final double n1 = double.parse(num1);
    final double n2 = double.parse(num2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = n1 + n2;
        break;
      case Btn.subtract:
        result = n1 - n2;
        break;
      case Btn.multiply:
        result = n1 * n2;
        break;
      case Btn.divide:
        result = n1 / n2;
        break;
      default:
    }

    setState(() {
      num1 = result.toStringAsPrecision(3);

      if (num1.endsWith(".0")) {
        num1 = num1.substring(0, num1.length - 2);
      }

      operand = "";
      num2 = "";
    });
  }

  // ##############
  // converts output to %
  void convertToPercentage() {
    // ex: 434+324
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      // calculate before conversion
      calculate();
    }

    if (operand.isNotEmpty) {
      // cannot be converted
      return;
    }

    final number = double.parse(num1);
    setState(() {
      num1 = "${(number / 100)}";
      operand = "";
      num2 = "";
    });
  }

  // ##############
  // clears all output
  void clearAll() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

  // ##############
  // delete one from the end
  void delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }

    setState(() {});
  }

  // #############
  // appends value to the end
  void appendValue(String value) {
    if (value != Btn.dot && int.tryParse(value) == null) {
      // operand pressed
      if (operand.isNotEmpty && num2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (num1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && num1.contains(Btn.dot)) return;
      if (value == Btn.dot && (num1.isEmpty || num1 == Btn.n0)) {
        value = "0.";
      }
      num1 += value;
    } else if (num2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && num2.contains(Btn.dot)) return;
      if (value == Btn.dot && (num2.isEmpty || num2 == Btn.n0)) {
        value = "0.";
      }
      num2 += value;
    }

    setState(() {});
  }

  Color? getBtncdark(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.teal
        : [
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.del,
            Btn.add,
            Btn.subtract,
          ].contains(value)
            ? Colors.amber
            : [Btn.calculate].contains(value)
                ? Colors.red[900]
                : Colors.grey[900];
  }

  Color? getBtnclight(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.cyanAccent[200]
        : [
            Btn.per,
            Btn.multiply,
            Btn.divide,
            Btn.del,
            Btn.add,
            Btn.subtract,
          ].contains(value)
            ? Colors.greenAccent[200]
            : [Btn.calculate].contains(value)
                ? Colors.indigo[200]
                : Colors.white54;
  }
}
