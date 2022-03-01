//
//  CharacterViewController.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 16/01/2022.
//

import UIKit
import Alamofire

class OurCharacterViewController: UIViewController{
    
    @IBOutlet weak var buttonDelete: UIButton!
    //@IBOutlet weak var ComicsView: UICollectionView!
    @IBOutlet weak var buttonMenu: UIButton!
    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var detailsCharacter: UITextView!
    @IBOutlet weak var nameCharacter: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageURL: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    var character: OurHeroes!
    var cellChoosed: CharacterCollectionViewCell!
    
    var oldName:String = ""
    
    static func newInstance(cell:CharacterCollectionViewCell,character:OurHeroes) -> OurCharacterViewController {

        let OurCharacterViewController = OurCharacterViewController()
        OurCharacterViewController.character = character
        OurCharacterViewController.cellChoosed = cell
        
        return OurCharacterViewController
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailsCharacter.isEditable = false
        self.nameCharacter.isEditable = false
        self.imageURL.isEditable = false
        self.imageCharacter.image = self.cellChoosed.characterImage.image
        self.detailsCharacter.text = self.character.details
        self.nameCharacter.text = self.character.name
        self.imageCharacter.layer.cornerRadius = 10
        self.saveButton.isHidden = true
        self.imageURL.isHidden = true
        self.oldName = self.character.name
        self.saveButton.layer.cornerRadius = 10
        //self.ComicsView.isHidden = true
        
        //if (character.thumbnail?.pathExtension == "gif") {
        //    let url = character.thumbnail
        //    self.imageCharacter.setGifFromURL(URL(string: url!)!)
        //    self.imageCharacter.startAnimatingGif()
        
        //}
        
        
        //Initialisation du menu de selection
        
        let optionsClosure = { (action: UIAction) in
          print(action.title)
        }
        
        let usersItem = UIAction(title: "Description", image: UIImage(systemName: "person.text.rectangle")) { (action) in
            self.detailsCharacter.isHidden = false
            //self.ComicsView.isHidden = true
            }
        
            let addUserItem = UIAction(title: "Comics", image: UIImage(systemName: "books.vertical")) { (action) in
                self.detailsCharacter.isHidden = true
                //self.ComicsView.isHidden = false
                
            }
            let menu = UIMenu(title: "Categorie", options: .displayInline, children: [usersItem , addUserItem ])
        
        self.buttonMenu.menu = menu
        buttonMenu.showsMenuAsPrimaryAction = true
        
        
        //self.ComicsView.delegate = self
        //self.ComicsView.dataSource = self
        //let CharacterCellNib = UINib(nibName: "ComicsCollectionViewCell", bundle: nil)
        //self.ComicsView.register(CharacterCellNib, forCellWithReuseIdentifier: "ComicsCell")

    }

    
    

    @IBAction func deleteButton(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Attention", message: "Souhaitez vous vraiment supprimer ce héros ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertAction.Style.default, handler: nil))
        
        
        alert.addAction(UIAlertAction(title: "Oui", style: .default, handler: {
            
            UIAlertAction in
            
            guard let name = self.nameCharacter.text else{
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
            
            self.navigationController?.popViewController(animated: false)
         
            
        }))
        
        self.present(alert, animated: true, completion: nil)
            
        
    }
    
    
    @IBAction func pressSaveButton(_ sender: Any) {
        self.detailsCharacter.isEditable = false
        self.nameCharacter.isEditable = false
        self.imageURL.isEditable = false
        
        guard let newName = self.nameCharacter?.text,
              let newDesc = self.detailsCharacter.text,
              let newImage = self.imageURL.text else{
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
                                 
                                 if(self.oldName == nameHero && !newName.isEmpty && !newDesc.isEmpty && !newImage.isEmpty){
                                     let id = item["_id"] as! String
                                     AF.request("https://esgi-marvel-app.herokuapp.com/hero/\(id)", method:.patch, parameters: parameters as Parameters, encoding: JSONEncoding.default)
                                         .responseJSON { (response) in
                                             let alert = UIAlertController(title: "Informations", message: "Les données ont bien été modifié", preferredStyle: UIAlertController.Style.alert)
                                             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                             self.present(alert, animated: true, completion: nil)
                                             self.imageURL.isHidden = true
                                             self.imageCharacter.image = self.cellChoosed.characterImage.image
                                             self.imageCharacter.isHidden = false
                                         }
                                     
                                         
                                 }
                                 else if(newName.isEmpty || newDesc.isEmpty || newImage.isEmpty) {
                                     let alert = UIAlertController(title: "Attention", message: "Veuillez entrer tout les champs", preferredStyle: UIAlertController.Style.alert)
                                     alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                     self.present(alert, animated: true, completion: nil)
                                 }
                                
                             }
                        }
                            
                    case .failure(let error):
                        print(error)
                }
            }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        /*let EditViewController = EditViewController.newInstance(cell:self.cellChoosed, character: self.character)
        self.navigationController?.pushViewController(EditViewController, animated: true)*/
        self.detailsCharacter.isEditable = true
        self.nameCharacter.isEditable = true
        self.saveButton.isHidden = false
        self.imageURL.isHidden = false
        self.imageURL.isEditable = true
        self.imageCharacter.isHidden = true
        
        
    }
    
}
