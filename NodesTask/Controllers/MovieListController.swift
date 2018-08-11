//
//  MovieListController.swift
//  NodesTask
//
//  Created by Radek Zmeskal on 09/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit

enum Sorting: String {
    case title = "title"
    case rating = "rating"
    case release = "release"
}

class MovieListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textSearch: UITextField!
    @IBOutlet weak var buttonOrder: UIButton!
    @IBOutlet weak var buttonAsc: UIButton!
    
    /// list movies
    var movies: [Movie] = []
    
    /// type of ordr
    var order: Bool = true
    /// type of sorting
    var sorting: Sorting = .title

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell to tableview
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cellMovie")
        
        // set table
        self.tableView.tableFooterView = UIView()
        
        // set buttons
        self.buttonOrder.setTitle(self.sorting.rawValue.uppercased(), for: .normal)
        self.buttonAsc.setTitle("ASC", for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide navigation bar
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell( withIdentifier: "cellMovie", for: indexPath) as? MovieCell
        {
            let movie = self.movies[indexPath.row]
            
            cell.setupCell(movie: movie)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // hide keyboard
        self.textSearch.resignFirstResponder()
        
        // get movie and show detail
        let movie = self.movies[indexPath.row]
        self.performSegue(withIdentifier: "segueDetail", sender: movie)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // set movie to detail
        if let controller = segue.destination as? MovieDetailController {
            if let movie = sender as? Movie {
                controller.movie = movie
            }
        }
    }
    
    // MARK: - Functions
    
    /// Load list of movies
    ///
    /// - Parameter query: query string
    func loadMovies(query: String?) {
        // check string
        guard let queryString = query else {
            return
        }
        
        APICalls.fetchMovies(query: queryString) { (response) in
            // test response
            if let movies = response {
                self.movies = movies
            } else {
                self.movies = []
            }
            
            // sort and order result
            self.movies.sort(by: { (movie1, movie2) -> Bool in
                if self.order {
                    switch self.sorting {
                    case .title:
                        return movie1.title < movie2.title
                    case .release:
                        if let releseDate1 = movie1.releseDate, let releseDate2 = movie2.releseDate {
                            return releseDate1 < releseDate2
                        } else {
                            return false
                        }
                    case .rating:
                        if let vote1 = movie1.vote, let vote2 = movie2.vote {
                            return vote1 < vote2
                        } else {
                            return false
                        }
                    }
                } else {
                    switch self.sorting {
                    case .title:
                        return movie1.title > movie2.title
                    case .release:
                        if let releseDate1 = movie1.releseDate, let releseDate2 = movie2.releseDate {
                            return releseDate1 > releseDate2
                        } else {
                            return false
                        }
                    case .rating:
                        if let vote1 = movie1.vote, let vote2 = movie2.vote {
                            return vote1 > vote2
                        } else {
                            return false
                        }
                    }
                }
            })
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - IBAction
    
    /// TextField changed
    ///
    /// - Parameter sender: sender UITextField
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if let query = sender.text {
            // cancel old request
            APICalls.cancelAllRequests()
            self.loadMovies(query: query)
        } else {
            // clear data
            self.movies = []
            self.tableView.reloadData()
        }
    }
    
    /// Action to clear search textfield
    ///
    /// - Parameter sender: sender UIButton
    @IBAction func touchClear(_ sender: UIButton) {
        self.textSearch.text = ""
        self.movies = []
        self.tableView.reloadData()
    }
    
    /// Action to hide keyboard
    ///
    /// - Parameter sender: sender UITextField
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /// Action to show sorting options
    ///
    /// - Parameter sender: sender AnyObject
    @IBAction func touchSort(_ sender: AnyObject)
    {
        // create selection of sorting
        let alert = UIAlertController(title: "Sort", message: "Please select sorting option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Title", style: .default , handler:{ (UIAlertAction)in
            self.sorting = .title
            self.buttonOrder.setTitle(self.sorting.rawValue.uppercased(), for: .normal)
            self.loadMovies(query: self.textSearch.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Rating", style: .default , handler:{ (UIAlertAction)in
            self.sorting = .rating
            self.buttonOrder.setTitle(self.sorting.rawValue.uppercased(), for: .normal)
            self.loadMovies(query: self.textSearch.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Release", style: .default , handler:{ (UIAlertAction)in
            self.sorting = .release
            self.buttonOrder.setTitle(self.sorting.rawValue.uppercased(), for: .normal)
            self.loadMovies(query: self.textSearch.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Action to show order options
    ///
    /// - Parameter sender: sender AnyObject
    @IBAction func touchOrder(_ sender: AnyObject)
    {
        let alert = UIAlertController(title: "Ordreing", message: "Please select order option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ascending", style: .default , handler:{ (UIAlertAction)in
            self.order = true
            self.buttonAsc.setTitle("ASC", for: .normal)
            self.loadMovies(query: self.textSearch.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Descending", style: .default , handler:{ (UIAlertAction)in
            self.order = false
            self.buttonAsc.setTitle("DES", for: .normal)
            self.loadMovies(query: self.textSearch.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
