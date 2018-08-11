//
//  Movie.swift
//  NodesTest
//
//  Created by Radek Zmeskal on 09/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {
    
    let id: Int32
    let vote: Float?
    let title: String
    let posterPath: String
    let releseDate: Date?
    let language: String
    
    init( id: Int32, vote: Float, title: String, posterPath: String, releseDate: Date, language: String ) {
        self.id = id;
        self.vote = vote
        self.title = title
        self.posterPath = posterPath
        self.releseDate = releseDate
        self.language = language
    }
    
    init(json: [String: Any] ) {
        let jsonData = JSON(json)
        self.id = jsonData["id"].int32Value
        self.vote = jsonData["vote_average"].float
        if let title = jsonData["title"].string {
            self.title = title
        } else {
            self.title = ""
        }
        if let posterPath = jsonData["poster_path"].string {
            self.posterPath = posterPath
        } else {
            self.posterPath = ""
        }
        if let language = jsonData["original_language"].string {
            self.language = language.uppercased()
        } else {
            self.language = ""
        }
        if let dateString = jsonData["release_date"].string, let date = Date(string: dateString) {
            self.releseDate = date
        } else {
            self.releseDate = nil
        }
    }
}


//"vote_count": 2583,
//"id": 447332,
//"video": false,
//"vote_average": 7.1,
//"title": "A Quiet Place",
//"popularity": 52.408,
//"poster_path": "/nAU74GmpUk7t5iklEp3bufwDq4n.jpg",
//"original_language": "en",
//"original_title": "A Quiet Place",
//"genre_ids": [
//18,
//27,
//53,
//878
//],
//"backdrop_path": "/roYyPiQDQKmIKUEhO912693tSja.jpg",
//"adult": false,
//"overview": "A family is forced to live in silence while hiding from creatures that hunt by sound.",
//"release_date": "2018-04-03"
