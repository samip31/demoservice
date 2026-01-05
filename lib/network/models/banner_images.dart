class BannerImage{
  List<String> topBanners;
  List<String> bottomBanners;

  BannerImage({
    required this.topBanners,
    required this.bottomBanners,
  });

  factory BannerImage.fromJson(Map<String, dynamic>json){
    return BannerImage(
        topBanners: json['topBanner'] != null ? List<String>.from(json['topBanners'].map((e)=>e)): [],
        bottomBanners: json['bottomBanner'] != null ? List<String>.from(json['bottomBanners'].map((e)=>e)): [],
    );
  }
}

