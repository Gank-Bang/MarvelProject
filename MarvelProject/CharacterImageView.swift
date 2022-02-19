//
//  CharacterImageView.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 10/02/2022.
//

import Foundation
import UIKit
import CryptoKit

class CharacterImageView: UIImageView {
    
    fileprivate var imageDownloader = CharacterImageDownloader()
    
    public func setImage(at URL: URL, placeholderImage: UIImage?, errorImage: UIImage?) -> Void {
        self.setImage(with: URLRequest(url: URL), placeholderImage: placeholderImage, errorImage: errorImage)
    }
    
    public func setImage(with request: URLRequest, placeholderImage: UIImage?, errorImage: UIImage?) -> Void {
        self.image = placeholderImage;
        self.imageDownloader.downloadImage(with: request) { err, img in
            DispatchQueue.main.sync {
                guard err == nil else {
                    self.image = errorImage;
                    return;
                }
                MOCImageCache.shared.store(image: img!, at: request.url!) { err in
                    print(err)
                }
                self.image = img
            }
        }
    }
 
}

fileprivate class CharacterImageDownloader {
 
    var task: URLSessionDataTask?

    public func downloadImage(with request: URLRequest, completion: @escaping (Error?, UIImage?) -> Void) -> Void {
        self.task?.cancel()
        let task = URLSession.shared.dataTask(with: request) { data, res, err in
            self.task = nil
            guard err == nil else {
                completion(err, nil)
                return;
            }
            guard let d = data else {
                completion(NSError(domain: "com.moc.image", code: 2, userInfo: [
                    NSLocalizedFailureReasonErrorKey: "No data found"
                ]), nil)
                return
            }
            guard let img = UIImage(data: d) else {
                completion(NSError(domain: "com.moc.image", code: 4, userInfo: [
                    NSLocalizedFailureReasonErrorKey: "No image found"
                ]), nil)
                return
            }
            completion(nil, img)
        }
        self.task = task
        task.resume() // démarrer la requete
    }
}

fileprivate class MOCImageCache {
        
    static var shared = MOCImageCache()
    private var cache: [[String: Any]]?
    
    private init() {
        self.loadCache { cache in
            self.cache = cache
        }
    }
    
    func store(image: UIImage, at URL: URL, completion: (Error?) -> Void) {
        let URLString = URL.absoluteString
        let indexOf = self.indexOf(URL: URLString)
        if indexOf != -1 { // Si cache exists
        }
        let fileName = self.URLStringToFilename(URLString)
        self.cache?.append([
            "URL": URLString,
           // "date": Date(),
            "file": fileName
        ])
        self.saveCache(self.cache!) { err in
            print(err)
        }
    }
    
    private func URLStringToFilename(_ URL: String) -> String {
        let hashed = SHA256.hash(data: URL.data(using: .utf8)!)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    private func indexOf(URL: String) -> Int {
        return self.cache?.firstIndex(where: { obj in
            guard let cacheURL = obj["URL"] as? String else {
                return false
            }
            return URL == cacheURL
        }) ?? -1
    }
    
    private func getDocumentPath() -> URL? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        guard urls.count > 0 else {
            return nil
        }
        return urls[0]
    }
    
    private func getImageCachePath() -> URL? {
        guard let documentPath = self.getDocumentPath() else {
            return nil
        }
        return URL(string: "image-cache.json", relativeTo: documentPath)
    }
    
    private func saveCache(_ cache: [[String: Any]], completion: @escaping (Error?) -> Void) {
        guard let jsonURL = self.getImageCachePath() else {
            completion(NSError(domain: "com.moc.cache", code: 1, userInfo: [
                NSLocalizedFailureReasonErrorKey: "Cannot retrieves local path"
            ]))
            return
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: cache, options: .fragmentsAllowed)
            try data.write(to: jsonURL)
        } catch {
            completion(NSError(domain: "com.moc.cache", code: 2, userInfo: [
                NSLocalizedFailureReasonErrorKey: "Cannot convert json to data"
            ]))
        }
        
    }
    
    private func loadCache(completion: @escaping ([[String: Any]]) -> Void) {
        guard let jsonURL = self.getImageCachePath() else {
            completion([])
            return
        }
        do {
            let data = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            guard let cache = json as? [[String : Any]] else {
                completion([])
                return
            }
            completion(cache)
        } catch {
            completion([])
        }
    }
}
