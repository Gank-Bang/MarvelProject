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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.text = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg"
        
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
            AF.request("https://esgi-marvel-app-new.herokuapp.com/addhero", method:.post, parameters: parameters as Parameters,encoding: JSONEncoding.default) .responseJSON { (response) in
                let alert = UIAlertController(title: "Informations", message: "Votre héros a bien été ajouté", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else{
            let alert = UIAlertController(title: "Attention", message: "Veuillez entrer tout les champs", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    

    
}
