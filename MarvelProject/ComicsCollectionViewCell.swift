//
//  ComicsCollectionViewCell.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 21/01/2022.
//

import UIKit

class ComicsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var comicTitle: UILabel!
    @IBOutlet weak var comicImage: UIImageView!
    
    var task: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func redraw(comic: MarvelComics){
        
        self.comicTitle.text = comic.title
        self.download(URL: comic.thumbnail!) {err, img in
            DispatchQueue.main.sync {
                self.comicImage.image = img
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
