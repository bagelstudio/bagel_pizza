import 'package:bagel_pizza/controller/home_controller.dart';
import 'package:bagel_pizza/scoped_model/base_view.dart';
import 'package:bagel_pizza/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flare_flutter/flare_actor.dart';

class CheckOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeController>(
      builder: (context, childe, model) => Container(
        decoration:
            BoxDecoration(image: DecorationImage(image: AssetImage('assets/pictures/bg.jpg'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Container(height: 28, child: Image.asset('assets/pictures/logo.png')),
            centerTitle: true,
          ),
          body: Center(
            child: !model.formSent
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          children: [
                            Text('Price:', style: TextStyle(fontSize: 18, fontFamily: 'Raleway')),
                            Text(
                              '\$' + model.calculateTotalPrice().toStringAsFixed(1),
                              style: TextStyle(fontFamily: 'Raleway', fontSize: 50, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      pizzaFormUI(model, context),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: FlatButton(
                          disabledColor: Colors.red,
                          color: Colors.red,
                          onPressed: () {
                            if (model.fbKey.currentState.saveAndValidate()) {
                              model.submitForm(model.fbKey.currentState.value);
                            } else {
                              print(model.fbKey.currentState.value);
                              print("validation failed");
                            }
                          },
                          splashColor: Colors.red[200],
                          child: model.loadingFormSubmit
                              ? SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                )
                              : Text('Submit', style: TextStyle(fontFamily: 'Raleway', color: Colors.white)),
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              //side: BorderSide(color: Colors.blue, width: 1, style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(height: 10)
                    ],
                  )
                : model.submitError
                    ? Column(
                        children: [Text('Err!')],
                      )
                    : Center(
                        child: Column(
                          children: [
                            SizedBox(height: 50),
                            Center(
                              child: Text(
                                'Thank you for order!',
                                style: TextStyle(fontFamily: 'Raleway', fontSize: 28),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: Text(
                                'We will be in touch\n to take payment :-)',
                                style: TextStyle(fontFamily: 'Raleway', fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 35),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: FlareActor("assets/animations/confetti_boom.flr",
                                  alignment: Alignment.center, fit: BoxFit.contain, snapToEnd: true, animation: "boom"),
                            ),
                            FlatButton(
                              disabledColor: Colors.red,
                              color: Colors.red,
                              onPressed: () {
                                model.pizzasList.clear();
                                model.loadingFormSubmit = false;
                                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeView()));
                              },
                              splashColor: Colors.red[200],
                              child: Text('New order', style: TextStyle(fontFamily: 'Raleway', color: Colors.white)),
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            ),
                          ],
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  Widget pizzaFormUI(HomeController model, BuildContext context) {
    return FormBuilder(
        key: model.fbKey,
        initialValue: {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              formFieldUI(
                attribute: "name",
                labelText: "Name",
                validators: [FormBuilderValidators.required(), FormBuilderValidators.maxLength(30)],
              ),
              formFieldUI(
                attribute: "email",
                labelText: "Email",
                validators: [FormBuilderValidators.required(), FormBuilderValidators.email()],
              ),
              formFieldUI(
                attribute: "phone",
                labelText: "Phone",
                validators: [
                  FormBuilderValidators.required(),
                ],
              ),
              formFieldUI(
                attribute: "adress",
                labelText: "Adress",
                validators: [FormBuilderValidators.required(), FormBuilderValidators.maxLength(30)],
              ),
            ],
          ),
        ));
  }

  Widget formFieldUI({String attribute, String labelText, List<String Function(dynamic)> validators}) {
    return Column(
      children: [
        FormBuilderTextField(
          cursorColor: Colors.white,
          textDirection: TextDirection.ltr,
          initialValue: '',
          attribute: attribute,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.red)),
            filled: false,
            contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            labelStyle: TextStyle(fontFamily: 'Raleway', color: Colors.white),
            labelText: labelText,
          ),
          onChanged: (val) => print(val),
          validators: validators,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
