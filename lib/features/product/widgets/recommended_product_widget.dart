import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/recommended_product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';

class RecommendedProductWidget extends StatelessWidget {
  final bool fromAsterTheme;
  const RecommendedProductWidget({super.key, this.fromAsterTheme = false});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final bool isLtr = Provider.of<LocalizationController>(context, listen: false).isLtr;
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall, ),
      color: Theme.of(context).colorScheme.onTertiary,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Consumer<ProductController>(
            builder: (context, recommended, child) {
              String? rating = recommended.recommendedProduct != null && recommended.recommendedProduct!.rating != null &&
                  recommended.recommendedProduct!.rating!.isNotEmpty
                  ? recommended.recommendedProduct!.rating![0].average
                  : "0";

              return recommended.recommendedProduct != null
                  ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 1000),
                      pageBuilder: (context, anim1, anim2) => ProductDetails(
                        productId: recommended.recommendedProduct!.id,
                        slug: recommended.recommendedProduct!.slug,
                      ),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (fromAsterTheme) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                        child: Text(
                          getTranslated('dont_miss_the_chance', context) ?? '',
                          style: textBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Provider.of<ThemeController>(context, listen: false).darkTheme
                                ? Theme.of(context).hintColor
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        child: Text(
                          getTranslated('lets_shopping_today', context) ?? '',
                          style: textBold.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge,
                            color: Provider.of<ThemeController>(context, listen: false).darkTheme
                                ? Theme.of(context).hintColor
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault, top: Dimensions.paddingSizeExtraSmall),
                        child: Text(
                          getTranslated('deal_of_the_day', context) ?? '',
                          style: textBold.copyWith(
                            fontSize: Dimensions.fontSizeExtraLarge,
                            color: Provider.of<ThemeController>(context, listen: false).darkTheme
                                ? Theme.of(context).hintColor
                                : Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                    Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeSmall)),
                        color: Provider.of<ThemeController>(context, listen: false).darkTheme
                            ? Theme.of(context).highlightColor
                            : Theme.of(context).highlightColor,
                        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.3), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (recommended.recommendedProduct?.thumbnail != null) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).highlightColor,
                                border: Border.all(color: Theme.of(context).primaryColor, width: .5),
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                child: Stack(
                                  children: [
                                    CustomImageWidget(
                                      height: ResponsiveHelper.isTab(context) ? 250 : size.width * 0.4,
                                      width: ResponsiveHelper.isTab(context) ? 230 : size.width * 0.8,
                                      image: '${recommended.recommendedProduct?.thumbnailFullUrl?.path}',
                                    ),
                                    if (recommended.recommendedProduct!.currentStock == 0 &&
                                        recommended.recommendedProduct!.productType == 'physical') ...[
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            width: ResponsiveHelper.isTab(context) ? 230 : size.width * 0.4,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).colorScheme.error.withOpacity(0.4),
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(Dimensions.radiusSmall),
                                                topRight: Radius.circular(Dimensions.radiusSmall),
                                              ),
                                            ),
                                            child: Text(
                                              getTranslated('out_of_stock', context) ?? '',
                                              style: textBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.paddingSizeDefault),
                          ],
                          Text(
                            recommended.recommendedProduct?.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.star, color: Provider.of<ThemeController>(context).darkTheme ? Colors.white : Colors.orange, size: 15),
                              Text(double.parse(rating!).toStringAsFixed(1), style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              Text('(${recommended.recommendedProduct?.reviewCount ?? '0'})',
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor)),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (recommended.recommendedProduct?.discount != null && recommended.recommendedProduct!.discount! > 0) ...[
                                Text(
                                  PriceConverter.convertPrice(context, recommended.recommendedProduct!.unitPrice),
                                  style: textRegular.copyWith(
                                    color: Theme.of(context).hintColor,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: Dimensions.fontSizeSmall,
                                  ),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              ],
                              Text(
                                PriceConverter.convertPrice(
                                  context,
                                  recommended.recommendedProduct!.unitPrice,
                                  discountType: recommended.recommendedProduct!.discountType,
                                  discount: recommended.recommendedProduct!.discount,
                                ),
                                style: textBold.copyWith(
                                  color: ColorResources.getPrimary(context),
                                  fontSize: Dimensions.fontSizeLarge,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Container(
                            width: MediaQuery.of(context).size.width*.8,
                            height:MediaQuery.of(context).size.height*.045,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeOverLarge)),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                getTranslated('buy_now', context)!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //   top: 8,
                    //   right: isLtr ? 25 : null,
                    //   left: !isLtr ? 25 : null,
                    //   child: FavouriteButtonWidget(
                    //     backgroundColor: ColorResources.getImageBg(context),
                    //     productId: recommended.recommendedProduct?.id,
                    //   ),
                    // ),
                    if (recommended.recommendedProduct != null && recommended.recommendedProduct!.discount != null &&
                        recommended.recommendedProduct!.discount! > 0) ...[
                      Positioned(
                        top: 25,
                        left: isLtr ? 32 : null,
                        right: !isLtr ? 27 : null,
                        child: Container(
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(2)),
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              PriceConverter.percentageCalculation(
                                context,
                                recommended.recommendedProduct!.unitPrice,
                                recommended.recommendedProduct!.discount,
                                recommended.recommendedProduct!.discountType,
                              ),
                              style: textRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              )
                  : const RecommendedProductShimmer();
            },
          ),
        ],
      ),
    );
  }
}
