import 'package:flutter/material.dart';
/**
 * menampilkan gamabr dari URL internet
 * 1. sedang dimuat: menampilkna indikator loading
 * 2. gagal dimuat: menampilkan ikon pengganti
 */
class FlowerNetwokImage extends StatelessWidget {
  const new({
    super.key,
    required this.imageUrl,
    required this.fallbackIcon,
    required this.fallbackColor,
    required this.fit
  });

  final String imageUrl;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      // loading indicator, yang akan dijalankan terus-menerus oleh Flutter, selama gambarnya masih proses download dari internet
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _Placeholder(
          color: fallbackColor,
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: fallbackColor,
              // kalau flutter tau ukuran total file, maka akan menghitung proses download gambar
              // kalau flutter tidak tau ukuran total file, maka akan mengembalikan null
              value: progress.expectedTotalBytes != null ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes! : null,
            ),
          ),
        );
      },
      // errorBuilder, yang akan dipanggil kalau proses DI ATAS (laoding gambar) GATOT
      errorBuilder: (context, error, stackTrace) {
        return _Placeholder(
          color: fallbackColor,
          child: Icon(fallbackIcon, size: 48, color: fallbackColor),
        );
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const new({required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withValues(alpha: 0.18),
      alignment: Alignment.center,
      child: child,
    );
  }
}