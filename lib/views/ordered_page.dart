import 'package:bagel_pizza/controller/home_controller.dart';
import 'package:bagel_pizza/scoped_model/base_view.dart';
import 'package:bagel_pizza/views/checkout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeController>(
      builder: (context, childe, model) => Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
        child: WillPopScope(
          onWillPop: () {
            return Navigator.pushNamed(context, 'home',
                arguments: {'pizza': model.pizzasList.last});
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title:
                  Container(height: 28, child: Image.asset('assets/logo.png')),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 15),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.separated(
                      shrinkWrap: true,
                      //physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(
                            thickness: 1.9,
                            height: 25,
                          ),
                      //scrollDirection: Axis.vertical,
                      itemCount: model.pizzasList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _pizzaUI(model, index, context);
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                addPizzaButtonUI(model, context),
                SizedBox(height: 5),
                allDoneButtonUI(model, context),
                SizedBox(height: 13)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _pizzaUI(HomeController model, int index, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.popAndPushNamed(context, 'home',
          arguments: {'pizza': model.pizzasList[index]}),
      child: Container(
        height: 120,
        child: ListView(
          //sics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              child: Image.asset(
                'assets/half.png',
                scale: 7.0,
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 200.0),
                  child: FlatButton.icon(
                      label: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      icon: Text(
                        model.pizzasList[index].size +
                            ' size | \$' +
                            model
                                .calculatePizzaPrice(model.pizzasList[index])
                                .toString(),
                        style: GoogleFonts.raleway(fontSize: 19),
                      ),
                      onPressed: () =>
                          model.removePizza(model.pizzasList[index])),
                ),
                //   ],
                // ),
                SizedBox(height: 3),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int idx) {
                        return Center(
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(model
                                .pizzasList[index].toppings[idx].smallImage),
                            radius: 20,
                          ),
                        );
                      },
                      separatorBuilder: (context, idx) => SizedBox(
                            width: 5,
                          ),
                      itemCount: model.pizzasList[index].toppings.length),
                ),
                SizedBox(height: 0)
              ],
            ),
          ],
        ),
      ),
    );
  }

  addPizzaButtonUI(HomeController model, BuildContext context) {
    return GestureDetector(
      onTap: () {
        model.tag = 1;
        Navigator.pushNamed(context, 'home');
      },
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/pizza.png'),
        backgroundColor: Colors.red,
        radius: 60.5,
        child: CircleAvatar(
          backgroundColor: Colors.black.withOpacity(0.7),
          radius: 60,
          child: Icon(
            Icons.add,
            size: 55,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  allDoneButtonUI(HomeController model, BuildContext context) {
    return FlatButton(
      disabledColor: Colors.red,
      color: Colors.red,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CheckOut()));
      },
      splashColor: Colors.red[200],

      // minWidth: MediaQuery.of(context).size.width * 0.55,
      // height: 45,
      child: Text('All done?', style: GoogleFonts.raleway(color: Colors.white)),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
          //side: BorderSide(color: Colors.blue, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(50)),
    );
  }
}
