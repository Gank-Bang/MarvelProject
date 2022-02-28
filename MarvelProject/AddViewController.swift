//
//  AddViewController.swift
//  MarvelProject
//
//  Created by Yvan Sifre on 22/02/2022.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descField: UITextField!
    @IBOutlet weak var imageField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var deleteNameField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBOutlet weak var heroToEditField: UITextField!
    @IBOutlet weak var newNameField: UITextField!
    @IBOutlet weak var newDescriptionField: UITextField!
    @IBOutlet weak var newImageField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pressAddButton(_ sender: Any) {
        guard let name = self.nameField.text,
              let description = self.descField.text,
              let imageURL = self.imageField.text else{
                  return
              }
        
        let parameters: [String: Any?] = [
            "name": name,
            "description": description,
            "image": imageURL,
        ]
        if(!name.isEmpty && !description.isEmpty && !imageURL.isEmpty){
            AF.request("https://esgi-marvel-app.herokuapp.com/addhero", method:.post, parameters: parameters as Parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
                    print(response)
            }
        }
        
    }
    
    
    @IBAction func pressDeleteButton(_ sender: Any) {
        guard let name = self.deleteNameField.text else{
            return
        }
        AF.request("https://esgi-marvel-app.herokuapp.com/getheros", method:.get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                switch response.result {
                    
                    case.success(let data):
                    
                        if let itemJson = data as? Dictionary<String,Any>,
                           let items = itemJson["heros"] as? [[String:Any]] {
                             for item in items {
                                 let nameHero = item["heroname"] as? String
                                 
                                 if(name == nameHero){
                                     print(nameHero ?? "n/a")
                                     let id = item["_id"] as! String
                                     print(id ?? "n/a")
                                     AF.request("https://esgi-marvel-app.herokuapp.com/heros/\(id)", method:.delete)
                                         .responseJSON { (response) in
                                             print(response)}
                                 }
                                
                             }
                        }
                            
                    case .failure(let error):
                        print(error)
                }
            }
    }
    
    
    @IBAction func pressEditButton(_ sender: Any) {
        guard let name = self.heroToEditField.text,
              let newName = self.newNameField.text,
              let newDesc = self.newDescriptionField.text,
              let newImage = self.newImageField.text else{
            return
        }
        
        let parameters: [String: Any?] = [
            "heroname": newName,
            "description": newDesc,
            "image": newImage,
        ]
        
        AF.request("https://esgi-marvel-app.herokuapp.com/getheros", method:.get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                switch response.result {
                    
                    case.success(let data):
                    
                        if let itemJson = data as? Dictionary<String,Any>,
                           let items = itemJson["heros"] as? [[String:Any]] {
                             for item in items {
                                 let nameHero = item["heroname"] as? String
                                 
                                 if(name == nameHero && !newName.isEmpty && !newDesc.isEmpty && !newImage.isEmpty){
                                     let id = item["_id"] as! String
                                     AF.request("https://esgi-marvel-app.herokuapp.com/hero/\(id)", method:.patch, parameters: parameters as Parameters, encoding: JSONEncoding.default)
                                         .responseJSON { (response) in
                                             print(response)}
                                 }
                                
                             }
                        }
                            
                    case .failure(let error):
                        print(error)
                }
            }
        
    }
    
}
