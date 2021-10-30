import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MenuOficce extends StatefulWidget {
  MenuOficce({Key key, this.title}) : super(key: key);

  String nombres;
  String pedido;
  double precio;
  int cantidad;

  double total = 0;
  double descuento = 0;
  double totalapagar = 0;

  bool validacion = false;
  double delivery = 0;
  bool validaciondelivery = false;
  bool defaultvalue = false;
  int porcentaje = 0;
  String mensaje;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MenuOficce> {
  final _tfNombres = TextEditingController();
  final _tfPedido = TextEditingController();
  final _tfPrecio = TextEditingController();
  final _tfCantidad = TextEditingController();

  double _calcularMontoParcial() {
    setState(() {
      widget.validacion = false;
      if (_tfCantidad.text.toString() == "" ||
          _tfPrecio.text.toString() == "") {
        widget.validacion = true;
        widget.mensaje = "Falta Ingresar un Dato";

        return;
      }

      widget.cantidad = int.parse(_tfCantidad.text.toString());
      widget.precio = double.parse(_tfPrecio.text.toString());
      widget.total = widget.cantidad * widget.precio;
    });

    return widget.total;
  }

  double _calcularDescuento() {
    setState(() {
      if (_calcularMontoParcial() > 500) {
        widget.porcentaje = 5;
        widget.descuento = _calcularMontoParcial() * widget.porcentaje / 100;
        return;
      }
    });
    return widget.descuento;
  }

  bool _delivery() {
    if (widget.defaultvalue == false) {
      widget.delivery = 0;
      return widget.validaciondelivery = false;
    }

    return widget.validaciondelivery = true;
  }

  double _montodelivery() {
    setState(() {
      if (_delivery() == true) {
        return widget.delivery = 20;
      }
    });

    return widget.delivery;
  }

  void _calcularPagoTotal() {
    setState(() {
      widget.totalapagar =
          (_calcularMontoParcial() + _montodelivery()) - _calcularDescuento();

      return widget.totalapagar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                "Complete los campos requeridos",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _tfNombres,
                    decoration: InputDecoration(
                      hintText: "Ingrese el nombre",
                      labelText: "Nombres",
                    ),
                  ),
                  TextField(
                      controller: _tfPedido,
                      decoration: InputDecoration(
                        hintText: "Ingrese el pedido",
                        labelText: "Pedido",
                      )),
                  TextField(
                      controller: _tfPrecio,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "Ingrese el precio",
                        labelText: "Precio",
                        errorText: _tfPrecio.text.toString() == ""
                            ? widget.mensaje
                            : null,
                      )),
                  TextField(
                      controller: _tfCantidad,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "Ingrese la cantidad",
                        labelText: "Cantidad",
                        errorText: _tfCantidad.text.toString() == ""
                            ? widget.mensaje
                            : null,
                      )),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Descuento: " +
                                  widget.porcentaje.toString() +
                                  '%',
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              "Delivery: " + widget.delivery.toString(),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Total Parcial: " + widget.total.toString(),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              "Descuento Total: " + widget.descuento.toString(),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            Text(
                              "Total a Pagar: " + widget.totalapagar.toString(),
                              textAlign: TextAlign.left,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
            Column(
              children: [
                Text(
                  "Desea envio por delivery?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Switch(
                  value: widget.defaultvalue,
                  onChanged: (_delivery) {
                    setState(() {
                      widget.defaultvalue = _delivery;
                      widget.validaciondelivery = false;
                    });
                  },
                  activeColor: Color(0xff06bbfb),
                ),
                RaisedButton(
                  onPressed: _calcularPagoTotal,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  color: Colors.green,
                  child: Text(
                    "Procesar",
                    style: TextStyle(fontSize: 18, fontFamily: 'rbold'),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
