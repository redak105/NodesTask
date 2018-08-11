//
//  MovieCell.swift
//  NodesTest
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
    
    
    var movie:Movie?
    var favourite:Favourite?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(movie: Movie) {
        self.movie = movie
        
        self.labelTitle.text = movie.title
        self.labelLang.text = movie.language
        if let vote = movie.vote {
            self.labelVote.text = String(vote)
        } else {
            self.labelVote.text = ""
        }
        
        if let url =  URL(string: APICalls.creteURL(url: movie.posterPath)) {
            let placeholderImage = UIImage(named: "posterPlaceholder")!
            self.imageCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            self.imageCover.image = nil
        }
    }
    
    func setupCell(favourite: Favourite) {
        self.favourite = favourite
        
        self.labelTitle.text = favourite.title
        self.labelLang.text = favourite.language
        if favourite.vote != 0 {
            self.labelVote.text = String(favourite.vote)
        } else {
            self.labelVote.text = ""
        }
        
        if let posterPath = favourite.posterPath, let url =  URL(string: APICalls.creteURL(url: posterPath)) {
            let placeholderImage = UIImage(named: "posterPlaceholder")!
            self.imageCover.af_setImage(withURL: url, placeholderImage: placeholderImage)
        } else {
            self.imageCover.image = nil
        }
    }

}
