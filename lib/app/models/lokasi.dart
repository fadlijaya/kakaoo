class Kecamatan {
  final int id;
  final String kecamatan;

  Kecamatan({required this.id, required this.kecamatan});

  static List<Kecamatan> getKecamatan() {
    return <Kecamatan>[
      Kecamatan(id: 1, kecamatan: 'Kecamatan Bonto Bahari'),
      Kecamatan(id: 2, kecamatan: 'Kecamatan Bontotiro'),
      Kecamatan(id: 3, kecamatan: 'Kecamatan Bulukumpa'),
      Kecamatan(id: 4, kecamatan: 'Kecamatan Gantarang'),
      Kecamatan(id: 5, kecamatan: 'Kecamatan Herlang'),
      Kecamatan(id: 6, kecamatan: 'Kecamatan Kindang'),
      Kecamatan(id: 7, kecamatan: 'Kecamatan Kajang'),
      Kecamatan(id: 8, kecamatan: 'Kecamatan Rilau Ale'),
      Kecamatan(id: 9, kecamatan: 'Kecamatan Ujungloe'),
      Kecamatan(id: 10, kecamatan: 'Kecamatan Ujungbulu')
    ];
  }
}

class Kelurahan {
  final int id;
  final String kelurahan;

  Kelurahan({required this.id, required this.kelurahan});

  List<Kelurahan> listKelurahan1 = [
    Kelurahan(id: 1, kelurahan: 'Desa Ara'),
    Kelurahan(id: 2, kelurahan: 'Kelurahan Benjala'),
    Kelurahan(id: 3, kelurahan: 'Desa Bira'),
    Kelurahan(id: 4, kelurahan: 'Desa Darubiah'),
    Kelurahan(id: 5, kelurahan: 'Desa Lembanna'),
    Kelurahan(id: 6, kelurahan: 'Kelurahan Sapolohe'),
    Kelurahan(id: 7, kelurahan: 'Kelurahan Tanah Beru'),
    Kelurahan(id: 8, kelurahan: 'Kelurahan Tanah Lemo'),
  ];

  List<Kelurahan> listKelurahan2 = [
    Kelurahan(id: 1, kelurahan: 'Desa Batang'),
    Kelurahan(id: 2, kelurahan: 'Desa Bonto Barua'),
    Kelurahan(id: 3, kelurahan: 'Desa Bonto Bulaeng'),
    Kelurahan(id: 4, kelurahan: 'Desa Bonto Marannu'),
    Kelurahan(id: 5, kelurahan: 'Desa Bonto Tangnga'),
    Kelurahan(id: 6, kelurahan: 'Desa Buhung Bundang'),
    Kelurahan(id: 7, kelurahan: 'Desa Caramming'),
    Kelurahan(id: 8, kelurahan: 'Desa Dwi Tiro'),
    Kelurahan(id: 9, kelurahan: 'Kelurahan Ekatiro'),
    Kelurahan(id: 10, kelurahan: 'Desa Pakubalaho'),
    Kelurahan(id: 11, kelurahan: 'Desa Tamalanrea'),
    Kelurahan(id: 12, kelurahan: 'Desa Tritiro')
  ];

  List<Kelurahan> listKelurahan3 = [
    Kelurahan(id: 1, kelurahan: 'Desa Balang Pesoang'),
    Kelurahan(id: 2, kelurahan: 'Desa Balang Taroang'),
    Kelurahan(id: 3, kelurahan: 'Kelurahan Ballasaraja'),
    Kelurahan(id: 4, kelurahan: 'Desa Barugae'),
    Kelurahan(id: 5, kelurahan: 'Desa Batulohe'),
    Kelurahan(id: 6, kelurahan: 'Desa Bonto Bulaeng'),
    Kelurahan(id: 7, kelurahan: 'Desa Bonto Minasa'),
    Kelurahan(id: 8, kelurahan: 'Desa Bontomangiring'),
    Kelurahan(id: 9, kelurahan: 'Desa Bulo-Bulo'),
    Kelurahan(id: 10, kelurahan: 'Kelurahan Jawi - Jawi'),
    Kelurahan(id: 11, kelurahan: 'Desa Jojjolo'),
    Kelurahan(id: 12, kelurahan: 'Desa Kambuno'),
    Kelurahan(id: 13, kelurahan: 'Desa Salassae'),
    Kelurahan(id: 14, kelurahan: 'Desa Sapo Bonto'),
    Kelurahan(id: 15, kelurahan: 'Kelurahan Tanete'),
    Kelurahan(id: 16, kelurahan: 'Desa Tibona'),
  ];

  List<Kelurahan> listKelurahan4 = [
    Kelurahan(id: 1, kelurahan: 'Desa Barombong'),
    Kelurahan(id: 2, kelurahan: 'Desa Benteng Gatareng'),
    Kelurahan(id: 3, kelurahan: 'Desa Benteng Malewang'),
    Kelurahan(id: 4, kelurahan: 'Desa Bialo'),
    Kelurahan(id: 5, kelurahan: 'Desa Bonto Macinna'),
    Kelurahan(id: 6, kelurahan: 'Desa Bonto Sunggu'),
    Kelurahan(id: 7, kelurahan: 'Desa Bontomasila'),
    Kelurahan(id: 8, kelurahan: 'Desa Bontonyeleng'),
    Kelurahan(id: 9, kelurahan: 'Desa Bontoraja'),
    Kelurahan(id: 10, kelurahan: 'Desa Bukit Harapan'),
    Kelurahan(id: 11, kelurahan: 'Desa Bukit Tinggi'),
    Kelurahan(id: 12, kelurahan: 'Desa Dampang'),
    Kelurahan(id: 13, kelurahan: 'Desa Gattareng'),
    Kelurahan(id: 14, kelurahan: 'Kelurahan Jalanjang'),
    Kelurahan(id: 15, kelurahan: 'Kelurahan Mariorennu'),
    Kelurahan(id: 16, kelurahan: 'Kelurahan Mattekko'),
    Kelurahan(id: 17, kelurahan: 'Desa Padang'),
    Kelurahan(id: 18, kelurahan: 'Desa Paenre Lompoe'),
    Kelurahan(id: 19, kelurahan: 'Desa Palambarae'),
    Kelurahan(id: 20, kelurahan: 'Desa Polewali')
  ];

  List<Kelurahan> listKelurahan5 = [
    Kelurahan(id: 1, kelurahan: 'Kelurahan Bonto Kamase'),
    Kelurahan(id: 2, kelurahan: 'Desa Borong'),
    Kelurahan(id: 3, kelurahan: 'Desa Gunturu'),
    Kelurahan(id: 4, kelurahan: 'Desa Karassing'),
    Kelurahan(id: 5, kelurahan: 'Desa Pataro'),
    Kelurahan(id: 6, kelurahan: 'Desa Singa'),
    Kelurahan(id: 7, kelurahan: 'Kelurahan Tanuntung'),
    Kelurahan(id: 8, kelurahan: 'Desa Tugondeng')
  ];

  List<Kelurahan> listKelurahan6 = [
    Kelurahan(id: 1, kelurahan: 'Desa Batunilamung'),
    Kelurahan(id: 2, kelurahan: 'Desa Bonto Baji'),
    Kelurahan(id: 3, kelurahan: 'Desa Bonto Biraeng'),
    Kelurahan(id: 4, kelurahan: 'Desa Bontorannu'),
    Kelurahan(id: 5, kelurahan: 'Kelurahan Laikang'),
    Kelurahan(id: 6, kelurahan: 'Desa Lembang'),
    Kelurahan(id: 7, kelurahan: 'Desa Lembanglohe'),
    Kelurahan(id: 8, kelurahan: 'Desa Lembanna'),
    Kelurahan(id: 9, kelurahan: 'Desa Lolisang'),
    Kelurahan(id: 10, kelurahan: 'Desa Malleleng'),
    Kelurahan(id: 11, kelurahan: 'Desa Mattoanging'),
    Kelurahan(id: 12, kelurahan: 'Desa Pantama'),
    Kelurahan(id: 13, kelurahan: 'Desa Pattiroang'),
    Kelurahan(id: 14, kelurahan: 'Desa Possi Tanah'),
    Kelurahan(id: 15, kelurahan: 'Desa Sangkala'),
    Kelurahan(id: 16, kelurahan: 'Desa Sapanang'),
    Kelurahan(id: 17, kelurahan: 'Desa Tambangan'),
    Kelurahan(id: 18, kelurahan: 'Kelurahan Tanah Jaya'),
    Kelurahan(id: 19, kelurahan: 'Desa Tanah Towa'),
  ];

  List<Kelurahan> listKelurahan7 = [
    Kelurahan(id: 1, kelurahan: 'Desa Anrihua'),
    Kelurahan(id: 2, kelurahan: 'Desa Balibo'),
    Kelurahan(id: 3, kelurahan: 'Desa Benteng Palioi'),
    Kelurahan(id: 4, kelurahan: 'Kelurahan Borong Rappoa'),
    Kelurahan(id: 5, kelurahan: 'Desa Garuntungan'),
    Kelurahan(id: 6, kelurahan: 'Desa Kindang'),
    Kelurahan(id: 7, kelurahan: 'Desa Mattirowalie'),
    Kelurahan(id: 8, kelurahan: 'Desa Oro Gading'),
    Kelurahan(id: 9, kelurahan: 'Desa Tamaona')
  ];

  List<Kelurahan> listKelurahan8 = [
    Kelurahan(id: 1, kelurahan: 'Desa Anrang'),
    Kelurahan(id: 2, kelurahan: 'Desa Bajiminasa'),
    Kelurahan(id: 3, kelurahan: 'Desa Batukaropa'),
    Kelurahan(id: 4, kelurahan: 'Desa Bonto Matene'),
    Kelurahan(id: 5, kelurahan: 'Desa Bontobangun'),
    Kelurahan(id: 6, kelurahan: 'Desa Bontoharu'),
    Kelurahan(id: 7, kelurahan: 'Desa Bontolohe'),
    Kelurahan(id: 8, kelurahan: 'Desa Bontomanai'),
    Kelurahan(id: 9, kelurahan: 'Desa Bulolohe'),
    Kelurahan(id: 10, kelurahan: 'Desa Karama'),
    Kelurahan(id: 11, kelurahan: 'Kelurahan Palampang'),
    Kelurahan(id: 12, kelurahan: 'Desa Swatani'),
    Kelurahan(id: 13, kelurahan: 'Desa Tanah Harapan'),
  ];

  List<Kelurahan> listKelurahan9 = [
    Kelurahan(id: 1, kelurahan: 'Kelurahan Bentengnge'),
    Kelurahan(id: 2, kelurahan: 'Kelurahan Ela-Ela'),
    Kelurahan(id: 3, kelurahan: 'Kelurahan Kasimpureng'),
    Kelurahan(id: 4, kelurahan: 'Kelurahan L O K A (Loka)'),
    Kelurahan(id: 5, kelurahan: 'Kelurahan Terang-Terang'),
    Kelurahan(id: 6, kelurahan: 'Kelurahan Tanah Kongkong'),
    Kelurahan(id: 7, kelurahan: 'Kelurahan Bintarore'),
    Kelurahan(id: 8, kelurahan: 'Kelurahan Caile'),
    Kelurahan(id: 9, kelurahan: 'Kelurahan Kalumeme')
  ];

  List<Kelurahan> listKelurahan10 = [
    Kelurahan(id: 1, kelurahan: 'Desa Balleanging (Balleangin)'),
    Kelurahan(id: 2, kelurahan: 'Desa Balong'),
    Kelurahan(id: 3, kelurahan: 'Desa Bijawang'),
    Kelurahan(id: 4, kelurahan: 'Kelurahan Dannuang'),
    Kelurahan(id: 5, kelurahan: 'Desa Garanta'),
    Kelurahan(id: 6, kelurahan: 'Desa Lonrong'),
    Kelurahan(id: 7, kelurahan: 'Desa Manjalling'),
    Kelurahan(id: 8, kelurahan: 'Desa Manyampa'),
    Kelurahan(id: 9, kelurahan: 'Desa Padang Loang'),
    Kelurahan(id: 10, kelurahan: 'Desa Salemba'),
    Kelurahan(id: 11, kelurahan: 'Desa Seppang'),
    Kelurahan(id: 12, kelurahan: 'Desa Tamatto')
  ];
}
