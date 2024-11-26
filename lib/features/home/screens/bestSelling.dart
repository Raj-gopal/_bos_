import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../common/basewidget/title_row_widget.dart';
import '../../../helper/price_converter.dart';
import '../../../utill/color_resources.dart';
import '../../deal/screens/featured_deal_screen_view.dart';
import '../../deal/widgets/featured_deal_list_widget.dart';
import '../widgets/aster_theme/find_what_you_need_shimmer.dart';

enum ProductType { bestSelling, featured, latest }

class FeaturedDealsScreen extends StatefulWidget {
  const FeaturedDealsScreen({super.key});

  @override
  _FeaturedDealsScreenState createState() => _FeaturedDealsScreenState();
}

class _FeaturedDealsScreenState extends State<FeaturedDealsScreen> {
  ProductType _selectedProductType = ProductType.bestSelling;

  @override
  Widget build(BuildContext context) {
    // Fetch featured deals when the screen is first built
    Future.microtask(() =>
        Provider.of<FeaturedDealController>(context, listen: false)
            .getFeaturedDealList(true));

    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated('featured_deals', context) ?? 'Featured Deals'),
        actions: [
          PopupMenuButton<ProductType>(
            onSelected: (ProductType type) {
              setState(() {
                _selectedProductType = type;
                // Trigger an action based on selected product type if needed
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<ProductType>>[
              PopupMenuItem<ProductType>(
                value: ProductType.bestSelling,
                child: Text(
                  getTranslated('best_selling', context) ?? '',
                  style: textRegular.copyWith(
                    color: _selectedProductType == ProductType.bestSelling
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              PopupMenuItem<ProductType>(
                value: ProductType.featured,
                child: Text(
                  getTranslated('featured', context) ?? '',
                  style: textRegular.copyWith(
                    color: _selectedProductType == ProductType.featured
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
              PopupMenuItem<ProductType>(
                value: ProductType.latest,
                child: Text(
                  getTranslated('latest', context) ?? '',
                  style: textRegular.copyWith(
                    color: _selectedProductType == ProductType.latest
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<FeaturedDealController>(
        builder: (context, featuredDealProvider, child) {
          if (featuredDealProvider.featuredDealProductList == null) {
            return const FindWhatYouNeedShimmer(); // Show shimmer loading effect
          }

          if (featuredDealProvider.featuredDealProductList!.isEmpty) {
            return Center(
              child: Text(getTranslated('no_featured_deals_found', context) ??
                  'No Featured Deals Found'),
            );
          }

          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                color: Theme.of(context).colorScheme.onTertiary,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: TitleRowWidget(
                          title: '${getTranslated('featured_deals', context)}',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FeaturedDealScreenView()),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MasonryGridView.count(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  crossAxisCount:
                  MediaQuery.of(context).size.width > 600 ? 3 : 2, // Responsive layout
                  itemCount: featuredDealProvider.featuredDealProductList!.length,
                  itemBuilder: (context, index) {
                    final Product product =
                    featuredDealProvider.featuredDealProductList![index];
                    return ProductWidget(
                      productModel: product,
                      productNameLine: 2,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  final Product productModel;
  final int productNameLine;

  const ProductWidget({
    super.key,
    required this.productModel,
    this.productNameLine = 2,
  });

  @override
  Widget build(BuildContext context) {
    double rating = (productModel.rating?.isNotEmpty ?? false)
        ? double.parse('${productModel.rating?[0].average}')
        : 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 1000),
            pageBuilder: (context, anim1, anim2) => ProductDetails(
              productId: productModel.id,
              slug: productModel.slug,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(9, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final double imageHeight = constraints.maxWidth * 0.82;
                    return ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.radiusDefault),
                      ),
                      child: Stack(
                        children: [
                          CustomImageWidget(
                            image: productModel.thumbnailFullUrl?.path ?? '',
                            fit: BoxFit.cover,
                            height: imageHeight,
                            width: constraints.maxWidth,
                          ),
                          if (productModel.currentStock == 0 &&
                              productModel.productType == 'physical') ...[
                            Container(
                              height: imageHeight,
                              width: constraints.maxWidth,
                              color: Colors.black.withOpacity(0.4),
                            ),
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: constraints.maxWidth,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error
                                        .withOpacity(0.4),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(Dimensions.radiusSmall),
                                    ),
                                  ),
                                  child: Text(
                                    getTranslated('out_of_stock', context) ?? '',
                                    style: textBold.copyWith(
                                      color: Colors.white,
                                      fontSize: Dimensions.fontSizeSmall,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      if (rating > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star_rate_rounded,
                              color: Colors.orange,
                              size: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 2.0),
                              child: Text(
                                rating.toStringAsFixed(1),
                                style: textRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                ),
                              ),
                            ),
                            Text(
                              '(${productModel.reviewCount.toString()})',
                              style: textRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: Dimensions.paddingSizeSmall,
                        ),
                        child: Text(
                          productModel.name ?? '',
                          textAlign: TextAlign.center,
                          style: textMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                          maxLines: productNameLine,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (productModel.discount != null &&
                          productModel.discount! > 0)
                        Text(
                          PriceConverter.convertPrice(
                              context, productModel.unitPrice),
                          style: titleRegular.copyWith(
                            color: Theme.of(context).hintColor,
                            decoration: TextDecoration.lineThrough,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      const SizedBox(height: 2),
                      Text(
                        PriceConverter.convertPrice(
                          context,
                          productModel.unitPrice,
                          discountType: productModel.discountType,
                          discount: productModel.discount,
                        ),
                        style: robotoBold.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                    ],
                  ),
                ),
              ],
            ),
            if (productModel.discount != null && productModel.discount! > 0)
              Positioned(
                top: 10,
                left: 0,
                child: Container(
                  transform: Matrix4.translationValues(-1, 0, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                      bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                    ),
                  ),
                  child: Center(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        PriceConverter.percentageCalculation(
                          context,
                          productModel.unitPrice,
                          productModel.discount,
                          productModel.discountType,
                        ),
                        style: textBold.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              )
            else
              const SizedBox.shrink(),
            Positioned(
              top: 8,
              right: 10,
              child: FavouriteButtonWidget(
                backgroundColor: ColorResources.getImageBg(context),
                productId: productModel.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
