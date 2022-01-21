//
//  MarvelCharacters.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 14/01/2022.
//

import Foundation

class MarvelCharacters: CustomStringConvertible {
    
    var description: String {
     "Character : \(self.name)\n"
    }
    
    var id: Int
    var name: String
    var details: String
    var modified: String
    var thumbnail: URL?
    //var ressourceURL: String
    var comics: [MarvelComics]? = []
    //var series: [Serie]
    //var stories: [Story]
    //var events: [Evenement]
    //var urls: [Lien]
        
    init(id: Int, name: String,details: String,modified:String//,thumbnail:URLressourceURL:String,comics: [Comic],series: [Serie],stories:[Story],events:[Evenement],urls:[Lien]
    )
    
    {
        self.id = id
        self.name = name
        self.details = details
        self.modified = modified
        //self.thumbnail = thumbnail
        //self.ressourceURL = ressourceURL
        //self.comics = comics
        //self.series = series
        //self.stories = stories
        //self.events = events
        //self.urls = urls

    }
    

    
    
}



public struct Comic {
    
}
public struct Serie {
    
}
public struct Story {
    
}
public struct Evenement {
    
}
public struct Lien {
    
}
