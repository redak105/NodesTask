//
//  Movie.swift
//  NodesTask
//
//  Created by Radek Zmeskal on 09/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {
    
    /// identificatoe
    let id: Int32
    /// average vote
    let vote: Float?
    /// title
    let title: String
    /// path to poster image
    let posterPath: String
    /// release date
    let releseDate: Date?
    /// language
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

