//
//  MarvelComics.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 17/01/2022.
//

import Foundation

class MarvelComics: CustomStringConvertible {
    
    var description: String {
     "Comics : \(self.title)\n \(self.thumbnail)\n \(self.listNames)\n "
    }
    
    var id: Int
    var title: String
    var digitalId: Int
    var issueNumber: Int
    var details: String
    var numberPages: Int
    //var serieName: [Comic]
    var thumbnail: URL? = URL(string:"http://i.annihil.us/u/prod/marvel/i/mg/5/a0/4c0035890fb0a.jpg")
    var characterList: [MarvelCharacters]?
    var listNames: [String]? = []
    //var urls: [Lien]
        
    init(id: Int, title: String,digitalId: Int,issueNumber:Int,details:String,numberPages:Int/*thumbnail: URL,characterList:[MarvelCharacters]*/) {
        
        self.id = id
        self.title = title
        self.digitalId = digitalId
        self.issueNumber = issueNumber
        self.details = details
        self.numberPages = numberPages
        //self.thumbnail = thumbnail
        //self.characterList = characterList


    }
    

    
    
}
