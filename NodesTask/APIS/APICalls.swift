//
//  APICalls.swift
//  NodesTask
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

    /// Create URL fo images
    ///
    /// - Parameter path: path to create to load image
    /// - Returns: url to image
    class func createURLImage(path: String) -> String {
        return URL_IMAGE + path
    }
    
    /// Cancel all request
    class func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
//            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
        }
    }
    
    /// Load movies from server
    ///
    /// - Parameters:
    ///   - query: string to search
    ///   - completion: responce callback
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
                // test success
                guard response.result.isSuccess else {
                    print("Failed request to load movies from server")
                    
                    if let alamoError = response.result.error {
                        print(alamoError)
                    }
                    
                    completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    print("Failed parse response of request to load movies from server")
                    completion(nil)
                    return
                }
                
                guard let result = value["results"] as? [[String: Any]] else {
                    print("Failed parse results of request to load movies from server")
                    completion(nil)
                    return
                }
                
                let movies = result.compactMap { movie in return Movie(json: movie) }
                completion(movies)
        }
    }
    
    /// Load detail of movies from server
    ///
    /// - Parameters:
    ///   - id: id of movie
    ///   - completion: responce callback
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
                    print("Failed request to load movie detail from server")
                    
                    if let alamoError = response.result.error {
                        print(alamoError)
                    }
                    
                    completion(nil)
                    return
                }
                
                guard let result = response.result.value as? [String: Any] else {
                    print("Failed parse response of request to movie detail from server")
                    completion(nil)
                    return
                }
                
                completion(result)
        }
    }
    
}
