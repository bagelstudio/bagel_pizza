import 'package:bagel_pizza/controller/home_controller.dart';
import 'package:bagel_pizza/model/topping_model.dart';
import 'package:bagel_pizza/scoped_model/base_view.dart';
import 'package:bagel_pizza/views/ordered_page.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeController>(
        onModelReady: (model) => model.init(),
        builder: (context, childe, model) => Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bg.jpg'), fit: BoxFit.cover)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Container(
                      height: 28, child: Image.asset('assets/logo.png')),
                  centerTitle: true,
                ),
                body: Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, right: 10, left: 10),
                          child: Container(
                              color: Colors.white.withOpacity(0.5),
                              height: 0.3),
                        ),
                        ChipsChoice<int>.single(
                          value: model.tag,
                          options: ChipsChoiceOption.listFrom<int, String>(
                            source: model.sizeLst,
                            value: (i, v) => i,
                            label: (i, v) => v,
                          ),
                          itemConfig: ChipsChoiceItemConfig(
                            elevation: 1,
                            spacing: 30.0,
                            selectedColor: Colors.red,
                            showCheckmark: true,
                            labelStyle: GoogleFonts.raleway(fontSize: 14),
                            selectedBrightness: Brightness.dark,
                          ),
                          onChanged: (val) => model.changeTag(val),
                          isWrapped: false,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 4),
                          child: Container(
                              color: Colors.white.withOpacity(0.5),
                              height: 0.3),
                        ),
                        DragTarget<Topping>(
                          builder: (context, accepted, rejected) {
                            return Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  !model.finishDrag && accepted.isNotEmpty
                                      ? Center(
                                          child: CircleAvatar(
                                            radius: 145,
                                            backgroundColor: Colors.red,
                                            child: CircleAvatar(
                                              radius: 140,
                                              backgroundImage: AssetImage(
                                                  'assets/pizza.png'),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: CircleAvatar(
                                            radius: 145,
                                            backgroundColor: Colors.transparent,
                                            child: CircleAvatar(
                                              radius: 140,
                                              backgroundImage: AssetImage(
                                                  'assets/pizza.png'),
                                            ),
                                          ),
                                        ),
                                  ...model.pizzaToppingsImages
                                      .map(
                                        (link) => Positioned(
                                          height: 292,
                                          child: Center(
                                            child: Image.network(
                                              link,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList()
                                ]);
                          },
                          onAccept: (Topping top) =>
                              model.addToppingToPizza(top),
                        ),
                        SizedBox(height: 13),
                        SizedBox(
                          height: 90,
                          child: model.toppingsList.isEmpty
                              ? Center(child: CircularProgressIndicator())
                              : ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        width: 15,
                                      ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: model.toppingsList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Draggable<Topping>(
                                        data: model.toppingsList[index],
                                        child: model.pizzaToppingsImages
                                                    .contains(model
                                                        .toppingsList[index]
                                                        .pizzaImage) &&
                                                model.finishDrag
                                            ? _cancelToppingItemUI(
                                                model.toppingsList[index],
                                                model)
                                            : _toppingItemUI(
                                                model.toppingsList[index]),
                                        feedback: _toppingItemUIDragged(
                                            model.toppingsList[index]),
                                        affinity: Axis.vertical,
                                        onDragStarted: () =>
                                            model.finishDrag = false,
                                        onDragCompleted: () =>
                                            model.finishDrag = true,
                                        onDraggableCanceled: (v, o) =>
                                            model.finishDrag = true,
                                        onDragEnd: (val) =>
                                            model.finishDrag = true,
                                        childWhenDragging:
                                            _selectedToppingItemUI(
                                                model.toppingsList[index]));
                                  }),
                        ),
                        SizedBox(height: 25),
                        FlatButton(
                          disabledColor: Colors.red,
                          color: Colors.red,
                          onPressed: () {
                            model.postPizza();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderedPage()));
                          },
                          splashColor: Colors.red[200],

                          // minWidth: MediaQuery.of(context).size.width * 0.55,
                          // height: 45,
                          child: Text('Next',
                              style: GoogleFonts.raleway(color: Colors.white)),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              //side: BorderSide(color: Colors.blue, width: 1, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
            ));
  }

  // Widget _loadMoreButtonUI(HomeController model) {
  //   return Container(
  //     color: Colors.transparent,
  //     margin: EdgeInsets.symmetric(horizontal: 60),
  //     child: OutlineButton.icon(
  //       disabledBorderColor: MyColors.myBlue,
  //       highlightColor: MyColors.myBlue,
  //       hoverColor: MyColors.myBlue,
  //       focusColor: MyColors.myBlue,
  //       borderSide: BorderSide(color: MyColors.myBlue),
  //       shape: StadiumBorder(),
  //       onPressed: () {
  //         model.resetToppings();
  //       },
  //       icon: Icon(
  //         Icons.cancel,
  //         size: 20,
  //         color: MyColors.myBlue,
  //       ),
  //       label: Text(
  //         'reset toppings',
  //         style: GoogleFonts.raleway(color: MyColors.myBlue),
  //       ),
  //     ),
  //   );
  // }

  Widget _toppingItemUI(Topping topping) {
    return Column(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundImage: NetworkImage(topping.smallImage),
        ),
        SizedBox(height: 6),
        Text(
          topping.name,
          style: GoogleFonts.raleway(),
        )
      ],
    );
  }

  Widget _toppingItemUIDragged(Topping topping) {
    return CircleAvatar(
      radius: 34,
      backgroundImage: NetworkImage(topping.smallImage),
    );
  }

  Widget _selectedToppingItemUI(Topping topping) {
    return Column(
      children: [
        CircleAvatar(
          radius: 34,
          child: Icon(
            Icons.verified_user,
            color: Colors.green[500],
            size: 34,
          ),
        ),
        SizedBox(height: 6),
        Text(
          topping.name,
          style: GoogleFonts.raleway(),
        )
      ],
    );
  }

  Widget _cancelToppingItemUI(Topping topping, HomeController controller) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.removeTopping(topping),
          child: CircleAvatar(
            backgroundImage: NetworkImage(topping.smallImage),
            backgroundColor: Colors.red,
            radius: 34,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.7),
              radius: 34,
              child: Icon(
                Icons.cancel,
                size: 40,
                color: Colors.red,
              ),
            ),
          ),
        ),
        SizedBox(height: 6),
        Text(
          topping.name,
          style: GoogleFonts.raleway(),
        )
      ],
    );
  }
}

// class CustomRect extends CustomClipper<Rect> {
//   @override
//   Rect getClip(Size size) {
//     Rect rect = Rect.fromLTRB(0.0, 0.0, size.width - 50, size.height);
//     return rect;
//   }

//   @override
//   bool shouldReclip(CustomRect oldClipper) {
//     return true;
//   }
// }
