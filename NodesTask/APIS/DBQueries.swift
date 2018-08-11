//
//  DBQueries.swift
//  NodesTest
//
//  Created by Radek Zmeskal on 10/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import CoreData

class DBQueries: NSObject {
    
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
                    print("Failed saving")
                    
                    return nil
                }
            }
        } catch {
            print("Failed")
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
                print("Failed saving")
                
                return nil
            }
        }
        
        return nil
    }
    
    class func removeFromFavourite(favourite: Favourite) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        /// search if entity is already created
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        
        request.predicate = NSPredicate(format: "id = %d", favourite.id )
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if let result = result as? [Favourite], result.count > 0 {
                
                for favourite in result {
                    context.delete(favourite)
                }
                
                do {
                    try context.save()
                    
                    return true
                } catch {
                    print("Failed saving")
                }
            }
        } catch {
            print("Failed")
        }
        
        return false
    }
    
    class func fetchFavourites() -> [Favourite]? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        /// search if entity is already created
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favourite")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if let result = result as? [Favourite] {
                return result
            }
        } catch {
            print("Failed")
        }
        
        return nil
    }

}
