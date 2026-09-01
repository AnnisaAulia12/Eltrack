import 'dart:ui';

import 'package:eltrack_mobile/features/home/pages/Categories/scanner/scannerPage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:eltrack_mobile/features/home/service/nearestDropoff_service.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/Organic/OrganicPage.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/NonOrganic/NonOrganicPage.dart';
import 'package:eltrack_mobile/features/home/pages/Categories/K3/K3Page.dart';


import 'package:eltrack_mobile/features/home/widgets/eltrackBottomNav.dart';

class Discover extends StatefulWidget {
  final int userId;
  final int points;

  const Discover({
    super.key,
    required this.userId,
    required this.points,
  });

  @override
  State<Discover> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<Discover> {
  static const Color primaryGreen = Color(0xFFA1BC98);
  static const Color darkGreen = Color(0xFF768973);
  static const Color lightGreen = Color(0xFFD4E3CF);

  bool locationReady = false;
  bool loadingLocation = false;
  bool loadingDropOff = false;

  Position? currentPosition;

  List<dynamic> nearestDropOffs = [];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }


  Future<void> _checkLocationPermission() async {
    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    final permission =
        await Geolocator.checkPermission();

    if (serviceEnabled &&
        (permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always)) {
      await _getCurrentLocation();
    }
  }

  Future<void> _activateLocation() async {
    setState(() {
      loadingLocation = true;
    });

    final serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();

      if (!mounted) return;

      setState(() {
        loadingLocation = false;
      });

      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();

      if (!mounted) return;

      setState(() {
        loadingLocation = false;
      });

      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      await _getCurrentLocation();
    } else {
      if (!mounted) return;

      setState(() {
        loadingLocation = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position =
          await Geolocator.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        currentPosition = position;
        locationReady = true;
        loadingLocation = false;
      });

      await _loadNearestDropOff(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      debugPrint('LOCATION ERROR: $e');

      if (!mounted) return;

      setState(() {
        loadingLocation = false;
      });
    }
  }


  Future<void> _loadNearestDropOff(
    double latitude,
    double longitude,
  ) async {
    try {
      setState(() {
        loadingDropOff = true;
      });

      final places =
          await nearestDropoff_service.getNearestDropOff(
        latitude: latitude,
        longitude: longitude,
      );

      if (!mounted) return;

      setState(() {
        nearestDropOffs = places;
        loadingDropOff = false;
      });
    } catch (e) {
      debugPrint('DROP OFF ERROR: $e');

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

      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      34,
                      34,
                      34,
                      30,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),

                        const SizedBox(height: 15),

                        _buildSearchBar(),

                        const SizedBox(height: 18),

                        _buildRecyclingLevel(),

                        const SizedBox(height: 27),

                        const Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.1,
                          ),
                        ),

                        const SizedBox(height: 14),

                        _buildCategories(),

                        const SizedBox(height: 36),

                        const Text(
                          'Nearest Drop-Off',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .8,
                          ),
                        ),

                        const SizedBox(height: 14),

                        _buildNearestDropOff(),

                        const SizedBox(height: 35),

                        const Text(
                          'Recent Information',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .8,
                          ),
                        ),

                        const SizedBox(height: 14),

                        _buildRecentInformation(),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),

                // bottom bar selalu ada
                EltrackBottomNav(
                  currentIndex: 0,

                  onHome: () {
                    // sudah di Home
                  },

                  onScanner: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => scannerPage(
                          userId: widget.userId,
                          points: widget.points,
                        ),
                      ),
                    );
                  },

                  onStore: () {
                    // nanti Store
                  },

                  onProfile: () {
                    // nanti Profile
                  },
                ),
              ],
            ),
          ),

          // popup location
          if (!locationReady)
            _buildLocationOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        const Text(
          'Discover',
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),

        const SizedBox(width: 15),

        Text(
          '${widget.points} pts',
          style: const TextStyle(
            fontSize: 17,
            color: darkGreen,
            fontWeight: FontWeight.w700,
          ),
        ),

        const Spacer(),

        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: primaryGreen,
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.person_outline,
            color: darkGreen,
            size: 18,
          ),
        ),
      ],
    );
  }


  Widget _buildSearchBar() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.fromLTRB(
            15,
            8,
            8,
            8,
          ),
          suffixIcon: Icon(
            Icons.search,
            color: darkGreen,
            size: 17,
          ),
        ),
      ),
    );
  }



  Widget _buildRecyclingLevel() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              15,
              9,
              15,
              8,
            ),
            child: Row(
              children: [
                const Text(
                  'Recycling Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: .9,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                    child:
                        const LinearProgressIndicator(
                      value: .70,
                      minHeight: 6,
                      backgroundColor:
                          Color(0xFFE4EBE1),
                      valueColor:
                          AlwaysStoppedAnimation(
                        darkGreen,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 7),

                const Text(
                  '70%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            height: 1,
            thickness: .3,
            color: Color.fromARGB(102, 29, 41, 26),
          ),

          const Padding(
            padding:
                EdgeInsets.fromLTRB(
              15,
              10,
              15,
              13,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Green Mission',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: .8,
                  ),
                ),

                SizedBox(height: 6),

                _MissionRow(
                  number: '1.',
                  text:
                      'Recycle 5 plastic bottles or cardboard boxes',
                  progress: '(1/3)',
                ),

                _MissionRow(
                  number: '2.',
                  text:
                      'Recycle 5 plastic bottles or cardboard boxes',
                  progress: '(1/3)',
                ),

                _MissionRow(
                  number: '3.',
                  text:
                      'Drop off 2 used batteries or broken cables',
                  progress: '(1/3)',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _categoryButton(
          'Organic',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrganicPage( userId: widget.userId, points: widget.points,),
              ),
            );
          },
        ),

        _categoryButton(
          'Non Organic',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NonOrganicPage( userId: widget.userId, points: widget.points,)
              ),
            );
          },
        ),

        _categoryButton(
          'K3',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => K3Page( userId: widget.userId, points: widget.points,),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _categoryButton(
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(9),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: darkGreen,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: .6,
          ),
        ),
      ),
    );
  }



  Widget _buildNearestDropOff() {
    if (!locationReady) {
      return const SizedBox(
        height: 285,
      );
    }

    if (loadingDropOff) {
      return Container(
        height: 285,
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (nearestDropOffs.isEmpty) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'No nearby drop-off found',
          ),
        ),
      );
    }

    // box tidak pindah page
    // scroll hanya di dalam box ini
    return Container(
      height: 290,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius:
            BorderRadius.circular(20),
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
          height: 11,
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

    final double? latitude =
        place['location']?['latitude'] !=
                null
            ? (place['location']
                    ['latitude'] as num)
                .toDouble()
            : null;

    final double? longitude =
        place['location']?['longitude'] !=
                null
            ? (place['location']
                    ['longitude'] as num)
                .toDouble()
            : null;

    String distanceText = '';

    if (currentPosition != null &&
        latitude != null &&
        longitude != null) {
      final distanceMeter =
          Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        latitude,
        longitude,
      );

      final distanceKm =
          distanceMeter / 1000;

      distanceText =
          '${distanceKm.toStringAsFixed(2)} km from here';
    }

    // PHOTO GOOGLE PLACES
    final photos = place['photos'];

    String? photoUrl;

    if (photos != null &&
        photos is List &&
        photos.isNotEmpty &&
        photos[0]['name'] != null) {
      final String photoName =
          Uri.encodeComponent(
        photos[0]['name'],
      );

      photoUrl =
          'http://10.0.2.2/eltrack_recycling/DropOffAPI/dropoffPhoto.php?name=$photoName';
    }

    return Container(
      height: 108,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // FOTO ASLI
          ClipRRect(
            borderRadius:
                BorderRadius.circular(8),
            child: SizedBox(
              width: 90,
              height: 86,
              child: photoUrl != null
                  ? Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _photoFallback();
                      },
                    )
                  : _photoFallback(),
            ),
          ),

          const SizedBox(width: 12),

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
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          letterSpacing: .3,
                        ),
                      ),
                    ),

                    // RATING
                    if (rating != null)
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration:
                            BoxDecoration(
                          color: darkGreen,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            10,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color:
                                  Colors.white,
                              size: 9,
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
                                fontSize: 7,
                                fontWeight:
                                    FontWeight
                                        .w600,
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
                        size: 11,
                        color: darkGreen,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        distanceText,
                        style:
                            const TextStyle(
                          fontSize: 8,
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
                    fontSize: 6.5,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration:
                      BoxDecoration(
                    color: darkGreen,
                    borderRadius:
                        BorderRadius.circular(
                      8,
                    ),
                  ),
                  child: const Text(
                    'Waste Drop-Off',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoFallback() {
    return Container(
      color:
          const Color(0xFFE5EEE2),
      child: const Icon(
        Icons.recycling,
        color: darkGreen,
        size: 31,
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
            blurRadius: 4,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(
            Icons.home_rounded,
            active: true,
          ),

          _navIcon(
            Icons.center_focus_weak,
          ),

          _navIcon(
            Icons.storefront_outlined,
          ),

          _navIcon(
            Icons.person,
          ),
        ],
      ),
    );
  }

  Widget _navIcon(
    IconData icon, {
    bool active = false,
  }) {
    if (active) {
      return Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: darkGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 21,
        ),
      );
    }

    return Icon(
      icon,
      color: darkGreen,
      size: 22,
    );
  }


  Widget _buildLocationOverlay() {
    return Positioned.fill(
      child: Stack(
        children: [
          // blur bagian halaman
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 64,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.white
                    .withOpacity(.15),
              ),
            ),
          ),

          // popup hijau
          Positioned(
            left: 0,
            right: 0,
            bottom: 64,
            child: Container(
              padding:
                  const EdgeInsets.fromLTRB(
                25,
                20,
                20,
                15,
              ),
              decoration:
                  const BoxDecoration(
                color: primaryGreen,
                borderRadius:
                    BorderRadius.vertical(
                  top:
                      Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize:
                    MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enable location access',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight:
                          FontWeight.w700,
                      letterSpacing: .8,
                    ),
                  ),

                  const SizedBox(height: 3),

                  const SizedBox(
                    width: 290,
                    child: Text(
                      'to determine your current position and show nearby waste disposal points.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7.5,
                        fontWeight:
                            FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Align(
                    alignment:
                        Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed:
                          loadingLocation
                              ? null
                              : _activateLocation,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white,
                        foregroundColor:
                            darkGreen,
                        elevation: 3,
                        minimumSize:
                            const Size(
                          115,
                          32,
                        ),
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 14,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),
                        ),
                      ),
                      child:
                          loadingLocation
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                  ),
                                )
                              : const Text(
                                  'Activate Location',
                                  style:
                                      TextStyle(
                                    fontSize:
                                        8.5,
                                    fontWeight:
                                        FontWeight
                                            .w700,
                                    letterSpacing:
                                        .4,
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRecentInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        height: 70,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: const Text(
          'Belum ada informasi terbaru',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}


class _MissionRow extends StatelessWidget {
  final String number;
  final String text;
  final String progress;

  const _MissionRow({
    required this.number,
    required this.text,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 4,
      ),
      child: Row(
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7.5,
            ),
          ),

          const SizedBox(width: 3),

          Expanded(
            child: Text(
              text,
              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 7.5,
              ),
            ),
          ),

          Text(
            progress,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 7.5,
            ),
          ),
        ],
      ),
    );
  }
}

