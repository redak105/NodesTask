//
//  MovieDetailController.swift
//  NodesTask
//
//  Created by Radek Zmeskal on 10/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import SwiftyJSON
import JGProgressHUD

class MovieDetailController: UIViewController {

    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLang: UILabel!
    @IBOutlet weak var labelVote: UILabel!
    @IBOutlet weak var labelOverview: UILabel!
    @IBOutlet weak var labelGenres: UILabel!
    @IBOutlet weak var barButtonFavourite: UIBarButtonItem!
    
    /// movie object
    var movie: Movie?
    /// Favourite entity
    var favourite: Favourite?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // clear view
        self.labelTitle.text = ""
        self.labelLang.text = ""
        self.labelVote.text = ""
        self.labelOverview.text = ""
        self.imageMovie.image = nil
        self.labelGenres.text = ""
        
        // set favourite button
        var id: Int32? = nil
        if let movie = self.movie {
            id = movie.id
            self.barButtonFavourite.title = "\u{2606}"
        }
        if let favourite = self.favourite {
            id = favourite.id
            self.barButtonFavourite.title = "\u{2605}"
        }
        
        // load data
        if let id = id {
            // show progress
            let hud = JGProgressHUD(style: .dark)
            hud.show(in: self.view)
            
            APICalls.fetchMovieDetail(id: id) { (result) in
                hud.dismiss()
                
                // parse data
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
                        if let url =  URL(string: APICalls.createURLImage(path: link)) {
                            let placeholderImage = UIImage(named: "posterPlaceholder")!
                            self.imageMovie.af_setImage(withURL: url, placeholderImage: placeholderImage)
                        }
                    }
                    
                    if let genres = data["genres"] as? [[String : Any]] {
                        let genres = genres.compactMap { genre in return genre["name"] as? String }
                        let genresString = genres.joined(separator: ", ")
                        
                        self.labelGenres.text = genresString
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // show navigation bar
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
    
    // MARK: - IBAction
    
    /// Action to add/remove from favourites
    ///
    /// - Parameter sender: sender UIBarButtonItem
    @IBAction func touchFavourite(_ sender: UIBarButtonItem) {
        // check type of action
        if let movie = self.movie, self.favourite == nil {
            // add to favourite
            if let favourite = DBQueries.addToFavourite(movie: movie) {
                self.favourite = favourite
                self.barButtonFavourite.title = "\u{2605}"
            }
        } else {
            // remove from favourite
            if let favourite = self.favourite, DBQueries.removeFromFavourite(favourite: favourite) {
                self.favourite = nil
                self.barButtonFavourite.title = "\u{2606}"
            }
        }
        
    }
}

