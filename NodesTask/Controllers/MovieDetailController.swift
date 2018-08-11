//
//  MovieDetailController.swift
//  NodesTest
//
//  Created by Radek Zmeskal on 10/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import SwiftyJSON

class MovieDetailController: UIViewController {

    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLang: UILabel!
    @IBOutlet weak var labelVote: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    @IBOutlet weak var barButtonFavourite: UIBarButtonItem!
    
    
    var movie: Movie?
    var favourite: Favourite?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.labelTitle.text = ""
        self.labelLang.text = ""
        self.labelVote.text = ""
        self.labelOverview.text = ""
        self.imageMovie.image = nil
        self.labelGenres.text = ""
        
        var id: Int32? = nil
        if let movie = self.movie {
            id = movie.id
            self.barButtonFavourite.title = "\u{2606}"
        }
        if let favourite = self.favourite {
            id = favourite.id
            self.barButtonFavourite.title = "\u{2605}"
        }
        
        if let id = id {
            APICalls.fetchMovieDetail(id: id) { (result) in
                if let data = result {
                    let title = data["title"] as? String
                    self.title = title
                    self.labelTitle.text = title
                    self.labelOverview.text = data["overview"] as? String
                    
                    self.imageMovie.image = UIImage(named: "posterPlaceholder")!
                    
                    if let lang = data["original_language"] as? String {
                        self.labelLang.text = lang.uppercased()
                    } else {
                        self.labelLang.text = ""
                    }
                    
                    if let vote = data["vote_average"] as? Float {
                        self.labelVote.text = String(vote)
                    } else {
                        self.labelVote.text = ""
                    }
                    
                    if let link = data["backdrop_path"] as? String {
                        if let url =  URL(string: APICalls.creteURL(url: link)) {
                            let placeholderImage = UIImage(named: "posterPlaceholder")!
                            self.imageMovie.af_setImage(withURL: url, placeholderImage: placeholderImage)
                        }
                    }
                    
                    if let genres = data["genres"] as? [[String : Any]] {
                        let genres = genres.compactMap { genre in return genre["name"] as? String }
                        let genresString = genres.joined(separator: ", ")
                        
                        self.labelGenres.text = genresString
                    }
                    
                } else {
//                    self.labelTitle.text = ""
//                    self.labelLang.text = ""
//                    self.labelVote.text = ""
//                    self.labelOverview.text = ""
//                    self.imageMovie.image = nil
//                    self.labelGenres.text = ""
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // IBAction
    
    @IBAction func touchFavourite(_ sender: UIBarButtonItem) {
        if let movie = self.movie, self.favourite == nil {
            if let favourite = DBQueries.addToFavourite(movie: movie) {
                self.favourite = favourite
                self.barButtonFavourite.title = "\u{2605}"
            }
        } else {
            if let favourite = self.favourite, DBQueries.removeFromFavourite(favourite: favourite) {
                self.favourite = nil
                self.barButtonFavourite.title = "\u{2606}"
            }
        }
        
    }
}

//{
//    "adult": false,
//    "backdrop_path": "/roYyPiQDQKmIKUEhO912693tSja.jpg",
//    "belongs_to_collection": {
//        "id": 521226,
//        "name": "A Quiet Place Collection",
//        "poster_path": null,
//        "backdrop_path": null
//    },
//    "budget": 17000000,
//    "genres": [
//    {
//    "id": 18,
//    "name": "Drama"
//    },
//    {
//    "id": 27,
//    "name": "Horror"
//    },
//    {
//    "id": 53,
//    "name": "Thriller"
//    },
//    {
//    "id": 878,
//    "name": "Science Fiction"
//    }
//    ],
//    "homepage": "http://aquietplacemovie.com",
//    "id": 447332,
//    "imdb_id": "tt6644200",
//    "original_language": "en",
//    "original_title": "A Quiet Place",
//    "overview": "A family is forced to live in silence while hiding from creatures that hunt by sound.",
//    "popularity": 52.408,
//    "poster_path": "/nAU74GmpUk7t5iklEp3bufwDq4n.jpg",
//    "production_companies": [
//    {
//    "id": 29312,
//    "logo_path": null,
//    "name": "Sunday Night",
//    "origin_country": "US"
//    },
//    {
//    "id": 2481,
//    "logo_path": "/nVEP2IHCDOBOldgDL4SSufitN9.png",
//    "name": "Platinum Dunes",
//    "origin_country": "US"
//    },
//    {
//    "id": 4,
//    "logo_path": "/fycMZt242LVjagMByZOLUGbCvv3.png",
//    "name": "Paramount",
//    "origin_country": "US"
//    }
//    ],
//    "production_countries": [
//    {
//    "iso_3166_1": "US",
//    "name": "United States of America"
//    }
//    ],
//    "release_date": "2018-04-03",
//    "revenue": 328260889,
//    "runtime": 91,
//    "spoken_languages": [
//    {
//    "iso_639_1": "en",
//    "name": "English"
//    }
//    ],
//    "status": "Released",
//    "tagline": "If they hear you, they hunt you.",
//    "title": "A Quiet Place",
//    "video": false,
//    "vote_average": 7.1,
//    "vote_count": 2599
//}
