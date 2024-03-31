//
//  ApiClient.swift
//  practiceApp
//
//  Created by t032fj on 2024/02/24.
//

import Foundation
import Alamofire
import AlamofireImage

struct APIClient {

    static let shared = APIClient()
    
    static func httpRequest(decodableType: Decodable.Type?, urlString: String, method: HTTPMethod, parameters: [String: AnyObject]?) async throws -> Decodable {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(urlString, method: method, parameters: parameters)
                .responseJSON { response in
                    _ = response.response?.statusCode
                    guard let decodableType = decodableType else { return }
                    switch response.result {
                    case .success(let value):
                        do {
                            print(value)
                            let decoder = JSONDecoder()
                            let data = try JSONSerialization.data(withJSONObject: value, options: [])
                            let model: Decodable = try decoder.decode(decodableType, from: data)
                            continuation.resume(returning: model)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
    
    static func alamofireImageRequest(url: String) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url).responseImage { response in
                switch response.result {
                case .success(let image):
                    continuation.resume(returning: image)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}


