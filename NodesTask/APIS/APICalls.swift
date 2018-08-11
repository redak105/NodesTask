//
//  APICalls.swift
//  NodesTest
//
//  Created by Radek Zmeskal on 09/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import Alamofire

let URL_SERVER = "https://api.themoviedb.org/"
let URL_IMAGE = "https://image.tmdb.org/t/p/original"
let URL_MOVIES = URL_SERVER + "3/search/movie"
let URL_MOVIE_DETAIL = URL_SERVER + "3/movie/"

class APICalls: NSObject {

    class func creteURL(url: String) -> String {
        return URL_IMAGE + url
    }
    
    class func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
//            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    class func fetchMovies(query: String, completion: @escaping ([Movie]?) -> Void) {
        guard let url = URL(string: URL_MOVIES) else {
            completion(nil)
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: [
                            "api_key": "4cb1eeab94f45affe2536f2c684a5c9e",
                            "query": query
                            ]
            )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching from remote")
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                guard let result = value["results"] as? [[String: Any]] else {
                    completion(nil)
                    return
                }
                
                let movies = result.compactMap { movie in return Movie(json: movie) }
                completion(movies)
        }
    }
    
    class func fetchMovieDetail(id: Int32, completion: @escaping ([String: Any]?) -> Void) {
        guard let url = URL(string: URL_MOVIE_DETAIL + String(id)) else {
            completion(nil)
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: [
                            "api_key": "4cb1eeab94f45affe2536f2c684a5c9e",
            ]
            )
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching from remote")
                    completion(nil)
                    return
                }
                
                guard let result = response.result.value as? [String: Any] else {
                    completion(nil)
                    return
                }
                
                completion(result)
        }
    }
    
}
