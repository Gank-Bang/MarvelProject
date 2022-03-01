//
//  OurHeroes.swift
//  
//
//  Created by Rafiq Messai on 28/02/2022.
//

import Foundation

class OurHeroes: CustomStringConvertible {
    
    var description: String {
     "Character : \(self.name)\n"
    }
    
    var id: String
    var name: String
    var details: String
    var thumbnail: String?

        
    init(id: String, name: String,details: String,thumbnail: String?)
    
    {
        self.id = id
        self.name = name
        self.details = details
        self.thumbnail = thumbnail

    }

}

