import 'package:currency_converter/services/api_service.dart';
import 'package:currency_converter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../services/get_conversion_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<String>? items;
  String? fromDropDown;
  String? toDropDown;
  double? convertedAmount;
  bool showLoader = false;
  String lastFiveConversion = "";
  late Box box;
  List<GetConversionModel> listOfLastConversion = [];
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Hive.openBox("conversion").then((a){
      box = a;
      listOfLastConversion = [];
      lastFiveConversion = box.get('conversionData') ?? "";
      setState(() {});
    });
    items = [
      "USD", "INR" , "AUD" , "CAD" , "RUB"
    ];
    fromDropDown = items?.first;
    toDropDown = items?.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Currency Converter"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Convert Your Currency" , style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green
              ),),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.grey, thickness: 1,),
              ),
              const SizedBox(height: 20,),
              fromToDropDownUi(),
              const SizedBox(height: 20,),
              convertedAmountUi(),
              const SizedBox(height: 20,),
              inputFieldForAmount(),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerLeft,
                  child: listOfLastFiveConversion())
            ],
          ),
        ),
      ),
    );
  }

  Widget fromToDropDownUi(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          dropDownBoxWrapper(
            child:  Row(
              children: [
                const Text("From: " , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                const SizedBox(width: 12,),
                SizedBox(
                  height: 45,
                  width: 60,
                  child: DropdownButton(
                      value: fromDropDown,
                      items: items?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (a){
                        setState(() {
                          fromDropDown = a;
                        });
                      }),
                ),
              ],
            )
          ),
          dropDownBoxWrapper(
            child: Row(
              children: [
                const Text("To: " , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),),
                const SizedBox(width: 12,),
                SizedBox(
                  height: 45,
                  width: 60,
                  child: DropdownButton(
                      value: toDropDown,
                      items: items?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (a){
                        setState(() {
                          toDropDown = a;
                        });
                      }),
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  Widget dropDownBoxWrapper({Widget? child}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 7),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: child,
    );
  }

  Widget inputFieldForAmount(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextFormField(
            maxLength: 10,
            controller: inputController,
            enabled: true,
            decoration: const InputDecoration(
              // hintText: "",
              labelText: "Enter the conversion amount",
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          InkWell(
            onTap: onSubmitPress,
            child: Container(
              height: 50,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6)
              ),
              child: const Center(
                child: Text("Submit" , style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget convertedAmountUi(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: dropDownBoxWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text("Converted amount : ${convertedAmount ?? "--"}" , style: const TextStyle(
                fontSize: 16,
                color: Colors.green
              ),),
              if(showLoader)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 20,
                    width: 20,
                    child: const CircularProgressIndicator())
            ],
          ),
        )
      ),
    );
  }

  onSubmitPress() async{
    String amount = inputController.text;
    if(fromDropDown == null || toDropDown == null || amount.isEmpty){
      Constants.showErrorToast(context, "Please fill all required fields.");
      return;
    }
    setState(() {
      convertedAmount = null;
      showLoader = true;
    });
    await ApiService().getConversionRate(
        fromDropDown!, toDropDown!, amount , context).then((modelData){
          setState(() {
            showLoader = false;
          });
          if(modelData?.conversionResult != null){
            convertedAmount = modelData!.conversionResult!;
            modelData.amount = amount;
            addToList(modelData);
            box.put('conversionData', '$convertedAmount');
          }
    });
  }

  addToList(GetConversionModel getConversionModel){
    listOfLastConversion.insert(0 , getConversionModel);
    if(listOfLastConversion.length > 5){
      listOfLastConversion = listOfLastConversion.sublist(0, 5);
    }
  }

  Widget listOfLastFiveConversion(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Last 5 currency conversions : " , style: TextStyle(
          fontSize: 18
        ),),

        const SizedBox(height: 20,),
        ...listOfLastConversion.map((a){
          return itemForList(a);
        })
      ],
    );
  }

  Widget itemForList(GetConversionModel a){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: dropDownBoxWrapper(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "From ${a.baseCode} to ${a.targetCode} :${a.amount} -> ${a.conversionResult}",
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 14
            ),
          ),
        )
      ),
    );
  }
}
