//
//  HomePageViewModel.swift
//  Imagine Assignment
//
//  Created by Pillars Fintech on 04/04/2024.
//

import Foundation
import RealmSwift


class HomePageViewModel{
    
    
    
    weak var homePageCoordinator:HomePageCoordinator?
    
    // Property to hold error message
     var errorMessage: String? {
         didSet {
             errorOccurred?(errorMessage)
         }
     }
     
     // Closure to notify view about error occurrence
     var errorOccurred: ((String?) -> Void)?
     
     init() {
         
     }
    
    func goToItemDetails(gifId:String){
        homePageCoordinator?.toItemDetailsScreen(gifId: gifId)
    }
    
    
    //other options include delegate patterns, publlished vars
    var apiResultUpdated:()->Void = {}
    
    let apiClient = GifAPIClient()
    
    var searchResults : [SearchResult] = []
    
    
    
    
    func fetchTrending(){
         apiClient.requestTrendingGifs { searchResults,error  in
             if let error = error {
                 // Update error message
                 self.errorMessage = "Error fetching trending GIFs: \(error.localizedDescription)"
                 print("Error: \(error)")
             } else {
                 self.searchResults = searchResults ?? []
                 self.apiResultUpdated()
             }
         }
     }
     
     func searchGif(query:String){
         apiClient.requestSearchGifs(query: query) { searchResults,error  in
             if let error = error {
                 // Update error message
                 self.errorMessage = "Error searching GIFs: \(error.localizedDescription)"
                 print("Error: \(error)")
             } else {
                 self.searchResults = searchResults ?? []
                 self.apiResultUpdated()
             }
         }
     }
    
    
}
