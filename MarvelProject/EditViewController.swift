//
//  EditViewController.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 01/03/2022.
//

import UIKit
import Alamofire

class EditViewController: UIViewController {

    @IBOutlet weak var newNameField: UITextField!
    @IBOutlet weak var newDescriptionField: UITextField!
    @IBOutlet weak var newImageField: UITextField!
    
    var character: String!
    var cellChoosed: CharacterCollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    static func newInstance(cell:CharacterCollectionViewCell,character:OurHeroes) -> EditViewController {

        let EditViewController = EditViewController()
        EditViewController.character = character.name
        EditViewController.cellChoosed = cell
        
        return EditViewController
    }


    @IBAction func pressEditButton(_ sender: Any) {
        guard let name = self.character,
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
                                                     
                                                     let alert = UIAlertController(title: "Informations", message: "Les données ont bien été modifié", preferredStyle: UIAlertController.Style.alert)
                                                     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                                     self.present(alert, animated: true, completion: nil)
                                                     
                                                 }
                                         }
                                        
                                     }
                                }
                                    
                            case .failure(let error):
                                print(error)
                        }
                    }
          
        
        
    }
    
}
