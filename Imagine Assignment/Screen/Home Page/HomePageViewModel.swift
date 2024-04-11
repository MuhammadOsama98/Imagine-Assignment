import Foundation
import Combine
import RealmSwift

class HomePageViewModel{

weak var homePageCoordinator:HomePageCoordinator?

// Properties for pagination
var currentPage = 1
var pageSize = 20
var isFetching = false
    
// Property to hold error message
 var errorMessage: String? {
     didSet {
         errorOccurred?(errorMessage)
     }
 }
     
// Closure to notify view about error occurrence
var errorOccurred: ((String?) -> Void)?

// Publisher for count of favorite items
@Published var favoriteItemCount: Int = 0

let realmControl = RealmControl()

    
init() {}
    
func goToItemDetails(gifId:String){
    homePageCoordinator?.toItemDetailsScreen(gifId: gifId)
}

    
//other options include delegate patterns, publlished vars
var apiResultUpdated:()->Void = {}

let apiClient = GifAPIClient()

var searchResults : [SearchResult] = []
    
    

func countItemFavoriteUpdate() -> AnyPublisher<[SearchResultRealm], Error> {
    
    return Future<[SearchResultRealm], Error> { promise in
        do {
            let objects = self.realmControl.fetchTrending(objectType: SearchResultRealm.self)
            promise(.success(objects))
        } catch {
            promise(.failure(error))
        }
    }
    .eraseToAnyPublisher()
}
    

  
func fetchTrending() {
    // Return if already fetching
   guard !isFetching else { return }
   
   isFetching = true
   
   apiClient.requestTrendingGifs(page: currentPage, pageSize: pageSize) { [weak self] searchResults, error in
       guard let self = self else { return }
       self.isFetching = false
       
       if let error = error {
           self.errorMessage = "Error fetching trending GIFs: \(error.localizedDescription)"
           print("Error: \(error)")
       } else {
           if let results = searchResults {
               if results.meta.status != 200 {
                   self.errorMessage = " \(results.meta.msg)"
               }else{
                   // Append new results to existing ones
                   self.searchResults.removeAll()
                   self.searchResults.append(contentsOf: results.data)
                   self.apiResultUpdated()
                   self.currentPage += 1
               }
  
           }
       }
   }
}
       
func searchGif(query: String) {
   guard !isFetching else { return }
    
   isFetching = true
   
   apiClient.requestSearchGifs(query: query, page: currentPage, pageSize: pageSize) { [weak self] searchResults, error in
       guard let self = self else { return }
       self.isFetching = false
       
       if let error = error {
           self.errorMessage = "Error searching GIFs: \(error.localizedDescription)"
           print("Error: \(error)")
       } else {
           if let results = searchResults {
               
 
               self.searchResults.removeAll()
               self.searchResults.append(contentsOf: results)
               self.apiResultUpdated()
               self.currentPage += 1
           }
       }
   }
}
    
}
