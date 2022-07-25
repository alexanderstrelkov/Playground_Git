import UIKit
import Foundation
import CommonCrypto
import CryptoKit

func hashToMD5(_ string: String) -> String? {
    let length = Int(CC_MD5_DIGEST_LENGTH)
    var digest = [UInt8](repeating: 0, count: length)
    
    if let d = string.data(using: String.Encoding.utf8) {
        _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            CC_MD5(body, CC_LONG(d.count), &digest)
        }
    }
    return (0..<length).reduce("") {
        $0 + String(format: "%02x", digest[$1])
    }
}

func getData(urlRequest: String) {
    
    let urlRequest = URL(string: urlRequest)
    guard let url = urlRequest else { fatalError("some error") }
    
    let configuration: URLSessionConfiguration = .default
    configuration.allowsCellularAccess = false
    
    let session = URLSession(configuration: configuration)
    
    session.dataTask(with: url) { data, response, error in
        if error != nil {
            print(error?.localizedDescription ?? "")
            return
        } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
            guard let data = data else { return }
            let dataAsString = String(data: data, encoding: .utf8)
            print("Код от сервера: \(response.statusCode)")
            print(dataAsString ?? "no data")
        }
    }.resume()
}

let ts1 = "ts=1"
let apiKey = "&apikey=c5387b1bb3b2558d5d8e5d08c320ccb5"
let md5 =
hashToMD5("102ef87f7dbecf6c3ea16d6bbc729b27ccfefd1c6c5387b1bb3b2558d5d8e5d08c320ccb5") ?? ""
let hash = "&hash=\(md5)"
let apiUrl = "https://gateway.marvel.com/v1/public/characters?"
var marvelURL = "\(apiUrl)\(ts1)\(apiKey)\(hash)"

getData(urlRequest: marvelURL)


