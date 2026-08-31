import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:eltrack_mobile/features/home/service/articleService.dart';
import 'package:eltrack_mobile/features/home/service/nearestDropoff_service.dart';

import 'package:eltrack_mobile/features/home/pages/Categories/Articles/ArticlePage.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/WasteGuide/WasteGuidePage.dart';

class K3Page extends StatefulWidget {
  const K3Page({super.key});

  @override
  State<K3Page> createState() => _K3PageState();
}

class _K3PageState extends State<K3Page> {
  static const Color primaryGreen = Color(0xFFA7C49E);
  static const Color darkGreen = Color(0xFF768973);
  static const Color lightGreen = Color(0xFFD4E3CF);

  bool loadingArticles = true;
  bool loadingDropOff = true;

  List<dynamic> articles = [];
  List<dynamic> nearestDropOffs = [];

  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _loadPageData();
  }

  Future<void> _loadPageData() async {
    await Future.wait([
      _loadArticles(),
      _loadLocationAndDropOff(),
    ]);
  }


  Future<void> _loadArticles() async {
    try {
      final result = await articleService.getArticles('k3');

      if (!mounted) return;

      setState(() {
        articles = result;
        loadingArticles = false;
      });
    } catch (e) {
      debugPrint('K3 ARTICLE ERROR: $e');

      if (!mounted) return;

      setState(() {
        loadingArticles = false;
      });
    }
  }


  Future<void> _loadLocationAndDropOff() async {
    try {
      final permission = await Geolocator.checkPermission();

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        if (!mounted) return;

        setState(() {
          loadingDropOff = false;
        });

        return;
      }

      final position = await Geolocator.getCurrentPosition();

      currentPosition = position;

      final places =
          await nearestDropoff_service.getNearestDropOff(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) return;

      setState(() {
        nearestDropOffs = places.take(5).toList();
        loadingDropOff = false;
      });
    } catch (e) {
      debugPrint('K3 DROP OFF ERROR: $e');

      if (!mounted) return;

      setState(() {
        loadingDropOff = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  30,
                  26,
                  30,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBackButton(),

                    const SizedBox(height: 24),

                    _buildCategoryTitle(),

                    const SizedBox(height: 36),

                    _buildArticleTitle(),

                    const SizedBox(height: 12),

                    _buildArticlePreview(),

                    const SizedBox(height: 32),

                    const Text(
                      'Types of K3 Waste',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .8,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _buildWasteTypes(),

                    const SizedBox(height: 38),

                    const Text(
                      '5 Nearest K3 Drop Off',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .8,
                      ),
                    ),

                    const SizedBox(height: 13),

                    _buildNearestDropOff(),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }



  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 25,
        height: 25,
        decoration: const BoxDecoration(
          color: darkGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }


  Widget _buildCategoryTitle() {
    return Center(
      child: Container(
        width: 190,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(9),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'K3',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }


  Widget _buildArticleTitle() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ArticlePage(
              category: 'k3',
              title: 'K3',
            ),
          ),
        );
      },
      child: const Row(
        children: [
          Text(
            'News & Articles',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: .9,
            ),
          ),
          SizedBox(width: 6),
          Icon(
            Icons.arrow_forward_ios,
            size: 10,
            color: darkGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildArticlePreview() {
    if (loadingArticles) {
      return _loadingBox();
    }

    if (articles.isEmpty) {
      return _emptyBox(
        'No K3 articles available',
      );
    }

    final previewArticles = articles.take(2).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0;
              i < previewArticles.length;
              i++) ...[
            _buildArticleCard(
              previewArticles[i],
            ),
            if (i != previewArticles.length - 1)
              const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }

  Widget _buildArticleCard(dynamic article) {
    final String title =
        article['title'] ?? 'Untitled Article';

    final String? image = article['image'];

    final String publishedAt =
        article['publishedAt'] ?? '';

    final String source =
        article['source']?['name'] ?? '';

    return GestureDetector(
      onTap: () {
        // nanti ke K3 Article Detail
      },
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(7),
              child: SizedBox(
                width: 65,
                height: 58,
                child: image != null &&
                        image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return _articleImageFallback();
                        },
                      )
                    : _articleImageFallback(),
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  if (source.isNotEmpty)
                    Text(
                      source,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 6.5,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 6),

            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatDate(publishedAt),
                style: const TextStyle(
                  fontSize: 5.5,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _articleImageFallback() {
    return Container(
      color: lightGreen,
      child: const Icon(
        Icons.article_outlined,
        color: darkGreen,
        size: 25,
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '';

    try {
      final parsed = DateTime.parse(date);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year}';
    } catch (_) {
      return '';
    }
  }

  Widget _buildWasteTypes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _wasteTypeCard(
          title: 'BATTERY\nWASTE',
          icon: Icons.battery_alert_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WasteGuidePage(
                  category: 'k3',
                  typeName: 'Battery Waste',
                ),
              ),
            );
          },
        ),

        _wasteTypeCard(
          title: 'ELECTRONIC\nWASTE',
          icon: Icons.devices_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WasteGuidePage(
                  category: 'k3',
                  typeName: 'Electronic Waste',
                ),
              ),
            );
          },
        ),

        _wasteTypeCard(
          title: 'LAMP /\nBULB',
          icon: Icons.lightbulb_outline,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WasteGuidePage(
                  category: 'k3',
                  typeName: 'Lamp / Bulb',
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _wasteTypeCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius:
              BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color:
                  Colors.white.withOpacity(.18),
            ),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight:
                    FontWeight.w700,
                letterSpacing: .4,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildNearestDropOff() {
    if (loadingDropOff) {
      return _loadingBox(
        height: 290,
      );
    }

    if (nearestDropOffs.isEmpty) {
      return _emptyBox(
        'No nearby drop-off found',
      );
    }

    return Container(
      height: 290,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius:
            BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics:
            const BouncingScrollPhysics(),
        itemCount:
            nearestDropOffs.length,
        separatorBuilder:
            (_, __) =>
                const SizedBox(
          height: 10,
        ),
        itemBuilder:
            (context, index) {
          return _buildDropOffCard(
            nearestDropOffs[index],
          );
        },
      ),
    );
  }

  Widget _buildDropOffCard(
    dynamic place,
  ) {
    final String name =
        place['displayName']?['text'] ??
            'Unknown Drop-Off';

    final String address =
        place['formattedAddress'] ??
            'Address unavailable';

    final double? rating =
        place['rating'] != null
            ? (place['rating'] as num)
                .toDouble()
            : null;

    final double? lat =
        place['location']?['latitude'] !=
                null
            ? (place['location']
                    ['latitude'] as num)
                .toDouble()
            : null;

    final double? lng =
        place['location']?['longitude'] !=
                null
            ? (place['location']
                    ['longitude'] as num)
                .toDouble()
            : null;

    String distanceText = '';

    if (currentPosition != null &&
        lat != null &&
        lng != null) {
      final meters =
          Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        lat,
        lng,
      );

      distanceText =
          '${(meters / 1000).toStringAsFixed(2)} km from here';
    }

    final photos = place['photos'];

    String? photoUrl;

    if (photos != null &&
        photos is List &&
        photos.isNotEmpty &&
        photos[0]['name'] != null) {
      final photoName =
          Uri.encodeComponent(
        photos[0]['name'],
      );

      photoUrl =
          'http://10.0.2.2/eltrack_recycling/DropOffAPI/dropoffPhoto.php?name=$photoName';
    }

    return Container(
      height: 94,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(7),
            child: SizedBox(
              width: 82,
              height: 75,
              child: photoUrl != null
                  ? Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _dropOffFallback();
                      },
                    )
                  : _dropOffFallback(),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          fontSize: 10,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    if (rating != null)
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration:
                            BoxDecoration(
                          color: darkGreen,
                          borderRadius:
                              BorderRadius
                                  .circular(9),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color:
                                  Colors.white,
                              size: 8,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(
                              rating
                                  .toStringAsFixed(
                                1,
                              ),
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 5),

                if (distanceText.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 9,
                        color: darkGreen,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        distanceText,
                        style:
                            const TextStyle(
                          fontSize: 6.5,
                        ),
                      ),
                    ],
                  ),

                const Spacer(),

                Text(
                  address,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 6,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropOffFallback() {
    return Container(
      color: lightGreen,
      child: const Icon(
        Icons.recycling,
        color: darkGreen,
        size: 28,
      ),
    );
  }


  Widget _loadingBox({
    double height = 160,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _emptyBox(String text) {
    return Container(
      width: double.infinity,
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }



  Widget _buildBottomNavigation() {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.home_rounded,
            color: darkGreen,
            size: 22,
          ),
          Icon(
            Icons.center_focus_weak,
            color: darkGreen,
            size: 22,
          ),
          Icon(
            Icons.storefront_outlined,
            color: darkGreen,
            size: 22,
          ),
          Icon(
            Icons.person,
            color: darkGreen,
            size: 22,
          ),
        ],
      ),
    );
  }
}