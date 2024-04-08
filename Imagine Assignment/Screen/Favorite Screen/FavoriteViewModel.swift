//
//  FavoriteViewModel.swift
//  Imagine Assignment
//
//  Created by Pillars Fintech on 06/04/2024.
//

import Foundation
import RealmSwift

class FavoriteViewModel{
    
    weak var favoriteCoordinator:FavoriteCoordinator?
    
    private let realmControl = RealmControl()

    
    init(){
        
    }
    
    
    var searchResults : [SearchResultRealm] = []

    
    
    func fetchTrending(){
        searchResults = realmControl.fetchTrending(objectType: SearchResultRealm.self)
    }
    
    func goToBack(){
        favoriteCoordinator?.backHome()
    }
}

