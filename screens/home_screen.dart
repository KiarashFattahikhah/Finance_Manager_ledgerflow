import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/constant.dart';
import 'package:flutter_project/main.dart';
import 'package:flutter_project/models/money.dart';
import 'package:flutter_project/screens/new_transactions_screens.dart';
import 'package:flutter_project/screens/user_profile_screen.dart';
import 'package:flutter_project/utils/extention.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static List<Money> moneys = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box settingsBox = Hive.box('settingsBox');

  int sortMode = 0; 
  // 0 = date
  // 1 = alphabet
  // 2 = price

  // -------------------------
  // 2. Add sorting function
  // -------------------------
  void sortTransactions() {
    if (sortMode == 0) {
      // Sort by date (newest first)
      HomeScreen.moneys.sort((a, b) => b.date.compareTo(a.date));
    } 
    else if (sortMode == 1) {
      // Sort alphabetically
      HomeScreen.moneys.sort((a, b) =>
          a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    } 
    else if (sortMode == 2) {
      // Sort by price (highest first)
      int parse(String s) => int.tryParse(s.replaceAll(",", "")) ?? 0;

      HomeScreen.moneys.sort(
          (a, b) => parse(b.price).compareTo(parse(a.price)));
    }

    setState(() {});
  }

  final TextEditingController searchController = TextEditingController();
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');

  @override
  void initState() {
    super.initState();
    MyApp.getData();
    final stored = settingsBox.get('sortMode', defaultValue: 0);
    sortMode = (stored is int) ? stored : 0;
    sortTransactions();
    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenSize(context).screenWidth < 1004 ? 90 : screenSize(context).screenWidth*0.06), 
          child: Container(
            color: kPurpleColor,
            child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: AnimationSearchBar(
                          onChanged: (String text) {
                            List<Money> result = hiveBox.values.where((value) => value.title.contains(text) || value.date.contains(text)).toList();
                            HomeScreen.moneys.clear();
                            setState(() {
                              for (var value in result){
                                HomeScreen.moneys.add(value);
                              }
                            });
                            },
                          searchTextEditingController: searchController,
                          isBackButtonVisible: false, 
                          closeIconColor: Colors.white,
                          centerTitle: 'Transactions', 
                          hintText: 'Search ...',
                          centerTitleStyle: TextStyle(
                            fontWeight: FontWeight.w500,color: Colors.white, fontSize: screenSize(context).screenWidth < 1004 ? 20 : screenSize(context).screenWidth*0.015),
                          hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w300),
                          textStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                          cursorColor: Colors.grey,
                          duration: const Duration(milliseconds: 500),
                          searchFieldHeight: 35, 
                          searchBarHeight: 50, 
                          searchBarWidth: MediaQuery.of(context).size.width - 20, 
                          horizontalPadding: 5,
                          verticalPadding: 0,
                          searchIconColor: Colors.white,
                          searchFieldDecoration: BoxDecoration(
                            color: Colors.white54,
                            border: Border.all(color: kPurpleColor, width: .5),
                            borderRadius: BorderRadius.circular(15)),
                          ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (_) => UserProfileScreen()));
                              }, 
                              icon: Icon(Icons.person),
                              color: Colors.white,
                            ),
                            DropdownButton<int>(
                              value: sortMode,
                              dropdownColor: kPurpleColor,
                              underline: const SizedBox(),
                              icon: const Icon(Icons.sort, color: Colors.white),
                              items: const [
                                DropdownMenuItem(value: 0, child: Text("Sort by Date", style: TextStyle(color: Colors.white, fontSize: 12),)),
                                DropdownMenuItem(value: 1, child: Text("Sort A → Z", style: TextStyle(color: Colors.white, fontSize: 12),)),
                                DropdownMenuItem(value: 2, child: Text("Sort by Price", style: TextStyle(color: Colors.white, fontSize: 12),)),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  sortMode = value!;
                                  settingsBox.put('sortMode', sortMode);
                                  sortTransactions();
                                });
                                
                                sortTransactions();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ),
          ),
              ),    
        backgroundColor: Colors.white,
        floatingActionButton: fabWidget(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [              
                Expanded(
                  child: HomeScreen.moneys.isEmpty ? EmptyWidget() : ListView.builder(
                    itemCount: HomeScreen.moneys.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(

                        onTap: () {
                          NewTransactionsScreens.date = HomeScreen.moneys[index].date;
                          NewTransactionsScreens.descriptionController.text = HomeScreen.moneys[index].title;
                          NewTransactionsScreens.priceController.text = HomeScreen.moneys[index].price;
                          NewTransactionsScreens.groupId = HomeScreen.moneys[index].isReceived ? 2 : 1;
                          NewTransactionsScreens.currency = HomeScreen.moneys[index].currency;
                          NewTransactionsScreens.category = HomeScreen.moneys[index].category;
                          NewTransactionsScreens.isEditing = true;
                          NewTransactionsScreens.id = HomeScreen.moneys[index].id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewTransactionsScreens()),
                            ).then((value){
                              MyApp.getData();
                              sortTransactions();
                              setState(() {
                                
                              });
                            });
                        },

                        onLongPress: () {
                          showDialog(context: context, builder: (context) => AlertDialog(
                            title: Text('Are you sure you want to delete this item? ', style: TextStyle(fontSize: 12.0),),
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            actions: [
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                }, 
                                child: Text('No', style: TextStyle(color: Colors.black87),),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  hiveBox.deleteAt(index);
                                  MyApp.getData();
                                  setState(() {
                                  });
                                  Navigator.pop(context);
                                }, 
                                child: Text('Yes', style: TextStyle(color: Colors.black87),),
                              ),
                            ],
                          ),
                        );
                      },
                        child: MyListTileWidget(index: index));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
  }
  Widget fabWidget(){
  return FloatingActionButton(
      backgroundColor: kPurpleColor,
      elevation: 0,
      onPressed: (){
        NewTransactionsScreens.date = 'Date';
        NewTransactionsScreens.descriptionController.text = '';
        NewTransactionsScreens.priceController.text = '';
        NewTransactionsScreens.groupId = 0;
        NewTransactionsScreens.isEditing = false;
        NewTransactionsScreens.currency = NewTransactionsScreens.currency;
        NewTransactionsScreens.category = null;
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => NewTransactionsScreens(),
            ),        
        ).then((value){
          MyApp.getData();
          sortTransactions();
          setState((){
          });
        });
      }, 
      child: const Icon(Icons.add, color: Colors.white,),
    );
  }
}


class EmptyWidget extends StatelessWidget {

  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context){
  return Column(
    children: [
      Spacer(),
      Image.asset(
        'assets/images/empty.png',
        height: screenSize(context).screenWidth < 1004 ?300 : screenSize(context).screenWidth*0.2,
        width: screenSize(context).screenWidth < 1004 ?300 : screenSize(context).screenWidth*0.2,
        ),
      SizedBox(height: 10),
      Text('No transaction exists!', style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14: screenSize(context).screenWidth*0.013)),
      Spacer(),
    ],
  );
}
}

class MyListTileWidget extends StatelessWidget {
  final int index;

  const MyListTileWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final currency = Hive.box('settingsBox').get('currency', defaultValue: 'Currency');
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: HomeScreen.moneys[index].isReceived ? kGreenColor : kRedColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: Icon(
                HomeScreen.moneys[index].isReceived ? Icons.add : Icons.remove,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(HomeScreen.moneys[index].title, 
                style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth*0.015,),),
                ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(HomeScreen.moneys[index].category, style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 10 : screenSize(context).screenWidth*0.01, color: Colors.grey),),
              )
            ],
          ),
          Spacer(),
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text('${HomeScreen.moneys[index].price} $currency', style: TextStyle(
                      fontSize: screenSize(context).screenWidth < 1004 ? 14 : screenSize(context).screenWidth*0.015, 
                      color: HomeScreen.moneys[index].isReceived ? kGreenColor : kRedColor),),
                  ),
                ],
              ),
              Text(HomeScreen.moneys[index].date, 
              style: TextStyle(fontSize: screenSize(context).screenWidth < 1004 ? 12 : screenSize(context).screenWidth*0.01),),
              
            ],
          ),
    
        ],
      ),
    );
  }
}

   

