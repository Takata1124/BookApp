//
//  MapViewModel.swift
//  practiceApp
//
//  Created by t032fj on 2024/03/03.
//

import Foundation
import Alamofire
import CoreLocation
import Combine

struct statusDic : Codable{
    var systemId: String
    var key: String
    var value: String
}

class MapViewMode: BaseViewModel {
    
    var item: Item?
    var itemUIImage: UIImage?
    lazy var subject = PassthroughSubject<[statusDic], Error>()
    var systemIds: [String] = []
    var statusDics: [statusDic] = [] {
        didSet {
            self.subject.send(statusDics)
            _ = statusDics.map { statusDic in
                if systemIds.contains(statusDic.systemId) { return }
                systemIds.append(statusDic.systemId)
            }
        }
    }

    init(item: Item) {
        super.init()
        self.item = item
        
        Task {
            do {
                self.itemUIImage = try await APIClient.alamofireImageRequest(url: item.largeImageUrl)
            } catch {
                print(error)
            }
        }
    }
    
    func getLocationData(location: CLLocationCoordinate2D) async throws -> [Location]{
        return try await withCheckedThrowingContinuation { continuation in
            let apiKey = Apikey.libraryApikey
            let url = "https://api.calil.jp/library?appkey=\(apiKey)&callback=&geocode=\(location.longitude.description),\(location.latitude.description)&limit=10&format=json"
            AF.request(url).responseDecodable(of: [Location].self, decoder: JSONDecoder()) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func searchBook(systemId: String) async throws -> Int {
        return try await withCheckedThrowingContinuation { continuation in
            if let item = self.item {
                let apiKey = Apikey.libraryApikey
                let url = "https://api.calil.jp/check?appkey=\(apiKey)&isbn=\(String(describing: item.isbn))&systemid=\(systemId)&callback=no&format=json"
                AF.request(url).responseJSON { response in
                    _ = response.response?.statusCode
                    switch response.result {
                    case .success(let value):
                        var data = try! JSONSerialization.data(withJSONObject: value, options: [])
                        var json =  try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        data = try! JSONSerialization.data(withJSONObject: json["books"]!, options: [])
                        guard let status = json["continue"] as? Int else { return }
                        if status == 0 {
                            json =  try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                            data = try! JSONSerialization.data(withJSONObject: json[item.isbn]!, options: [])
                            json =  try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                            data = try! JSONSerialization.data(withJSONObject: json[systemId]!, options: [])
                            json =  try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                            if let libkey = json["libkey"] as? NSDictionary {
                                libkey.forEach { (key: Any, value: Any) in
                                    self.statusDics.append(statusDic(systemId: systemId, key: key as! String, value: value as! String))
                                }
                            }
                        }
                        continuation.resume(returning: status)
                    case .failure(let error):
                        print(error)
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
