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
                let alert = UIAlertController(title: "Informations", message: "Votre héros a bien été ajouté", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        else{
            let alert = UIAlertController(title: "Attention", message: "Veuillez entrer tout les champs", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    

    
}
