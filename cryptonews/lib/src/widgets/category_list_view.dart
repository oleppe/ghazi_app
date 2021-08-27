import 'package:cryptonews/src/config/color_constants.dart';
import 'package:cryptonews/src/config/image_constants.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key, this.category, this.animation, this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final dynamic category;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: callback,
      child: SizedBox(
        width: 280,
        child: Stack(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: hexToColor('#F8FAFB'),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48 + 24.0,
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      "category!.title",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          letterSpacing: 0.27,
                                          color: ColorConstants.nearlyBlack),
                                    ),
                                  ),
                                  const Expanded(
                                    child: SizedBox(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '15 lesson',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 12,
                                            letterSpacing: 0.27,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                '25',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 18,
                                                  letterSpacing: 0.27,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: ColorConstants.grey,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 16, right: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '\$25',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.27,
                                            color: ColorConstants.grey,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ColorConstants.grey,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8.0)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.add,
                                              color: ColorConstants.nearlyWhite,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16),
                child: Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Image.asset(AllImages().logo)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
