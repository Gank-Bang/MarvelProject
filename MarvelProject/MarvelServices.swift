//
//  MarvelServices.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 13/01/2022.
//


import Foundation


public class MarvelServices {
    
    class func getCharacters(offset:Int,completion: @escaping(Error?, [MarvelCharacters]?)->Void) {
        var characterList: [MarvelCharacters] = []
        let SearchViewController = SearchViewController()
        //http://gateway.marvel.com/v1/public/characters?ts=1&offset=\(offset)&limit=100&apikey=6e6baf96504028c5180ff86f48cf9b52&hash=e2238c975b6adc162aee7e96eb37e866
        guard let url = URL(string: "http://gateway.marvel.com/v1/public/characters?ts=1&offset=\(offset)&limit=100&apikey=6e6baf96504028c5180ff86f48cf9b52&hash=e2238c975b6adc162aee7e96eb37e866")
        else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data,res,err in
            
            DispatchQueue.main.async {
                
                guard err == nil else
                {
                   // PopUpError.show(message: "Une erreur réseau est survenue",parent: SearchPageViewController)
                    return
                }
                guard let downloadedData = data else
                {
                    return
                }
                guard let json = try? JSONSerialization.jsonObject(with: downloadedData, options: .allowFragments) else
                {
                    return
                }
                guard let todos = json as? [String: Any]  else{
                    return
                }
                guard let data = todos["data"] as? [String:Any] else {
                    return
                }
                guard let results = data["results"] as? [[String: Any]] else {
                    return
                }
                
                for result in results {
                    //let image = result["thumbnail"] as? [String: Any]
                    guard let image = result["thumbnail"] as? [String: Any] else {
                        return
                    }
                    let character = CharacterFactory.createCharacter(from: result)
                    //guard let characterExist = character as? MarvelCharacters else {
                    //    return
                    //}
                    CharacterFactory.addImage(character: character!, from: image)
                    characterList.append(character!)
                }

                
                
                
                completion(err, characterList)
            }
        }
        task.resume() // lance la requete http
         
        
    }
    
    
    class func getComics(offset:Int,completion: @escaping(Error?, [MarvelComics]?)->Void) {
        var comicsList: [MarvelComics] = []
        let SearchViewController = SearchViewController()
        
        guard let url = URL(string: "https://gateway.marvel.com/v1/public/comics?ts=1&offset=\(offset)&limit=100&apikey=6e6baf96504028c5180ff86f48cf9b52&hash=e2238c975b6adc162aee7e96eb37e866")
        else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data,res,err in
            
            DispatchQueue.main.async {
                
                guard err == nil else
                {
                   // PopUpError.show(message: "Une erreur réseau est survenue",parent: SearchPageViewController)
                    return
                }
                guard let downloadedData = data else
                {
                    return
                }
                guard let json = try? JSONSerialization.jsonObject(with: downloadedData, options: .allowFragments) else
                {
                    return
                }
                guard let todos = json as? [String: Any]  else{
                    return
                }
                guard let data = todos["data"] as? [String:Any] else {
                    return
                }
                guard let results = data["results"] as? [[String: Any]] else {
                    return
                }
                
                for result in results {
                    //let image = result["thumbnail"] as? [String: Any]
                    guard let image = result["thumbnail"] as? [String: Any] else {
                        return
                    }
                    guard let characters = result["characters"] as? [String: Any] else {
                        return
                    }
                    guard let nameCharacters = characters["items"] as? [[String: Any]] else {
                        return
                    }
                    
                    let comic = ComicsFactory.createComics(from: result)
                    guard let comicExist = comic as? MarvelComics else {
                        return
                    }
                    ComicsFactory.addImage(comic: comicExist, from: image)
                    
                    for character in nameCharacters {
                        let name = ComicsFactory.getCharacters(comic: comic!, from: character)
                        comic?.listNames?.append(name)
                    }
                    
                    comicsList.append(comic!)

                    
                    
                    
                }

                
                
                
                completion(err, comicsList)
            }
        }
        task.resume() // lance la requete http
         
        
    }
    
    class func getOurCharacters(completion: @escaping(Error?, [OurHeroes]?)->Void) {
        var characterList: [OurHeroes] = []
        let SearchViewController = SearchViewController()
        
        guard let url = URL(string: "https://esgi-marvel-app.herokuapp.com/getheros")
        else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data,res,err in
            
            DispatchQueue.main.async {
                
                guard err == nil else
                {
                   // PopUpError.show(message: "Une erreur réseau est survenue",parent: SearchPageViewController)
                    return
                }
                guard let downloadedData = data else
                {
                    return
                }
                guard let json = try? JSONSerialization.jsonObject(with: downloadedData, options: .allowFragments) else
                {
                    return
                }
                guard let todos = json as? [String: Any]  else{
                    return
                }
                guard let datas = todos["heros"] as? [[String:Any]] else {
                    return
                }
                for data in datas {
                    let character = CharacterFactory.createOurCharacter(from: data)
                    characterList.append(character!)
                }

                completion(err, characterList)
            }
        }
        task.resume() // lance la requete http
         
        
    }
    

}
