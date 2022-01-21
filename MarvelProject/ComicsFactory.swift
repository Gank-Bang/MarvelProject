//
//  ComicsFactory.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 18/01/2022.
//

import Foundation

class ComicsFactory {
    
    
    class func createComics(from dict: [String: Any]) -> MarvelComics? {
        
        let details = dict["description"] as? String ?? ""
        
        guard let id = dict["id"] as? Int,
              let title = dict["title"] as? String,
              //let thumbnail = dict["path"] as? String?,
              let issueNumber = dict["issueNumber"] as? Int,
              let numberPages = dict["pageCount"] as? Int,
              //let characterList = dict["characters"] as? String?,
              //let ressourceURL = dict["RessourceURI"] as? String,
              let digitalId = dict["digitalId"] as? Int
        else {
                  return nil

              }
        
        return MarvelComics(id: id, title: title,digitalId: digitalId,issueNumber:issueNumber,details:details,numberPages:numberPages//,thumbnail: URL,characterList:[MarvelCharacters]
        )
    }
    
    
    class func addImage(comic:MarvelComics,from dict: [String: Any]) -> Void{
        var thumbnail = dict["path"] as! String
        //var i = thumbnail.index(thumbnail.startIndex, offsetBy: 4)
        //thumbnail.insert("s", at: i)
        var imageFormat = dict["extension"] as! String
        let lien = "\(thumbnail).\(imageFormat)"
        let lienComplete = URL(string: lien)

        
        comic.thumbnail = lienComplete
        //print(comic.details)
        //print(comic.id)
    }
    
    
    class func getCharacters(comic:MarvelComics,from dict: [String: Any]) -> String{
        let name = dict["name"] as! String
        let realName = ("\(name)")
        //comic.listNames?.append(realName)
        //print(name)
        return realName
    }
    
    
    
    
}
