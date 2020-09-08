import 'package:bagel_pizza/controller/home_controller.dart';
import 'package:bagel_pizza/scoped_model/base_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeController>(
        onModelReady: (model) => print(model.toppingsList.length),
        builder: (context, childe, model) => Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Container(height: 28, child: Image.asset('assets/logo.png')),
                  centerTitle: true,
                ),
                body: Column(
                  children: [
                    SizedBox(height: 25),
                    SizedBox(
                      height: 300,
                      child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                thickness: 1.9,
                                height: 25,
                              ),
                          scrollDirection: Axis.vertical,
                          itemCount: model.pizzasList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Image.asset(
                                  'assets/half.png',
                                  scale: 5.5,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      model.convertSizeEnumToString(model.pizzasList[index].size) + ' size',
                                      style: GoogleFonts.raleway(fontSize: 21),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(height: 15),
                                    SizedBox(
                                      height: 70,
                                      width: MediaQuery.of(context).size.width * 0.52,
                                      child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int idx) {
                                            return Center(
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(model.pizzasList[index].toppings[idx].smallImage),
                                                radius: 28,
                                              ),
                                            );
                                          },
                                          separatorBuilder: (context, idx) => SizedBox(
                                                width: 10,
                                              ),
                                          itemCount: model.pizzasList[index].toppings.length),
                                    ),
                                    // SizedBox(height: 0)
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                      size: 64,
                                    ),
                                    onPressed: () => model.removePizza(model.pizzasList[index]))
                              ],
                            );
                          }),
                    ),
                    CircleAvatar(
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
                  ],
                ))));
  }
}
