import 'package:e_commer/provider/product.dart';
import 'package:e_commer/provider/products.dart';
import 'package:e_commer/widgets/image_box_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const route = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  bool _isInit = true;
  bool _isLoading = false;
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("An error occured"),
            content: Text("Something went wrong"),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Okay"))
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: value,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter valid price';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter price greater than 0';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        focusNode: _descriptionFocusNode,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter description';
                          }
                          if (value.length < 10) {
                            return 'Should be atleast 10 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          ImageBoxView(
                            child: _imageUrlController.text.isEmpty
                                ? Center(
                                    child: Text(
                                      'Enter Image URL',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter image url';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Enter valid URL';
                                }
                                if (!value.endsWith('jpg') &&
                                    !value.endsWith('jpeg') &&
                                    !value.endsWith('png')) {
                                  return 'Enter valid URL';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  imageUrl: value,
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
    );
  }
}
// class EditProductScreen extends StatefulWidget {
//   static const route = '/edit-product';

//   @override
//   _EditProductScreenState createState() => _EditProductScreenState();
// }

// class _EditProductScreenState extends State<EditProductScreen> {
//   final _priceFocusNode = FocusNode();
//   final _descriptionFocusNode = FocusNode();
//   final _form = GlobalKey<FormState>();
//   final _imageUrlFocusNode = FocusNode();
//   final _imageUrlController = TextEditingController();

// var _editedProduct = Product(
//   id: null,
//   title: '',
//   description: '',
//   price: 0.0,
//   imageUrl: '',
// );

//   _saveForm() {
//     _form.currentState.save();
//   }

// void _updateImageUrl() {
//   if (!_imageUrlFocusNode.hasFocus) {
//     setState(() {});
//   }
// }

//   @override
//   void initState() {
//     _imageUrlFocusNode.addListener(_updateImageUrl);
//     super.initState();
//   }

// @override
// void dispose() {
//   _imageUrlFocusNode.removeListener(_updateImageUrl);
//   _priceFocusNode.dispose();
//   _descriptionFocusNode.dispose();
//   _imageUrlController.dispose();
//   _imageUrlFocusNode.dispose();
//   super.dispose();
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// appBar: AppBar(
//   title: Text('Edit product'),
//   actions: <Widget>[
//     IconButton(
//       icon: Icon(Icons.save),
//       onPressed: () {
//         _saveForm();
//       },
//     )
//   ],
// ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Form(
//           key: _form,
//           child: ListView(
//             children: <Widget>[
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Title'),
//                 textInputAction: TextInputAction.next,
//                 onFieldSubmitted: (_) {
//                   FocusScope.of(context).requestFocus(_priceFocusNode);
//                 },
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Enter title';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _editedProduct = Product(
//                     title: value,
//                     price: _editedProduct.price,
//                     description: _editedProduct.description,
//                     imageUrl: _editedProduct.imageUrl,
//                     id: _editedProduct.id,
//                     isFavourite: _editedProduct.isFavourite,
//                   );
//                 },
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Price'),
//                 textInputAction: TextInputAction.next,
//                 keyboardType: TextInputType.number,
//                 focusNode: _priceFocusNode,
//                 onFieldSubmitted: (_) {
//                   FocusScope.of(context).requestFocus(_descriptionFocusNode);
//                 },
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Enter price';
//                   }
//                   if (double.tryParse(value) == null) {
//                     return 'Enter valid price';
//                   }
//                   if (double.parse(value) <= 0) {
//                     return 'Enter price greater than 0';
//                   }
//                   return null;
//                 },
//   onSaved: (value) {
//     _editedProduct = Product(
//       title: _editedProduct.title,
//       price: double.parse(value),
//       description: _editedProduct.description,
//       imageUrl: _editedProduct.imageUrl,
//       id: _editedProduct.id,
//       isFavourite: _editedProduct.isFavourite,
//     );
//   },
// ),
//               TextFormField(
//                 focusNode: _descriptionFocusNode,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 maxLines: 3,
//                 keyboardType: TextInputType.multiline,
//                 validator: (value) {
//                   if (value.isEmpty) {
//                     return 'Enter description';
//                   }
//                   if (value.length < 10) {
//                     return 'Should be atleast 10 characters';
//                   }
//                   return null;
//                 },
// onSaved: (value) {
//   _editedProduct = Product(
//     title: _editedProduct.title,
//     price: _editedProduct.price,
//     description: value,
//     imageUrl: _editedProduct.imageUrl,
//     id: _editedProduct.id,
//     isFavourite: _editedProduct.isFavourite,
//   );
// },
//               ),
// Row(
//   crossAxisAlignment: CrossAxisAlignment.end,
//   children: <Widget>[
//     Container(
//       width: 100,
//       height: 100,
//       margin: EdgeInsets.only(
//         top: 20,
//         right: 15,
//       ),
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: Colors.grey,
//           width: 1,
//         ),
//       ),
//       child: _imageUrlController.text.isEmpty
//           ? Center(
//               child: Text(
//                 'Enter Image URL',
//                 textAlign: TextAlign.center,
//               ),
//             )
//           : FittedBox(
//               child: Image.network(_imageUrlController.text),
//               fit: BoxFit.cover,
//             ),
//     ),
//     Expanded(
//       child: TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Image URL',
//         ),
//         keyboardType: TextInputType.url,
//         textInputAction: TextInputAction.done,
//         controller: _imageUrlController,
//         focusNode: _imageUrlFocusNode,
//         onFieldSubmitted: (_) {
//           _saveForm();
//         },
//         validator: (value) {
//           if (value.isEmpty) {
//             return 'Enter image url';
//           }
//           if (!value.startsWith('http') &&
//               !value.startsWith('https')) {
//             return 'Enter valid URL';
//           }
//           if (!value.endsWith('jpg') &&
//               !value.endsWith('jpeg') &&
//               !value.endsWith('png')) {
//             return 'Enter valid URL';
//           }
//           return null;
//         },
// onSaved: (value) {
//   _editedProduct = Product(
//     title: _editedProduct.title,
//     price: _editedProduct.price,
//     description: _editedProduct.description,
//     imageUrl: value,
//     id: _editedProduct.id,
//     isFavourite: _editedProduct.isFavourite,
//   );
// },
//       ),
//     ),
//   ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// // class EditProductScreen extends StatefulWidget {
// //   static const route = '/edit-product';
// //   @override
// //   _EditProductScreenState createState() => _EditProductScreenState();
// // }

// // class _EditProductScreenState extends State<EditProductScreen> {
// //   final _priceFocusNode = FocusNode();
// //   final _descriptionFocusNode = FocusNode();
// //   final _imageUrlController = TextEditingController();
// //   final _imageUrlFocusNode = FocusNode();
// //   final _form = GlobalKey<FormState>();
// //   bool _isLoading = false;
// //   var _editedProduct = Product(
// //     id: null,
// //     title: '',
// //     price: 0,
// //     description: '',
// //     imageUrl: '',
// //   );
//   var _initValues = {
//     'title': '',
//     'price': '',
//     'description': '',
//     'imageUrl': '',
//   };

//   bool _isInit = true;

//   @override
//   void initState() {
//     _imageUrlFocusNode.addListener(_updateImageUrl);
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       final productId = ModalRoute.of(context).settings.arguments as String;
//       if (productId != null) {
//         _editedProduct =
//             Provider.of<Products>(context, listen: false).findById(productId);
//         _initValues = {
//           'title': _editedProduct.title,
//           'description': _editedProduct.description,
//           'price': _editedProduct.price.toString(),
//           //'imageUrl': _editedProduct.imageUrl,
//         };
//         _imageUrlController.text = _editedProduct.imageUrl;
//       }
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _imageUrlFocusNode.removeListener(_updateImageUrl);
//     _priceFocusNode.dispose();
//     _descriptionFocusNode.dispose();
//     _imageUrlController.dispose();
//     _imageUrlFocusNode.dispose();
//     super.dispose();
//   }

//   void _updateImageUrl() {
//     if (!_imageUrlFocusNode.hasFocus) {
//       setState(() {});
//     }
//   }

//   Future<void> _saveForm() async {
//     final _isValid = _form.currentState.validate();
//     if (!_isValid) {
//       return;
//     }
//     _form.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     if (_editedProduct.id != null) {
//       await Provider.of<Products>(context, listen: false)
//           .editProduct(_editedProduct.id, _editedProduct);
//     } else {
//       try {
//         await Provider.of<Products>(context, listen: false)
//             .addProduct(_editedProduct);
//       } catch (error) {
//         await showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: Text('An error occured'),
//             content: Text(error.toString()),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Okay'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               )
//             ],
//           ),
//         );
//       }
//       // finally {
//       //   setState(() {
//       //     _isLoading = false;
//       //   });
//       //   Navigator.of(context).pop();
//       // }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit product'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveForm,
//           )
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: EdgeInsets.all(20),
//               child: Form(
//                 key: _form,
//                 child: ListView(
//                   children: <Widget>[
//                     TextFormField(
// initialValue: _initValues['title'],
//                       decoration: InputDecoration(labelText: 'Title'),
//                       textInputAction: TextInputAction.next,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_priceFocusNode);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Enter title';
//                         }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editedProduct = Product(
//                           title: value,
//                           price: _editedProduct.price,
//                           description: _editedProduct.description,
//                           imageUrl: _editedProduct.imageUrl,
//                           id: _editedProduct.id,
//                           isFavourite: _editedProduct.isFavourite,
//                         );
//                       },
//                     ),
// //                     TextFormField(
// //                       initialValue: _initValues['price'],
// //                       decoration: InputDecoration(labelText: 'Price'),
// //                       textInputAction: TextInputAction.next,
// //                       keyboardType: TextInputType.number,
// //                       focusNode: _priceFocusNode,
// //                       onFieldSubmitted: (_) {
// //                         FocusScope.of(context)
// //                             .requestFocus(_descriptionFocusNode);
// //                       },
// //                       validator: (value) {
// //                         if (value.isEmpty) {
// //                           return 'Enter price';
// //                         }
// //                         if (double.tryParse(value) == null) {
// //                           return 'Enter valid price';
// //                         }
// //                         if (double.parse(value) <= 0) {
// //                           return 'Enter price greater than 0';
// //                         }
// //                         return null;
// //                       },
// //                       onSaved: (value) {
// //                         _editedProduct = Product(
// //                           title: _editedProduct.title,
// //                           price: double.parse(value),
// //                           description: _editedProduct.description,
// //                           imageUrl: _editedProduct.imageUrl,
// //                           id: _editedProduct.id,
// //                           isFavourite: _editedProduct.isFavourite,
// //                         );
// //                       },
// //                     ),
// //                     TextFormField(
// //                       initialValue: _initValues['description'],
// //                       focusNode: _descriptionFocusNode,
// //                       decoration: InputDecoration(labelText: 'Description'),
// //                       maxLines: 3,
// //                       keyboardType: TextInputType.multiline,
// //                       validator: (value) {
// //                         if (value.isEmpty) {
// //                           return 'Enter description';
// //                         }
// //                         if (value.length < 10) {
// //                           return 'Should be atleast 10 characters';
// //                         }
// //                         return null;
// //                       },
// //                       onSaved: (value) {
// //                         _editedProduct = Product(
// //                           title: _editedProduct.title,
// //                           price: _editedProduct.price,
// //                           description: value,
// //                           imageUrl: _editedProduct.imageUrl,
// //                           id: _editedProduct.id,
// //                           isFavourite: _editedProduct.isFavourite,
// //                         );
// //                       },
// //                     ),
// //                     Row(
// //                       crossAxisAlignment: CrossAxisAlignment.end,
// //                       children: <Widget>[
// //                         Container(
// //                           width: 100,
// //                           height: 100,
// //                           margin: EdgeInsets.only(
// //                             top: 20,
// //                             right: 15,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(
// //                               color: Colors.grey,
// //                               width: 1,
// //                             ),
// //                           ),
// //                           child: _imageUrlController.text.isEmpty
// //                               ? Center(
// //                                   child: Text(
// //                                     'Enter Image URL',
// //                                     textAlign: TextAlign.center,
// //                                   ),
// //                                 )
// //                               : FittedBox(
// //                                   child:
// //                                       Image.network(_imageUrlController.text),
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                         ),
// //                         Expanded(
// //                           child: TextFormField(
// //                             decoration: InputDecoration(
// //                               labelText: 'Image URL',
// //                             ),
// //                             keyboardType: TextInputType.url,
// //                             textInputAction: TextInputAction.done,
// //                             controller: _imageUrlController,
// //                             focusNode: _imageUrlFocusNode,
// //                             onFieldSubmitted: (_) {
// //                               _saveForm();
// //                             },
// //                             validator: (value) {
// //                               if (value.isEmpty) {
// //                                 return 'Enter image url';
// //                               }
// //                               if (!value.startsWith('http') &&
// //                                   !value.startsWith('https')) {
// //                                 return 'Enter valid URL';
// //                               }
// //                               if (!value.endsWith('jpg') &&
// //                                   !value.endsWith('jpeg') &&
// //                                   !value.endsWith('png')) {
// //                                 return 'Enter valid URL';
// //                               }
// //                               return null;
// //                             },
// //                             onSaved: (value) {
// //                               _editedProduct = Product(
// //                                 title: _editedProduct.title,
// //                                 price: _editedProduct.price,
// //                                 description: _editedProduct.description,
// //                                 imageUrl: value,
// //                                 id: _editedProduct.id,
// //                                 isFavourite: _editedProduct.isFavourite,
// //                               );
// //                             },
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //     );
// //   }
// // }
