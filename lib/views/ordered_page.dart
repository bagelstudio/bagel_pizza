import 'package:bagel_pizza/controller/home_controller.dart';
import 'package:bagel_pizza/scoped_model/base_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/pizza_model.dart';
import '../model/pizza_model.dart';
import '../model/topping_model.dart';
import 'home_page.dart';

class OrderedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeController>(
        onModelReady: (model) => print(model.toppingsList.length),
        builder: (context, childe, model) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
              child: WillPopScope(
                onWillPop: () {
                  print('return to main');
                },
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: Container(
                        height: 28, child: Image.asset('assets/logo.png')),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        ListView.separated(
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
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            model.resetToppings();
                            model.tag = null;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeView()));
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
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Widget _pizzaUI(HomeController model, int index, BuildContext context) {
    return GestureDetector(
      onTap: () => print('tap!'),
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
                // Row(
                //   children: [
                // Text(
                //   model.convertSizeEnumToString(
                //           model.pizzasList[index].size) +
                //       ' size',
                //   style: GoogleFonts.raleway(fontSize: 19),
                // ),
                Padding(
                  padding: const EdgeInsets.only(right: 200.0),
                  child: FlatButton.icon(
                      label: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      icon: Text(
                        model.convertSizeEnumToString(
                                model.pizzasList[index].size) +
                            ' size',
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
}
