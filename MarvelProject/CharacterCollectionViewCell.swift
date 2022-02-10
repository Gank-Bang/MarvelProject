//
//  CharacterCollectionViewCell.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 14/01/2022.
//

import UIKit
import SwiftyGif


class CharacterCollectionViewCell: UICollectionViewCell {

    var character: MarvelCharacters?
    var task: URLSessionDataTask?
    
    
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        characterImage.clipsToBounds = true;
        characterImage.layer.cornerRadius = 10

    }

    
    func redraw(character: MarvelCharacters){
        self.character = character
        self.characterName.text = character.name
        
        if (character.thumbnail?.pathExtension == "gif") {
            let url = character.thumbnail
            //let realURL = URL(string: url)
            self.characterImage.setGifFromURL(url!)
            self.characterImage.startAnimatingGif()
        }
        else{
            self.download(URL: character.thumbnail!) {err, img in
                DispatchQueue.main.sync {
                    self.characterImage.image = img
                }
            
            }
        }
    }
        
    
    
    
    
    
     func download(URL:URL,completion: @escaping (Error?, UIImage?) -> Void) {

        
        self.task?.cancel()
        let task = URLSession.shared.dataTask(with: URL) { data, res, err in
            
            self.task = nil
            guard err == nil else {
                completion(err,nil)
                return;
            }
            
            guard let d = data else {
                completion(NSError(domain: "com.esgi.album", code: 2, userInfo: [NSLocalizedFailureReasonErrorKey : "No data found"]), nil)
                return
            }
            
            
            guard let img = UIImage(data: d) else {
                completion(NSError(domain: "com.esgi.album", code: 4, userInfo: [NSLocalizedFailureReasonErrorKey : "No image found"]), nil)
                return
            }
            
            completion(nil,img)
            
            
        }
        self.task = task
        task.resume()
    }
    
}
