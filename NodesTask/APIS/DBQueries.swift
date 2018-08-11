//
//  DBQueries.swift
//  NodesTask
//
//  Created by Radek Zmeskal on 10/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import CoreData

class DBQueries: NSObject {
    
    /// Add movie
    ///
    /// - Parameter movie: moview to add
    /// - Returns: new Favourite object
    class func addToFavourite(movie: Movie) -> Favourite? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        /// search if entity is already created
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        
        request.predicate = NSPredicate(format: "id = %d", movie.id )
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if let result = result as? [Favourite], result.count > 0 {
                // update finded entity
                let favourite = result[0]
                                
                favourite.id = movie.id
                if let vote = movie.vote {
                    favourite.vote = vote
                }
                favourite.title = movie.title
                favourite.posterPath = movie.posterPath
                favourite.language = movie.language
                
                do {
                    try context.save()
                    
                    return favourite
                } catch {
                    print("Failed saving updated entity")
                    return nil
                }
            }
        } catch {
            print("Failed search for favourite to added it")
            return nil
        }
        
        // create new entity
        let entity = NSEntityDescription.entity(forEntityName: "Favourite", in: context)
        if let favourite = NSManagedObject(entity: entity!, insertInto: context) as? Favourite {
            
            favourite.id = movie.id
            if let vote = movie.vote {
                favourite.vote = vote
            }
            favourite.title = movie.title
            favourite.posterPath = movie.posterPath
            favourite.language = movie.language
        
            do {
                try context.save()
                
                return favourite
            } catch {
                print("Failed saving new Favourite entity")                
                return nil
            }
        }
        
        return nil
    }
    
    /// Remove entity from favourite
    ///
    /// - Parameter favourite: entity to delete
    /// - Returns: succes of operation
    class func removeFromFavourite(favourite: Favourite) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(favourite)
        
        do {
            try context.save()
            
            return true
        } catch {
            print("Failed saving of updates of DB by deleteding Favourites entity")
        }
        
        return false
    }
    
    /// Load all Favourites entities
    ///
    /// - Returns: list of entities
    class func fetchFavourites() -> [Favourite]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if let result = result as? [Favourite] {
                return result
            }
        } catch {
            print("Failed load Favourite entities")
        }
        
        return nil
    }

}
