//
//  Date.swift
//  NodesTask
//
//  Created by Radek Zmeskal on 09/08/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit

extension Date {
    
    /// custom inicialization
    ///
    /// - Parameter string: date in format "yyyy-MM-dd"
    init?( string: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: string) else {
            return nil
        }
        self = date
    }
    
    /// Format date to format "dd.MM.yyyy"
    ///
    /// - Returns: string representation
    func format() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
