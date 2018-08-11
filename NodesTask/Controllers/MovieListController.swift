//
//  MovieListController.swift
//  NodesTest
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
    
    var movies: [Movie] = []
    
    var ascending: Bool = true
    var sorting: Sorting = .title

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cellMovie")
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        self.textSearch.resignFirstResponder()
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let controller = segue.destination as? MovieDetailController {
            if let movie = sender as? Movie {
                controller.movie = movie
            }
        }
    }
    
    func loadMovies(query: String?) {
        guard let queryString = query else {
            return
        }
        
        APICalls.fetchMovies(query: queryString) { (response) in
            if let movies = response {
                self.movies = movies
            } else {
                self.movies = []
            }
            
            self.movies.sort(by: { (movie1, movie2) -> Bool in
                if self.ascending {
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
    
    // IBAction
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        if let query = sender.text {
            APICalls.cancelAllRequests()
            self.loadMovies(query: query)
        } else {
            self.movies = []
            self.tableView.reloadData()
        }
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        self.textSearch.text = ""
        self.movies = []
        self.tableView.reloadData()
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    /// Action to show sorting options
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func touchSort(_ sender: AnyObject)
    {
        let alert = UIAlertController(title: "Sort", message: "Please sorting option", preferredStyle: .actionSheet)
        
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
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /// Action to show sorting options
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func touchASC(_ sender: AnyObject)
    {
        let alert = UIAlertController(title: "Sorting", message: "Please sorting option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Ascending", style: .default , handler:{ (UIAlertAction)in
            self.ascending = true
            self.buttonAsc.setTitle("ASC", for: .normal)
            self.loadMovies(query: self.textSearch.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Descending", style: .default , handler:{ (UIAlertAction)in
            self.ascending = false
            self.buttonAsc.setTitle("DES", for: .normal)
            self.loadMovies(query: self.textSearch.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
