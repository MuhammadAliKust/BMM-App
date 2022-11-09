import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/order_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../data/model/response/cart_model.dart';
import '../../../data/model/response/product_model.dart';
import '../../base/custom_image.dart';
import '../../base/custom_text_field.dart';
import '../../base/product_bottom_sheet.dart';
import '../../base/quantity_button.dart';
import '../../base/rating_bar.dart';

class CartScreen extends StatefulWidget {
  final fromNav;

  CartScreen({@required this.fromNav});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Get.find<CartController>().calculationCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'my_cart'.tr,
          isBackButtonExist:
              (ResponsiveHelper.isDesktop(context) || !widget.fromNav)),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          return cartController.cartList.length > 0
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          child: Center(
                            child: SizedBox(
                              width: Dimensions.WEB_MAX_WIDTH,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: cartController.cartList.length,
                                      itemBuilder: (context, index) {
                                        return getCartProductWidget(context,
                                            cart:
                                                cartController.cartList[index],
                                            cartIndex: index,
                                            addOns: cartController
                                                .addOnsList[index],
                                            isAvailable: cartController
                                                .availableList[index]);
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "*Slide to Delete",
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),

                                    // Total
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('item_price'.tr,
                                              style: robotoRegular),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  cartController.itemPrice),
                                              style: robotoRegular),
                                        ]),
                                    SizedBox(height: 10),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('addons'.tr,
                                              style: robotoRegular),
                                          Text(
                                              '(+) ${PriceConverter.convertPrice(cartController.addOns)}',
                                              style: robotoRegular),
                                        ]),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: Divider(
                                          thickness: 1,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.5)),
                                    ),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('subtotal'.tr,
                                              style: robotoMedium),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  cartController.subTotal),
                                              style: robotoMedium),
                                        ]),

                                    SizedBox(
                                      height: 30,
                                    ),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('additional_note'.tr,
                                              style: robotoMedium),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_DEFAULT),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .RADIUS_SMALL),
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor)),
                                            child: CustomTextField(
                                              controller: _noteController,
                                              hintText:
                                                  'ex_please_provide_extra_napkin'
                                                      .tr,
                                              maxLines: 3,
                                              inputType:
                                                  TextInputType.multiline,
                                              inputAction:
                                                  TextInputAction.newline,
                                              capitalization:
                                                  TextCapitalization.sentences,
                                            ),
                                          ),
                                        ]),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                          buttonText: 'proceed_to_checkout'.tr,
                          onPressed: () {
                            Get.find<OrderController>().setOrderType('delivery', notify: true);
                            Get.find<OrderController>().selectDelivery(0);
                            if (!cartController
                                    .cartList.first.product.scheduleOrder &&
                                cartController.availableList.contains(false)) {
                              showCustomSnackBar(
                                  'one_or_more_product_unavailable'.tr);
                            } else {
                              Get.find<CouponController>()
                                  .removeCouponData(false);
                              Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                            }
                          }),
                    ),
                  ],
                )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NoDataScreen(isCart: true, text: ''),
                  Container(
                    width: Dimensions.WEB_MAX_WIDTH,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: CustomButton(
                        buttonText: 'Continue Shopping'.tr,
                        onPressed: () {
                          print("Called");
                          Get.offAll(()=>DashboardScreen(pageIndex: 0));
                        }),
                  ),
                ],
              );
        },
      ),
    );
  }

  getCartProductWidget(BuildContext context,
      {@required CartModel cart,
      @required int cartIndex,
      @required List<AddOns> addOns,
      @required bool isAvailable}) {
    String _addOnText = '';
    int _index = 0;
    List<int> _ids = [];
    List<int> _qtys = [];
    cart.addOnIds.forEach((addOn) {
      _ids.add(addOn.id);
      _qtys.add(addOn.quantity);
    });
    cart.product.addOns.forEach((addOn) {
      if (_ids.contains(addOn.id)) {
        _addOnText = _addOnText +
            '${(_index == 0) ? '' : ',  '}${addOn.name} (${_qtys[_index]})';
        _index = _index + 1;
      }
    });

    String _variationText = '';
    if (cart.variation.length > 0) {
      List<String> _variationTypes = cart.variation[0].type.split('-');
      if (_variationTypes.length == cart.product.choiceOptions.length) {
        int _index = 0;
        cart.product.choiceOptions.forEach((choice) {
          _variationText = _variationText +
              '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      } else {
        _variationText = cart.product.variations[0].type;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT),
      child: InkWell(
        onTap: () {
          ResponsiveHelper.isMobile(context)
              ? showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) => ProductBottomSheet(
                      product: cart.product, cartIndex: cartIndex, cart: cart),
                )
              : showDialog(
                  context: context,
                  builder: (con) => Dialog(
                        child: ProductBottomSheet(
                            product: cart.product,
                            cartIndex: cartIndex,
                            cart: cart),
                      ));
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
          child: Stack(children: [
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              left: 0,
              child: Icon(Icons.delete, color: Colors.white, size: 50),
            ),
            Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) =>
                  Get.find<CartController>().removeFromCart(cartIndex),
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[Get.isDarkMode ? 800 : 200],
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(children: [
                      (cart.product.image != null &&
                              cart.product.image.isNotEmpty)
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  child: CustomImage(
                                    image:
                                        '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${cart.product.image}',
                                    height: 65,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                isAvailable
                                    ? SizedBox()
                                    : Positioned(
                                        top: 0,
                                        left: 0,
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          child:
                                              Text('not_available_now_break'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: robotoRegular.copyWith(
                                                    color: Colors.white,
                                                    fontSize: 8,
                                                  )),
                                        ),
                                      ),
                              ],
                            )
                          : SizedBox.shrink(),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                cart.product.name,
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              RatingBar(
                                  rating: cart.product.avgRating,
                                  size: 12,
                                  ratingCount: cart.product.ratingCount),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    PriceConverter.convertPrice(
                                                (cart.discountedPrice +
                                                    cart.discountAmount))
                                            .toString() +
                                        " x " +
                                        cart.quantity.toString() +
                                        " : ",
                                    style: robotoRegular.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: Dimensions.fontSizeSmall),
                                  ),
                                  Text(
                                    PriceConverter.convertPrice(
                                        (cart.discountedPrice +
                                                cart.discountAmount) *
                                            cart.quantity),
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Get.find<SplashController>()
                                    .configModel
                                    .toggleVegNonVeg
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                        horizontal:
                                            Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    child: Text(
                                      cart.product.veg == 0
                                          ? 'non_veg'.tr
                                          : 'veg'.tr,
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color: Colors.white),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                                height: Get.find<SplashController>()
                                        .configModel
                                        .toggleVegNonVeg
                                    ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                    : 0),
                            Row(children: [
                              QuantityButton(
                                onTap: () {
                                  if (cart.quantity > 1) {
                                    Get.find<CartController>()
                                        .setQuantity(false, cart);
                                  } else {
                                    Get.find<CartController>()
                                        .removeFromCart(cartIndex);
                                  }

                                  Get.find<CartController>().calculationCart();
                                  setState(() {});
                                },
                                isIncrement: false,
                              ),
                              Text(cart.quantity.toString(),
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeExtraLarge)),
                              QuantityButton(
                                onTap: () {
                                  Get.find<CartController>()
                                      .setQuantity(true, cart);

                                  Get.find<CartController>().calculationCart();
                                },
                                isIncrement: true,
                              ),
                            ]),
                          ]),
                      !ResponsiveHelper.isMobile(context)
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_SMALL),
                              child: IconButton(
                                onPressed: () {
                                  Get.find<CartController>()
                                      .removeFromCart(cartIndex);
                                  setState(() {});
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            )
                          : SizedBox(),
                    ]),
                    _addOnText.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Row(children: [
                              SizedBox(width: 80),
                              Text('${'addons'.tr}: ',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),
                              Flexible(
                                  child: Text(
                                _addOnText,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).disabledColor),
                              )),
                            ]),
                          )
                        : SizedBox(),
                    cart.product.variations.length > 0
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Row(children: [
                              SizedBox(width: 80),
                              Text('${'variations'.tr}: ',
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),
                              Flexible(
                                  child: Text(
                                _variationText,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).disabledColor),
                              )),
                            ]),
                          )
                        : SizedBox(),

                    /*addOns.length > 0 ? SizedBox(
                      height: 30,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                        itemCount: addOns.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                            child: Row(children: [
                              InkWell(
                                onTap: () {
                                  Get.find<CartController>().removeAddOn(cartIndex, index);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: Icon(Icons.remove_circle, color: Theme.of(context).primaryColor, size: 18),
                                ),
                              ),
                              Text(addOns[index].name, style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                              SizedBox(width: 2),
                              Text(
                                PriceConverter.convertPrice(addOns[index].price),
                                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '(${cart.addOnIds[index].quantity})',
                                style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                              ),
                            ]),
                          );
                        },
                      ),
                    ) : SizedBox(),*/
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
