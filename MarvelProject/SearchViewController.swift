//
//  SearchViewController.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 13/01/2022.
//

import UIKit


class SearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate{

    
    

    var listComics:[MarvelComics] = []
    var cellList:[CharacterCollectionViewCell] = []
    var numberOfRow:Int = 0
    var appelApi = [0,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500]
    @IBOutlet weak var listCharacters: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    var characters: [MarvelCharacters] = []{
        didSet {
            self.listCharacters.reloadData()
        }
    }
    
    var characterSearch: [MarvelCharacters] = []{
        didSet {
            self.listCharacters.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://c.tenor.com/_IT4iiUqkw4AAAAC/homer-simpson-les-simpson.gif")
        let loader = UIActivityIndicatorView(style: .white)
        self.loadingImage.setGifFromURL(url!, customLoader: loader)

        //self.loadingImage.isHidden = true
        self.listCharacters.isHidden = true
        self.searchBar.isHidden = true

        for i in appelApi{
            MarvelServices.getCharacters(offset: i) { err, characters in
                guard err == nil else {
                    return
                }
            MarvelServices.getComics(offset: i) { err, comics in
                    guard err == nil else {
                        return
                    }
                
                
                let allComics = comics
                let allCharacters = characters
                DispatchQueue.main.async {
                    
                    for k in allComics!{
                        self.listComics.append(k)
                    }
                    
                    
                    for j in allCharacters!{
                        //print(j.id)
                        for z in self.listComics{
                            if ((z.listNames?.contains(j.name)) != false) {
                                j.comics?.append(z)
                            }
                            else{
                                
                            }
                        }
                        self.characters.append(j)
                        self.characterSearch.append(j)
                    }
                }
            }
            }
        }
    
        
        
        self.searchBar.delegate = self
        self.listCharacters.delegate = self
        self.listCharacters.dataSource = self
        let CharacterCellNib = UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
        self.listCharacters.register(CharacterCellNib, forCellWithReuseIdentifier: "CharacterCell")
        
        
        
    }
    
    //override func viewWillAppear(_ animated: Bool) {
       // self.loadingImage.isHidden = true
       // self.listCharacters.isHidden = false
   // }
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characterSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.numberOfRow += 1
        
        if numberOfRow == 5{
            self.loadingImage.isHidden = true
            self.listCharacters.isHidden = false
            self.searchBar.isHidden = false
        }
        print(numberOfRow)
        
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell

            let character = self.characterSearch[indexPath.row]
            

            cell.characterImage.setImage(at: character.thumbnail!, placeholderImage: UIImage(named: "marvelLoader.gif"), errorImage: UIImage(named: "marvelLoader.gif"))
            cell.characterName.text = character.name
            /*cell.redraw(character: character)
            print(character.thumbnail?.pathExtension)
            print(character.name)*/
        
            return cell
        }

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell:CharacterCollectionViewCell = self.listCharacters.cellForItem(at: indexPath) as! CharacterCollectionViewCell
        let character = self.characterSearch[indexPath.row]
        
        let CharacterViewController = CharacterViewController.newInstance(cell: cell, character: character)
        self.navigationController?.pushViewController(CharacterViewController, animated: true)
        print(character.name)
        print(character.thumbnail)
        print(character.id)
        //print(character.comics![1])
        print(self.listComics[1].listNames)
        print(character.thumbnail?.pathExtension)
        print(character.id)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("\(searchText)")

        let searchTextLowerCase = searchText.lowercased()
        guard !searchText.isEmpty else {
           characterSearch = characters
            listCharacters.reloadData()
            return
        }
        characterSearch = characters.filter({ character -> Bool in
            //return (character.name.contains(searchTextLowerCase) || character.name.contains(searchText))
            //return character.name.localizedCaseInsensitiveContainsString(searchText)
            //character.name.localizedCaseInsensitiveContainsString(searchText)
            if let range3 = character.name.range(of: searchText, options: .caseInsensitive) {
                return true
                listCharacters.reloadData()
            } else {
                return false
                listCharacters.reloadData()
            }
            
        })
        listCharacters.reloadData()
        }
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    

    @IBAction func pressAddButton(_ sender: Any) {
        self.navigationController?.pushViewController(AddViewController(), animated: true)
        
    }
    

}
