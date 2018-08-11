//
//  MovieCell.swift
//  NodesTask
//
//  Created by Radek Zmeskal on 09/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var imageCover: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelLang: UILabel!
    @IBOutlet weak var labelVote: UILabel!
    
    /// movie object
    var movie:Movie?
    /// favourite entity
    var favourite:Favourite?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// Setup cell for movie object
    ///
    /// - Parameter movie: movie object
    func setupCell(movie: Movie) {
        self.movie = movie
        
        self.labelTitle.text = movie.title
        self.labelLang.text = movie.language
        if let vote = movie.vote {
            self.labelVote.text = String(vote)
        } else {
            self.labelVote.text = ""
        }
        
        if let url =  URL(string: APICalls.createURLImage(path: movie.posterPath)) {
            let placeholderImage = UIImage(named: "posterPlaceholder")!
            self.imageCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            self.imageCover.image = nil
        }
    }
    
    /// Setup cell for favourite entity
    ///
    /// - Parameter favourite: favourite entity
    func setupCell(favourite: Favourite) {
        self.favourite = favourite
        
        self.labelTitle.text = favourite.title
        self.labelLang.text = favourite.language
        if favourite.vote != 0 {
            self.labelVote.text = String(favourite.vote)
        } else {
            self.labelVote.text = ""
        }
        
        if let posterPath = favourite.posterPath, let url =  URL(string: APICalls.createURLImage(path: posterPath)) {
            let placeholderImage = UIImage(named: "posterPlaceholder")!
            self.imageCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            self.imageCover.image = nil
        }
    }

}
