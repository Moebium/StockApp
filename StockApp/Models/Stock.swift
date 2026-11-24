//
//  Stock.swift
//  StockApp
//
//  Model: merepresentasikan satu data saham.
//

import Foundation

struct Stock: Identifiable, Codable {
    let id: UUID
    let symbol: String
    let companyName: String
    var currentPrice: Double
    var previousClose: Double

    init(
        id: UUID = UUID(),
        symbol: String,
        companyName: String,
        currentPrice: Double,
        previousClose: Double
    ) {
        self.id = id
        self.symbol = symbol
        self.companyName = companyName
        self.currentPrice = currentPrice
        self.previousClose = previousClose
    }

    // Computed property: perubahan harga dalam persen
    var changePercent: Double {
        guard previousClose != 0 else { return 0 }
        return ((currentPrice - previousClose) / previousClose) * 100
    }

    var isGaining: Bool {
        return currentPrice >= previousClose
    }
    
    func formattedChangePercent() -> String {
        let formattedNumber = String(format: "%.2f", changePercent)
        let profit: String = "\(formattedNumber)%"
        
        if changePercent >= 0 {
            return "+" + profit
        } else {
            return profit
        }
    }
}

// Extension terpisah untuk mock/testing data
extension Stock {
    static func mockList() -> [Stock] {
        return [
            Stock(symbol: "AAPL", companyName: "Apple Inc.", currentPrice: 191.20, previousClose: 188.50),
            Stock(symbol: "TSLA", companyName: "Tesla Inc.", currentPrice: 245.10, previousClose: 250.00),
            Stock(symbol: "GOOGL", companyName: "Alphabet Inc.", currentPrice: 138.75, previousClose: 137.90)
        ]
    }
}

/*
struct HpPoco {
    var seri: String
    var prosesor: String
    var harga: Double
    
    init(
        seri: String,
        prosesor: String,
        harga: Double
    ) {
        self.seri = seri
        self.prosesor = prosesor
        self.harga = harga
    }
}
let hpKu = HpPoco(seri: "Poco F7", prosesor: "Snapdragon 870", harga: 4700000)
*/
/*
func cekStok(jumlah: Int?) {
    guard let bukaJumlah = jumlah else {
        print("Stok tidak diketahui")
        return
    }
    if bukaJumlah < 1 {
        print("Stok habis")
    } else if bukaJumlah >= 10 {
        print("Stok aman")
    } else {print("Stok menipis,segera restock")
    }
}

cekStok(jumlah: nil)
cekStok(jumlah: 0)
cekStok(jumlah: 5)
cekStok(jumlah: 15)
*/


/*
 ---------------------------------------------------
struct Kontak {
    var email: String
}

struct Karyawan {
    var nama: String
    var kontak: Kontak?
}

let karyawan1 = Karyawan(nama: "Aji", kontak: Kontak(email: "apapun@gmail.com"))
let karyawan2 = Karyawan(nama: "Arya", kontak: nil)

func tampilkanEmail(karyawan: Karyawan) {
    //versi satu
    print("Email \(karyawan.nama): \(karyawan.kontak?.email ?? "Email belum diisi")")
 
    // dipakai salah satu
    //versi dua
    let emailFinal = karyawan.kontak?.email ?? "Email belum di isi"
    print("Email \(karyawan.nama): \(emailFinal)")
    }
tampilkanEmail(karyawan: karyawan1)
tampilkanEmail(karyawan: karyawan2)
 ------------------------------------------------------
 */

/*
------------------------------------------------------
// perbedaan if let dan guard let
// if let scopenya hanya sampai kurung kurawal akhir if let nya
func testIf(angka: Int?) {
    if let aman = angka {
        print("di dalam blok: \(aman)")
    } // ini kurung kurawal akhir if let jadi aman di bawah nya tidak bisa di pakai karna aman harusnya ada di dalam if let
    print("diluar blok: \(aman)") //-> ini tidak bisa atau di luar jangkauan acope
}

func testGuard(angka: Int?) {
    //sedangkan guard scopeya mencakup seluruh scope function meskipun sudah setelah {} tetap bisa di akses
    guard let aman = angka else {return} // sudah berakhir
    print("di luar guard: \(aman)")// tetap bisa akses
}
------------------------------------------------------
*/
/*
 -----------------------------------------------------
// pertanyaan b nomer 1
var nama: String?

//print(nama!)

if let namaKu = nama {
    print("namaku: \(namaKu)")
} else {
    print("belum ada nama")
}

print(nama ?? "tanpa nama")

// pertanyaan B nomer 2
func sapa(nama: String?) {
    guard let panggilNama = nama else {
        print("Nama kosong")
        return
    }
    print("Halo, \(panggilNama)")
}
sapa(nama: "Aji")
sapa(nama: nil)

//pertanyaan B no.3
struct Penulis {
    var nama: String
}

struct Buku {
    var judul: String
    var penulis: Penulis?
}

let buku1 = Buku(judul: "Saham", penulis: Penulis(nama: "Alfin"))
let buku2 = Buku(judul: "Crypto", penulis: nil)

func infoBuku(buku: Buku) {
    print("Buku \(buku.judul), penulis: \(buku.penulis?.nama ?? "Anonim")")
}
infoBuku(buku: buku1)
infoBuku(buku: buku2)
 -------------------------------------------------------
*/

/*
 
 -------------------------------------------------------
struct Alamat {
    var kota: String
}

struct Pelanggan {
    var nama: String
    var umur: Int?
    var alamat: Alamat?
}
let pelangganA = Pelanggan(nama: "Aji", umur: nil, alamat: Alamat(kota: "Jepara"))
let pelangganB = Pelanggan(nama: "Han", umur: 15, alamat: Alamat(kota: "Solo"))
let pelangganC = Pelanggan(nama: "Arya", umur: 30, alamat: nil)

func prosesPelanggan(pelanggan: Pelanggan) {
    guard let umurAman = pelanggan.umur else {
        print("Umur \(pelanggan.nama) belum diketahui")
        return
    }
    if umurAman < 17 {
        print("\(pelanggan.nama) belum boleh mendaftar")
        return
    }
    print("\(pelanggan.nama) dari \(pelanggan.alamat?.kota ?? "kota tidak di ketahui"), umur \(umurAman)")
}
prosesPelanggan(pelanggan: pelangganA)
prosesPelanggan(pelanggan: pelangganB)
prosesPelanggan(pelanggan: pelangganC)
*/

func getUserInfo() -> (name: String, isPremium: Bool) {
    return ("Raihan", true)
}

let info = getUserInfo()
print(info.name)
print(info.isPremium)
print(info.0)
print(info.1)

func getSahamInfo() -> (nama:String, harga: Double, tersedia: Bool) {
    return ("BBCA", 500000, true)
}

let infoSaham = getSahamInfo()
print(infoSaham.nama)
print(infoSaham.harga)
print(infoSaham.tersedia)

func tampilkanInfoSaham(info: (nama: String, harga: Double, tersedia: Bool)) {
    print("Saham \(info.nama) harganya Rp\(info.harga), tersedia: \(info.tersedia)")
}

tampilkanInfoSaham(info: getSahamInfo())

//------------------------------
func cekDataSaham(harga: Double?, nama: String) -> (status: String, hargaAkhir: Double)? {
    guard let bukaHarga = harga else {
        return nil
    }
    if bukaHarga < 500 {
        return (status: "Harga terlalu rendah", hargaAkhir: bukaHarga)
    } else {
        return (status: "harga normal", hargaAkhir: bukaHarga)
    }
}

if let hasil = cekDataSaham(harga: nil, nama: "BBCA") {
    print("\(hasil.status): \(hasil.hargaAkhir)")
} else {
    print("Data BBCA tidak tersedia")
}

if let hasil = cekDataSaham(harga: 300, nama: "TLKM") {
    print("\(hasil.status): \(hasil.hargaAkhir)")
} else {
    print("Data TLKM tidak tersedia")
}

if let hasil = cekDataSaham(harga: 5000, nama: "ASII") {
    print("\(hasil.status): \(hasil.hargaAkhir)")
} else {
    print("Data ASII tidak tersedia")
}


struct Baterai {
    var kapasitas: Int
}

struct Hp {
    var brand: String
    var baterai: Baterai?   // <- ini yang bikin rangkaian ?. masuk akal
}

let hpku = Hp(brand: "Poco", beterai:Baterai(kapasitas: 5000))

let hpTanpaBaterai = Hp(brand: "Entahbrand", baterai: nil)

print("Aku punya Hp dari brand \(hpku.brand), dengan kapasitas \(hpku.baterai?.kapasitas ?? 0)")

print("Aku punya Hp dari brand \(hpTanpaBaterai.brand), dengan kapasitas \(hpTanpaBaterai.baterai?.kapasitas ?? 0)")
//-------------------------------
struct Magazine {
    var peluru: Int
}

struct Senjata {
    var nama: String
    var magazine: Magazine?
}

let senjataA = Senjata(nama: "AK-47", magazine: Magazine(peluru: 0))
let senjataB = Senjata(nama: "AK-47", magazine: nil)
let senjataC = Senjata(nama: "AK-47", magazine: Magazine(peluru: 15))


func cekSenjata(senjata: Senjata) {
    guard let magazineAman = senjata.magazine else {
        print("Tidak ada Magazine")
        return
    }
    if magazineAman.peluru == 0 {
        print("Magazine Habis")
    } else {
        print("Peluru tersisa: \(magazineAman.peluru)")
    }
}

cekSenjata(senjata: senjataA)
cekSenjata(senjata: senjataB)
cekSenjata(senjata: senjataC)
