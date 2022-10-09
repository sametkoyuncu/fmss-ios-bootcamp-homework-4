# Travel APP
FMSS Bilişim & Patika.dev iOS Bootcamp'i Bitirme Projesi - Travel App

Kullanıcıların uçuş, otel ve gezi yazılarını görüntüleyebildiği. Uçuşlar ve oteller arasında arama yapabildiği. İstediği uçuş, otel veya yazıyı favorilerine ekleyebildiği uygulama. 

> API'lerde istek sınır olduğu için veriler yerel JSON dosyalarından çekildi. Flights için model dosyasında 2 farklı method hazırladım. İlki JSON dosyasından veri çekerken, ikincisi `Alamofire` ile API'den veri çekiyor. Uygulama varsayılan olarak ilk methodu kullanıyor. Eğer ikinci methodu kullanmak isterseniz `ListModule > VMs > FlightListViewModel.swift` dosyasında `didViewLoad` metodu içindeki kodları aşağıdaki gibi düzenleyin.
```swift
func didViewLoad() {
        //model.fetchData()
        // MARK: - api'den veri çekmek için yukarıdaki satırı kapatıp
        //         alttaki satırı aktif hale getirin
        model.fetchDataUsingAlamofire()
}
```
> API'ın aylık 100 istek sınırı var. Eğer sınır dolduysa sonuçlar gelmeyecektir. Bunu düzeltmek için `ListModule > Models > FlightListModel.swift` dosyasında 21. satırdaki yedek API Key'i kullanabilirsiniz.

## Kullanılanlar
- Table View (Custom TableViewCell using .xib file)
- Collection View (Custom CollectionViewCell using .xib file)
- TabBar
- Navigation Controller
- Delegation Pattern
- Interfaces
- MVVM
- CoreData
- Alamofire
- KingFisher

## Ekran Görüntüleri
<img src="https://github.com/sametkoyuncu/fmss-ios-bootcamp-homework-4/blob/development/screenshots/hm4-ss1.png" alt="screenshot 1" />

<img src="https://github.com/sametkoyuncu/fmss-ios-bootcamp-homework-4/blob/development/screenshots/hm4-ss2.png"  alt="screenshot 2" />

## Ekran Kaydı
[![youtube-video](https://i.ibb.co/vX2864R/Ekran-Resmi-2022-10-09-11-27-48.png)](https://www.youtube.com/embed/9-LWFcrKKl8)
