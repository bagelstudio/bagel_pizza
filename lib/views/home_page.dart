import 'package:bagel_pizza/controller/home_controller.dart';
import 'package:bagel_pizza/model/topping_model.dart';
import 'package:bagel_pizza/scoped_model/base_view.dart';
import 'package:bagel_pizza/views/ordered_page.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import '../controller/home_controller.dart';

class HomeView extends StatelessWidget {
  final Map args;
  const HomeView({Key key, this.args}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeController>(
      onModelReady: (model) => model.init(pizzaMap: args),
      builder: (context, childe, model) => Container(
        decoration:
            BoxDecoration(image: DecorationImage(image: AssetImage('assets/pictures/bg.jpg'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: Container(),
            title: Container(height: 28, child: Image.asset('assets/pictures/logo.png')),
            centerTitle: true,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _customDivider(),
              model.sizesList.isEmpty
                  ? Container(
                      height: 14,
                      width: 14,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : _chipsUI(model),
              _customDivider(),
              DragTarget<Topping>(
                builder: (context, accepted, rejected) {
                  return Stack(alignment: Alignment.topCenter, children: [
                    _bigPizzaUI(model, accepted),
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
                onAccept: (Topping topping) => model.addToppingToPizza(topping),
              ),
              SizedBox(height: 13),
              _scrolledToppingsUI(model),
              SizedBox(height: 5),
              _nextButtonUI(model, context),
              SizedBox(height: 13)
            ],
          ),
        ),
      ),
    );
  }

  Widget _toppingItemUI(Topping topping) {
    return Column(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundImage: NetworkImage(topping.smallImage),
        ),
        SizedBox(height: 6),
        Text(
          '${topping.name}',
          style: TextStyle(fontFamily: 'Raleway'),
        ),
        SizedBox(height: 3),
        Text(
          '\$' + '${topping.price.toString()}',
          style: TextStyle(fontFamily: 'Raleway', color: Colors.red, fontWeight: FontWeight.bold),
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
          style: TextStyle(fontFamily: 'Raleway'),
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
          style: TextStyle(fontFamily: 'Raleway'),
        )
      ],
    );
  }

  Widget _chipsUI(HomeController model) {
    return ChipsChoice<int>.single(
      value: model.tag,
      options: ChipsChoiceOption.listFrom<int, String>(
        source: model.sizesStringsToDisplay,
        value: (i, v) => i,
        label: (i, v) => v,
      ),
      itemConfig: ChipsChoiceItemConfig(
        elevation: 1,
        spacing: 30.0,
        selectedColor: Colors.red,
        showCheckmark: true,
        labelStyle: TextStyle(fontFamily: 'Raleway', fontSize: 14),
        selectedBrightness: Brightness.dark,
      ),
      onChanged: (val) => model.changePizzaSize(val),
      isWrapped: false,
    );
  }

  Widget _draggableUI(HomeController model, int index) {
    return Draggable<Topping>(
        data: model.toppingsList[index],
        child: model.pizzaToppingsImages.contains(model.toppingsList[index].pizzaImage) && model.finishDrag
            ? _cancelToppingItemUI(model.toppingsList[index], model)
            : _toppingItemUI(model.toppingsList[index]),
        feedback: _toppingItemUIDragged(model.toppingsList[index]),
        affinity: Axis.vertical,
        onDragStarted: () => model.finishDrag = false,
        onDragCompleted: () => model.finishDrag = true,
        onDraggableCanceled: (v, o) => model.finishDrag = true,
        onDragEnd: (val) => model.finishDrag = true,
        childWhenDragging: _selectedToppingItemUI(model.toppingsList[index]));
  }

  Widget _nextButtonUI(HomeController model, BuildContext context) {
    return FlatButton(
      disabledColor: Colors.red,
      color: Colors.red,
      onPressed: () {
        model.savePizza();
        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderedPage()));
      },
      splashColor: Colors.red[200],
      child: Text('Next', style: TextStyle(fontFamily: 'Raleway', color: Colors.white)),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    );
  }

  Widget _customDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, right: 10, left: 10),
      child: Container(color: Colors.white.withOpacity(0.5), height: 0.3),
    );
  }

  Widget _bigPizzaUI(HomeController model, List<Topping> accepted) {
    return Center(
      child: CircleAvatar(
        radius: 145,
        backgroundColor: !model.finishDrag && accepted.isNotEmpty ? Colors.red : Colors.transparent,
        child: CircleAvatar(
          radius: 140,
          backgroundImage: AssetImage('assets/pictures/pizza.png'),
        ),
      ),
    );
  }

  Widget _scrolledToppingsUI(HomeController model) {
    return SizedBox(
      height: 110,
      child: model.toppingsList.isEmpty
          ? Center(
              child: Column(
              children: [
                SizedBox(height: 6),
                Text(
                  'Loading toppings...',
                  style: TextStyle(fontFamily: 'Raleway', fontSize: 10),
                ),
                SizedBox(height: 13),
                SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 3,
                    )),
              ],
            ))
          : ListView.separated(
              separatorBuilder: (context, index) => SizedBox(
                    width: 15,
                  ),
              scrollDirection: Axis.horizontal,
              itemCount: model.toppingsList.length,
              itemBuilder: (BuildContext context, int index) {
                return _draggableUI(model, index);
              }),
    );
  }
}
