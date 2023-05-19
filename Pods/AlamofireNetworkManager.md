# swift'te alamofire ile generic bir network manager yaz

Tabii, aşağıda bir örnek Alamofire tabanlı genel bir ağ yöneticisi (network manager) sınıfı bulunmaktadır:

```swift
import Alamofire

class NetworkManager {
    static let shared = NetworkManager() // Singleton instance

    private init() {}

    func request<T: Decodable>(_ url: URLConvertible,
                              method: HTTPMethod = .get,
                              parameters: Parameters? = nil,
                              headers: HTTPHeaders? = nil,
                              completion: @escaping (Result<T, Error>) -> Void) {
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
```

Bu sınıf, genel bir ağ isteği yapmak için kullanılabilir. `request` metodu, bir URL, isteğin HTTP metodu, parametreler, başlıklar ve tamamlama bloğunu alır. Bu metot, Alamofire kullanarak isteği yapar, yanıtı doğrular ve JSON'u belirtilen tipe (`T`) dönüştürür.

Örnek kullanım:

```swift
struct Post: Decodable {
    let id: Int
    let title: String
    let body: String
}

NetworkManager.shared.request("https://jsonplaceholder.typicode.com/posts/1") { (result: Result<Post, Error>) in
    switch result {
    case .success(let post):
        print("Post Title: \(post.title)")
        print("Post Body: \(post.body)")
    case .failure(let error):
        print("Error: \(error.localizedDescription)")
    }
}
```

Bu örnekte, JSONPlaceholder API'sinden bir gönderi (post) almak için `NetworkManager` kullanılıyor. Yanıt bir `Post` nesnesine dönüştürülüyor ve başarı durumunda postun başlık ve içeriği yazdırılıyor.

Not: Bu örnek, Swift 5 ve Alamofire 5 ile uyumludur. Projenizin Alamofire ve Decodable'ı içeren uygun bağımlılıkları içerdiğinden emin olun.

# bu manager'ı kullanarak bir de post örneği yap. mesela register işlemi

Tabii, `NetworkManager`'ı kullanarak bir "register" işlemi örneği yapabiliriz. Bu örnekte, kullanıcı bilgilerini bir POST isteğiyle bir sunucuya göndererek kayıt olma işlemini simüle edeceğiz.

Öncelikle, kayıt işlemi için kullanılacak modeli oluşturalım:

```swift
struct RegisterRequest: Encodable {
    let username: String
    let password: String
    let email: String
}
```

Daha sonra, `NetworkManager`'ı kullanarak kayıt isteğini yapalım:

```swift
struct RegisterResponse: Decodable {
    // Define the properties you expect in the response
    // Example: let userId: Int
}

func registerUser(username: String, password: String, email: String) {
    let registerURL = "https://api.example.com/register"
    let registerRequest = RegisterRequest(username: username, password: password, email: email)

    NetworkManager.shared.request(registerURL, method: .post, parameters: registerRequest) { (result: Result<RegisterResponse, Error>) in
        switch result {
        case .success(let response):
            // Handle the successful response
            // Example: let userId = response.userId
            print("Registration successful!")
        case .failure(let error):
            // Handle the error
            print("Registration failed: \(error.localizedDescription)")
        }
    }
}
```

Bu örnekte, `registerUser` fonksiyonu, kullanıcı adı, şifre ve e-posta parametrelerini alarak `RegisterRequest` nesnesini oluşturur ve `NetworkManager` üzerinden kayıt isteğini gerçekleştirir. Sonuç, `RegisterResponse` tipinde bir yanıt olarak beklenir. Başarılı bir kayıt durumunda, isteğe özgü yanıtı (`response`) ele alabilirsiniz. Hata durumunda, hata mesajı yazdırılır.

Örnek kullanım:

```swift
registerUser(username: "john_doe", password: "password123", email: "john.doe@example.com")
```

Bu örnekte, "john_doe" kullanıcı adı, "password123" şifre ve "john.doe@example.com" e-posta ile bir kayıt işlemi yapılır. Başarılı bir kayıt durumunda, "Registration successful!" mesajı görüntülenir. Hata durumunda, hata mesajı yazdırılır.

Dikkat: Gerçek bir kayıt işlemi için uygun bir API kullanmanız ve kayıt için gereken parametreleri doğru şekilde oluşturmanız gerektiğini unutmayın.

# login örneği

Tabii, 4. maddede belirtilen oturum yönetimi için `NetworkManager` örneği yapalım. Aşağıda basit bir örnek sunulmuştur:

```swift
import Alamofire

class NetworkManager {
    static let shared = NetworkManager() // Singleton instance

    private var authToken: String? // Oturum kimlik doğrulama belirteci

    private init() {}

    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Simüle edilmiş giriş işlemi
        // Burada gerçek bir kimlik doğrulama işlemi yapmanız gerekebilir

        // Başarılı giriş durumunda, oturum belirteci (token) döndürülür
        let token = "example_auth_token"
        authToken = token
        completion(.success(token))
    }

    func logout() {
        // Oturumu sonlandırma işlemi
        authToken = nil
    }

    func makeAuthenticatedRequest<T: Decodable>(_ url: URLConvertible,
                                                method: HTTPMethod = .get,
                                                parameters: Parameters? = nil,
                                                headers: HTTPHeaders? = nil,
                                                completion: @escaping (Result<T, Error>) -> Void) {
        guard let authToken = authToken else {
            let error = NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Oturum açılmamış"])
            completion(.failure(error))
            return
        }

        var headers = headers ?? [:]
        headers["Authorization"] = "Bearer \(authToken)"

        AF.request(url,
                   method: method,
                   parameters: parameters,
                   headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
```

Bu örnekte, `NetworkManager` sınıfına oturum yönetimi ekledik. `login` metodu, kullanıcı adı ve şifre parametrelerini alarak kullanıcıyı kimlik doğrulama işlemiyle simüle ediyor. Başarılı bir giriş durumunda, oturum belirteci (token) alınır ve `authToken` özelliğine kaydedilir.

`makeAuthenticatedRequest` metodu, kimlik doğrulama gerektiren API isteklerini gerçekleştirmek için kullanılır. Bu metot, mevcut oturum belirteci (token) ile birlikte isteği gönderir. Eğer oturum açılmamışsa, bir hata döndürülür.

Örnek kullanım:

```swift
NetworkManager.shared.login(username: "john_doe", password: "password123") { result in
    switch result {
    case .success(let token):
        print("Login successful! Token: \(token)")

        // Authenticated request example
        NetworkManager.shared.makeAuthenticatedRequest("https://api.example.com/profile") { (result: Result<UserProfile, Error>) in
            switch result {
            case .success(let profile):
                print("User Profile: \(profile)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }

        // Logout example
        NetworkManager.shared

.logout()
    case .failure(let error):
        print("Login failed: \(error.localizedDescription)")
    }
}
```

Bu örnekte, `login` metoduyla kullanıcı girişi yapılır ve başarılı bir giriş durumunda oturum belirteci (token) elde edilir. Ardından `makeAuthenticatedRequest` metoduyla oturum açıkken kimlik doğrulama gerektiren bir API isteği yapılır. Başarılı durumda, kullanıcı profilini alır ve hata durumunda ilgili hata mesajı yazdırılır. Son olarak, `logout` metodu çağrılarak oturum sonlandırılır.

# veritabanı senkronizasyonu için NetworkManager örneği

Tabii, 5. maddede belirtildiği gibi veritabanı senkronizasyonu için `NetworkManager` örneği yapalım. Aşağıda basit bir örnek sunulmuştur:

```swift
import Alamofire

class NetworkManager {
    static let shared = NetworkManager() // Singleton instance

    private init() {}

    func syncData(completion: @escaping (Result<[DataModel], Error>) -> Void) {
        // Veritabanınızdan senkronize edilecek verileri alın
        let dataToSync = DatabaseManager.shared.getDataToSync()

        // Verileri sunucuya gönderin ve senkronizasyon yanıtını alın
        let syncURL = "https://api.example.com/sync"
        AF.request(syncURL, method: .post, parameters: dataToSync)
            .validate()
            .responseDecodable(of: [DataModel].self) { response in
                switch response.result {
                case .success(let syncedData):
                    // Senkronize edilen verileri veritabanınıza kaydedin
                    DatabaseManager.shared.saveSyncedData(syncedData)
                    completion(.success(syncedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
```

Bu örnekte, `NetworkManager` sınıfına veritabanı senkronizasyonu için bir örnek ekledik. `syncData` metodu, veritabanından senkronize edilecek verileri alır ve bu verileri bir POST isteği ile sunucuya gönderir. Sunucudan dönen senkronize edilmiş verileri alır ve bu verileri veritabanında kaydeder.

`DatabaseManager` burada varsayılan bir veritabanı yöneticisi olarak kullanılmıştır. `getDataToSync` metodu senkronize edilecek verileri veritabanından alırken, `saveSyncedData` metodu senkronize edilen verileri veritabanına kaydeder. Bu kısımlar projenizdeki veritabanı yönetimiyle uyumlu hale getirilmelidir.

Örnek kullanım:

```swift
NetworkManager.shared.syncData { result in
    switch result {
    case .success(let syncedData):
        print("Data synchronization successful!")
        print("Synced Data: \(syncedData)")
    case .failure(let error):
        print("Data synchronization failed: \(error.localizedDescription)")
    }
}
```

Bu örnekte, `syncData` metodu çağrılarak verilerin senkronizasyonu gerçekleştirilir. Başarılı durumda, senkronize edilen veriler yazdırılır ve hata durumunda ilgili hata mesajı yazdırılır.

Dikkat: Gerçek bir veritabanı senkronizasyonu senaryosunda, veri türleri, senkronizasyon stratejileri ve hata yönetimi gibi diğer unsurları da dikkate almanız gerekebilir. Bu örnek, temel bir senaryoyu göstermek için tasarlanmıştır ve projenizin gereksinimlerine göre uyarlanmalıdır.

# hata yönetimi hakkında genel bilgi

`NetworkManager` kullanırken hata yönetimini yapmanız gereken bazı adımlar şunlardır:

1. **Hata Tiplerini Belirleyin**: Hangi tür hataların ortaya çıkabileceğini belirleyin. Örneğin, ağ bağlantısı hataları, sunucu hataları, geçersiz veri hataları gibi çeşitli hata türleri olabilir. Bu hataları temsil eden hata tiplerini tanımlayarak başlayabilirsiniz.

```swift
enum NetworkError: Error {
    case connectionError
    case serverError
    case invalidData
    // Diğer hata tipleri eklenebilir
}
```

2. **Hata Durumlarını Yakalayın**: `NetworkManager`'ın isteği gerçekleştirdiği closure'larda hata durumlarını yakalayın. Alamofire gibi ağ kütüphaneleri genellikle `Result` tipini kullanır. Bu durumda, `failure` bloğunda hata durumunu yakalayabilir ve uygun `NetworkError` türündeki hataları döndürebilirsiniz.

```swift
NetworkManager.shared.makeAuthenticatedRequest("https://api.example.com/profile") { (result: Result<UserProfile, Error>) in
    switch result {
    case .success(let profile):
        // Başarılı yanıtı ele al
    case .failure(let error):
        // Hata durumunu ele al
        if let networkError = error as? NetworkError {
            switch networkError {
            case .connectionError:
                // Ağ bağlantısı hatası durumunu ele al
            case .serverError:
                // Sunucu hatası durumunu ele al
            case .invalidData:
                // Geçersiz veri hatası durumunu ele al
            }
        } else {
            // Diğer hata türlerini ele al
        }
    }
}
```

3. **Hata İletişimini Kullanıcıya Gösterin**: Kullanıcıya uygun geri bildirimi sağlamak için hata durumunu kullanabilirsiniz. Örneğin, bir bildirim gösterebilir, bir hata mesajı görüntüleyebilir veya kullanıcı arayüzünü uygun şekilde güncelleyebilirsiniz.

```swift
case .failure(let error):
    if let networkError = error as? NetworkError {
        switch networkError {
        case .connectionError:
            // Ağ bağlantısı hatası durumunu kullanıcıya bildir
            showErrorAlert(message: "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin.")
        case .serverError:
            // Sunucu hatası durumunu kullanıcıya bildir
            showErrorAlert(message: "Sunucu hatası. Lütfen daha sonra tekrar deneyin.")
        case .invalidData:
            // Geçersiz veri hatası durumunu kullanıcıya bildir
            showErrorAlert(message: "Geçersiz veri hatası. Lütfen geçerli bir yanıt alana kadar bekleyin.")
        }
    } else {
        // Diğer hata türlerini ele al
        showErrorAlert

(message: "Beklenmeyen bir hata oluştu.")
    }
```

4. **Hata İşleme Stratejisini Belirleyin**: Hata durumlarına nasıl tepki vereceğinizi belirleyin. Örneğin, kullanıcıya hata mesajı göstermek, tekrar deneme seçeneği sunmak, varsayılan değerlerle işleme devam etmek gibi çeşitli stratejiler olabilir. Hata yönetimi, projenizin gereksinimlerine ve kullanıcı deneyimine bağlı olarak şekillendirilmelidir.

```swift
func syncData(completion: @escaping (Result<[DataModel], Error>) -> Void) {
    // ...

    AF.request(syncURL, method: .post, parameters: dataToSync)
        .validate()
        .responseDecodable(of: [DataModel].self) { response in
            switch response.result {
            case .success(let syncedData):
                // ...
            case .failure(let error):
                // Hata durumunu ele al
                let networkError: NetworkError

                if let afError = error as? AFError {
                    switch afError {
                    case .sessionTaskFailed(let urlError as URLError) where urlError.code == .notConnectedToInternet:
                        networkError = .connectionError
                    case .responseValidationFailed(let validationError as AFError.URLErrorValidationResult),
                         .responseSerializationFailed(let serializationError as AFError.ResponseSerializationFailureReason):
                        if validationError.isUnacceptableStatusCode || serializationError.isInvalidContentType {
                            networkError = .serverError
                        } else {
                            networkError = .invalidData
                        }
                    default:
                        networkError = .serverError
                    }
                } else {
                    networkError = .serverError
                }

                completion(.failure(networkError))
            }
        }
}
```

Yukarıdaki adımları takip ederek, `NetworkManager` kullanırken hata yönetimini geliştirebilir ve hataları kullanıcıya iletebilirsiniz. Hata yönetimi, kullanıcının sorunsuz bir deneyim yaşamasını sağlamak ve kullanıcıya uygun geri bildirimi sunmak için önemlidir. Projenizin gereksinimlerine bağlı olarak bu adımları uyarlayabilir ve hata yönetimini geliştirebilirsiniz.

# showErrorAlert

Elbette! `showErrorAlert` adlı bir metodun örneğini aşağıda bulabilirsiniz. Bu metod, basit bir şekilde hata mesajını kullanıcıya göstermek için bir `UIAlertController` kullanır:

```swift
import UIKit

func showErrorAlert(message: String) {
    let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
    alert.addAction(okAction)

    guard let topViewController = UIApplication.shared.keyWindow?.rootViewController else {
        return
    }

    topViewController.present(alert, animated: true, completion: nil)
}
```

Bu metod, `message` parametresi olarak alınan hata mesajını içeren bir `UIAlertController` oluşturur. Daha sonra bu alert'i mevcut en üst düzey view controller'a (`rootViewController`) ekler ve kullanıcıya gösterir. Kullanıcı "Tamam" butonuna tıkladığında hiçbir eylem gerçekleşmez.

Bu yöntemi, `NetworkManager`'ın hata durumlarını kullanıcıya bildirmek için kullanabilirsiniz. Örneğin:

```swift
case .failure(let error):
    if let networkError = error as? NetworkError {
        switch networkError {
        case .connectionError:
            showErrorAlert(message: "Ağ bağlantısı hatası. Lütfen internet bağlantınızı kontrol edin.")
        case .serverError:
            showErrorAlert(message: "Sunucu hatası. Lütfen daha sonra tekrar deneyin.")
        case .invalidData:
            showErrorAlert(message: "Geçersiz veri hatası. Lütfen geçerli bir yanıt alana kadar bekleyin.")
        }
    } else {
        showErrorAlert(message: "Beklenmeyen bir hata oluştu.")
    }
}
```

Bu örnekte, `showErrorAlert` metodu kullanılarak farklı hata durumları için uygun hata mesajları kullanıcıya gösterilir.

`showErrorAlert` metodunu projenizin gereksinimlerine göre özelleştirebilirsiniz. Örneğin, buton eylemleri ekleyebilir, farklı hata türlerine göre farklı stil ve görünüm ayarları yapabilirsiniz.

# GET ve POST İstek Örnekleri

```swift
NetworkManager.shared.request("https://jsonplaceholder.typicode.com/users") { (result: Result<User, Error>) in
    switch result {
        case .success(let users):
        users.forEach {
            print($0.name)
        }
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
}

// MARK: - post example
let registerRequest = UserPostRequest(title: "deneme", body: "body", userId: 1)
NetworkManager.shared.request("https://jsonplaceholder.typicode.com/posts", method: .post, parameters:  registerRequest.parameters) { (result: Result<UserPostResponse, Error>) in
print(result)
    switch result {
    case .success(let response):
        // Handle the successful response
        // Example: let userId = response.userId
        print("Registration successful! \(response)")
    case .failure(let error):
        // Handle the error
        print("Registration failed: \(error.localizedDescription)")
    }
}
```

### Parameters için Computed Property Örneği

```swift
struct UserPostRequest: Encodable {
    let title: String
    let body: String
    let userId: Int

    var parameters: Parameters {
        return [
            "title": title,
            "body": body,
            "userId": userId
        ]
    }
}

// Alttaki şekilde de olabilirmiş ama yukarıdaki güzel
struct UserPostRequest: Codable {
    let title: String
    let body: String
    let userId: Int
}

extension UserPostRequest {
    var parameters: Parameters? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: []) as? Parameters
    }
}
```
