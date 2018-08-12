//
//  FavouriteListController.swift
//  NodesTask
//
//  Created by Radek Zmeskal on 10/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit

class FavouriteListController: UITableViewController {

    /// list of favourites entities
    var favourites: [Favourite] = []
    
    /// label to show information to user
    let labelNoData = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register cell to tableview
        let nib = UINib(nibName: "MovieCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cellMovie")
        
        // set table
        self.tableView.tableFooterView = UIView()
        
        // set label
        self.labelNoData.textAlignment = .center
        self.labelNoData.text = "No favourites added"
        
        self.tableView.backgroundView = labelNoData
    }    
    
    override func viewWillAppear(_ animated: Bool) {
        // hide navigation bar
        self.navigationController?.navigationBar.isHidden = true
        
        // load favourites
        if let favourites = DBQueries.fetchFavourites() {
            self.favourites = favourites
        }
        
        if self.favourites.count == 0 {
            self.tableView.backgroundView = self.labelNoData
        } else {
            self.tableView.backgroundView = nil
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favourites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell( withIdentifier: "cellMovie", for: indexPath) as? MovieCell
        {
            let favourite = self.favourites[indexPath.row]
            
            cell.setupCell(favourite: favourite)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get favourite and show detail
        let favourite = self.favourites[indexPath.row]
        self.performSegue(withIdentifier: "segueDetail", sender: favourite)
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
        // set favourite to detail
        if let controller = segue.destination as? MovieDetailController {
            if let favourite = sender as? Favourite {
                controller.favourite = favourite
            }
        }
    }

}
