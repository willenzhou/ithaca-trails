//
//  NetworkManager.swift
//  IthacaTrails2
//
//  Created by Justin Gu on 12/7/20.
//

import Foundation
import Alamofire

class NetworkManager {
    private static let host =
    "http://0.0.0.0:5000/api/trails/"
    
//    "https://ithacatrailsapp.herokuapp.com/api/trails/"

    static func getTrails(completion: @escaping ([Trail]) -> Void) {
        AF.request(host, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let trailsData = try? jsonDecoder.decode(Response<[Trail]>.self, from: data) {
                    let trails = trailsData.data
                    completion(trails)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // get a single trail
    static func getTrail(id: Int, completion: @escaping (Trail) -> Void) {
        let parameters: [String: Any] = [
            "id": id
        ]
        AF.request(host, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let trail = try? jsonDecoder.decode(Trail.self, from: data) {
                    completion(trail)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //search for trails based on a name or site name
    static func searchTrails(name: String, completion: @escaping ([Trail]) -> Void) {
          AF.request(host, method: .get).validate().responseData { response in
              switch response.result {
              case .success(let data):
                  let jsonDecoder = JSONDecoder()
                  jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                  if let trailsData = try? jsonDecoder.decode(Response<[Trail]>.self, from: data) {
                      var trails = [Trail]()
                      if name == "" {
                          trails = trailsData.data
                      }
                      else{
                          for t in trailsData.data{
                            if t.name.contains(name){
                                 trails.append(t)
                              }
                          }
                      }
                     
                      completion(trails)
                  }
              case .failure(let error):
                  print(error.localizedDescription)
              }
          }
      }
    
    static func makeReview(id: Int, title: String, username: String, body: String, rating: Int, completion: @escaping (Review) -> Void){
        let endpoint = "\(host)/\(id)/reviews/"
        let parameters: [String: Any] = ["title": title, "username": username, "body": body, "rating": rating]
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
                case .success(let data):
                    print(data)
                    let str = String(decoding: data, as: UTF8.self)
                    print(str)
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                    if let reviewData = try? jsonDecoder.decode(Response<Review>.self, from: data) {
                        let review = reviewData.data
                        completion(review)
                    }
            
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    static func getReviews(id: Int, completion: @escaping ([Review]) -> Void) {
        let endpoint = "\(host)/\(id)/reviews"
        AF.request(endpoint, method: .get).validate().responseData { response in
            debugPrint(response)
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let reviewsData = try? jsonDecoder.decode(Response<[Review]>.self, from: data) {
                    let reviews = reviewsData.data
                    completion(reviews)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
 
}

