import 'dart:async';

import 'package:flowee_app/models/promo_banner.dart';
import 'package:flowee_app/widgets/banner_slide.dart';
import 'package:flowee_app/widgets/carousel_dots.dart';
import 'package:flutter/material.dart';

// carousel banner, akan bergeser otomatis setiap beberapa detik, untuk handling timer seperti ini, kita butuh peran StatefulWidget untuk melakukan perubahan widget pada layar 
class BannerCarousel extends StatefulWidget {
  const new({super.key, required this.banners});

  final List<PromoBanner> banners;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  /**
   * PageController --> mengatur slide mana yang sedang tampil di PageView
   */

  late final PageController _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    // Timer.periodic --> menjalankan fungsi didalamnya secara BERULANG-ULANG
    _timer = Timer.periodic(Duration(seconds: 4), (_) {
      if (!mounted || widget.banners.isEmpty) return;
      final next = (_page + 1) % widget.banners.length;
      _controller.animateToPage(
        next,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic
      );
    });
  }

  @override
  /**
   * Timer HARUS dicancel saat widget dihancurkan (saat tidak tampil di layar). Kalau lupa,
   * timer akan terus mencoba jalan di latar belakang (background), walau carouselnya sudah 
   * tidak muncul di layar, ini salah satu penyebab umum memory leak di Fllutter
   */

  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 168,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            /**
             * dipanggil juga saat pengguna SWIPE manual, bukan cuma saat
             * digeser otomatis oleh Timer, supaya titik indikator di bawah selalu sinkron dengan slide yang benar-benar tampil.
             */
            onPageChanged: (index) => setState(() => _page = index),
            itemBuilder: (context, index) => BannerSlide(banner: widget.banners[index]),
          ),
        ),
        SizedBox(height: 10),
        CarouselDots(
          count: widget.banners.length,
          activeIndex: _page,
          activeColor: widget.banners[_page].gradientColors.first,
        )
      ],
    );
  }
}