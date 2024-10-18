import 'dart:io'; // Mengimpor library untuk input/output
import 'dart:math'; // Mengimpor library untuk fungsi matematika

// Kelas untuk node pada daftar terhubung
class PointNode {
  String name; // Nama dari node
  PointNode? nextPoint; // Referensi ke node berikutnya

  // Konstruktor untuk inisialisasi node
  PointNode(this.name);
}

// Kelas untuk daftar terhubung yang menyimpan poin-poin
class PointList {
  PointNode? firstPoint; // Node pertama dari daftar

  // Menambahkan poin baru di akhir daftar
  void addPoint(String name) {
    if (firstPoint == null) {
      // Jika daftar kosong
      firstPoint = PointNode(name); // Inisialisasi node pertama
    } else {
      PointNode current = firstPoint!; // Mulai dari node pertama
      // Menelusuri hingga ke node terakhir
      while (current.nextPoint != null) {
        current = current.nextPoint!;
      }
      // Menambahkan node baru di akhir
      current.nextPoint = PointNode(name);
    }
  }

  // Menampilkan semua poin dalam daftar
  void showPoints() {
    PointNode? current = firstPoint; // Memulai dari node pertama
    while (current != null) {
      // Selama ada node yang tersisa
      print(current.name); // Menampilkan nama node
      current = current.nextPoint; // Beralih ke node berikutnya
    }
  }
}

// Kelas untuk merepresentasikan graf dan menyelesaikan Traveling Salesman Problem (TSP)
class DistanceGraph {
  List<List<int>> distanceMatrix; // Matriks jarak antar poin
  List<String> pointNames; // Daftar nama poin

  // Konstruktor untuk inisialisasi graf dengan matriks jarak dan nama poin
  DistanceGraph(this.distanceMatrix, this.pointNames);

  // Mendapatkan jarak antara dua poin yang terhubung
  int findDistance(String start, String destination) {
    int startIdx = pointNames.indexOf(start); // Indeks poin awal
    int destIdx = pointNames.indexOf(destination); // Indeks poin tujuan

    // Jika salah satu poin tidak ditemukan
    if (startIdx == -1 || destIdx == -1) {
      print('Menghubungkan poin tidak ditemukan.'); // Menampilkan pesan error
      return -1; // Mengembalikan -1 sebagai indikator error
    }

    return distanceMatrix[startIdx][destIdx]; // Mengembalikan jarak antar poin
  }

  // Algoritma rekursif untuk menyelesaikan TSP
  int solveTSP(List<int> route, int position, int visited, int count,
      int totalDistance, int shortestDistance) {
    // Jika semua poin sudah dikunjungi dan ada jalur kembali ke awal
    if (count == distanceMatrix.length && distanceMatrix[position][0] > 0) {
      return min(
          shortestDistance,
          totalDistance +
              distanceMatrix[position][0]); // Mengembalikan jarak minimum
    }

    // Menelusuri setiap titik untuk mencari rute optimal
    for (int i = 0; i < distanceMatrix.length; i++) {
      // Jika titik belum dikunjungi dan ada jarak
      if ((visited & (1 << i)) == 0 && distanceMatrix[position][i] > 0) {
        visited |= (1 << i); // Menandai titik sebagai dikunjungi
        route.add(i); // Menambahkan titik ke rute
        // Memanggil fungsi secara rekursif untuk melanjutkan pencarian
        shortestDistance = solveTSP(route, i, visited, count + 1,
            totalDistance + distanceMatrix[position][i], shortestDistance);
        visited &= ~(1 << i); // Menghapus tanda kunjungan
        route.removeLast(); // Menghapus titik terakhir dari rute
      }
    }
    return shortestDistance; // Mengembalikan jarak terpendek yang ditemukan
  }

  // Memulai proses pencarian rute optimal
  void findOptimalRoute() {
    List<int> route = [0]; // Rute awal dimulai dari titik pertama
    int visited = 1; // Menandai titik pertama telah dikunjungi
    int shortestDistance =
        solveTSP(route, 0, visited, 1, 0, 100000000); // Mencari rute optimal
    print("Jarak minimum TSP: $shortestDistance"); // Menampilkan jarak minimum
  }
}

void main() {
  // Membuat koleksi poin menggunakan PointList
  PointList pointCollection = PointList();
  pointCollection.addPoint('A'); // Menambahkan titik A
  pointCollection.addPoint('B'); // Menambahkan titik B
  pointCollection.addPoint('C'); // Menambahkan titik C
  pointCollection.addPoint('D'); // Menambahkan titik D
  pointCollection.addPoint('E'); // Menambahkan titik E

  // Menampilkan daftar poin
  print('Poin:');
  pointCollection.showPoints();

  // Matriks jarak antar poin
  List<List<int>> distances = [
    [0, 8, 3, 4, 10], // Jarak dari A ke B, C, D, E
    [8, 0, 5, 2, 7], // Jarak dari B ke A, C, D, E
    [3, 5, 0, 1, 6], // Jarak dari C ke A, B, D, E
    [4, 2, 1, 0, 3], // Jarak dari D ke A, B, C, E
    [10, 7, 6, 3, 0] // Jarak dari E ke A, B, C, D
  ];

  // Daftar nama poin
  List<String> points = ['A', 'B', 'C', 'D', 'E'];

  // Membuat graf berdasarkan matriks jarak dan nama poin
  DistanceGraph pointGraph = DistanceGraph(distances, points);

  // Menerima input pengguna untuk mencari jarak antara dua poin
  while (true) {
    print(
        '\nMasukkan poin yang mau disambung (cth: A B), ketik exit untuk keluar:');
    String? userInput = stdin.readLineSync(); // Menerima input dari pengguna

    // Memeriksa jika pengguna ingin keluar
    if (userInput == null || userInput.toLowerCase() == 'exit') {
      print('Terima Kasih'); // Mengucapkan terima kasih
      break; // Keluar dari loop
    }

    List<String> selectedPoints =
        userInput.split(' '); // Memisahkan input menjadi daftar poin
    // Memeriksa jika dua poin dimasukkan
    if (selectedPoints.length == 2) {
      String startPoint = selectedPoints[0]; // Poin awal
      String endPoint = selectedPoints[1]; // Poin tujuan

      int distance =
          pointGraph.findDistance(startPoint, endPoint); // Mencari jarak
      // Jika jarak ditemukan
      if (distance != -1) {
        print(
            'Jarak dari $startPoint ke $endPoint adalah $distance.'); // Menampilkan jarak
      }
    } else {
      print('Error, input ulang'); // Pesan kesalahan jika input tidak valid
    }
  }
}
