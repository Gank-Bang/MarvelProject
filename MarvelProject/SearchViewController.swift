//
//  SearchViewController.swift
//  MarvelProject
//
//  Created by Rafiq Messai on 13/01/2022.
//

import UIKit

class SearchViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate, UICollectionViewDataSourcePrefetching {

    
    


    var cellList:[CharacterCollectionViewCell] = []
    var numberOfRow:Int = 0
    var appelApi = [0,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500]
    @IBOutlet weak var listCharacters: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingImage: UIImageView!
    
    
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
        
        self.listCharacters.isHidden = true

        for i in appelApi{
            MarvelServices.getCharacters(offset: i) { err, characters in
                guard err == nil else {
                    return
                }

                let allCharacters = characters
                DispatchQueue.main.async {
                    for j in allCharacters!{
                        //print(j.id)
                        MarvelServices.getComics(id: j.id) { err, comics in
                            guard err == nil else {
                                return
                            }
                        j.comics = comics
                        }

                        self.characters.append(j)
                        self.characterSearch.append(j)
                    }
                }
            }
        }
        
        
        self.searchBar.delegate = self
        self.listCharacters.delegate = self
        self.listCharacters.dataSource = self
        self.listCharacters.prefetchDataSource = self
        let CharacterCellNib = UINib(nibName: "CharacterCollectionViewCell", bundle: nil)
        self.listCharacters.register(CharacterCellNib, forCellWithReuseIdentifier: "CharacterCell")
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadingImage.isHidden = true
        self.listCharacters.isHidden = false
    }
    
    

    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.characterSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //self.numberOfRow += 1
        
        //if numberOfRow == 10{
            //self.loadingImage.isHidden = true
            //self.listCharacters.isHidden = false
        //}
        //print(numberOfRow)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCollectionViewCell
        let character = self.characterSearch[indexPath.row]
        cell.redraw(character: character)
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
    
 
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])  {
        

            for indexPath in indexPaths {
                let model = self.characterSearch[indexPath.row]
               }
            
        
    }

    
}
