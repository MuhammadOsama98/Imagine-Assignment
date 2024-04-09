
import Foundation
import RealmSwift
import UIKit
import Combine


class RealmControl{
    
    static var shared : RealmControl = {
        let instance = RealmControl()
        return instance
    }()
    
    
    private let realm = try! Realm()

        
    func addFavorite(searchResultss:SearchResult){
   
        

        
        let searchResultRealm = SearchResultRealm()
        
        searchResultRealm.id = searchResultss.id
        searchResultRealm.source = searchResultss.source
        searchResultRealm.title = searchResultss.title
        searchResultRealm.rating = searchResultss.rating
        searchResultRealm.images = searchResultss.images.downsized.url
        searchResultRealm.slug = searchResultss.slug
        searchResultRealm.type = searchResultss.type
        searchResultRealm.user = searchResultss.user?.description ?? ""
        searchResultRealm.url = searchResultss.url
        searchResultRealm.isFavorite = true

        
        let existingObject = realm.objects(SearchResultRealm.self).filter("id == %@", searchResultRealm.id).first

        if existingObject == nil {
            // Data doesn't exist, so you can add it to the Realm
            try! realm.write {
                realm.add(searchResultRealm)
            }
        } else {
            // Data already exists
            print("Data already exists in Realm.")
        }
        
    

        
    }
    
    
    func getDataID(id:String) -> SearchResult {
        let existingObject = realm.objects(SearchResultRealm.self).filter("id == %@", id).first
        
        let searchResult = SearchResult(id: existingObject?.id ?? "", source: existingObject?.source ?? "", title: existingObject?.title ?? "", rating: existingObject?.rating ?? "", images: Images(downsized: Downsized(width: "", height: "", url: existingObject?.images ?? "")), slug: existingObject?.slug ?? "", type: existingObject?.type ?? "", url: existingObject?.url ?? "",user: User(description: existingObject?.user ?? ""))

        return searchResult
    }

    func deleteFavorite(id:String){
        guard let favoriteToDelete = realm.objects(SearchResultRealm.self).filter("id == %@", id).first else {
              // If the favorite doesn't exist, print a message and return
              print("Favorite not found")
              return
          }

          do {
              // Begin a write transaction to delete the favorite
              try realm.write {
                  realm.delete(favoriteToDelete)
              }
              print("Favorite deleted successfully")
          } catch {
              // Handle any errors that occur during the deletion process
              print("Failed to delete favorite: \(error)")
          }
        
    }
    
    
    func updateFavorite(searchResultRealm:SearchResultRealm){
        
        let favoriteToUpdate = realm.objects(SearchResultRealm.self).filter("id == '\(searchResultRealm.id)'").first

        // Check if the person exists before deleting
        if let favoriteToUpdate = favoriteToUpdate {
            try! realm.write {
                
                if favoriteToUpdate.isFavorite == true{
                    favoriteToUpdate.isFavorite = false
                }else{
                    favoriteToUpdate.isFavorite = true

                }

            }
        } else {
            print("Person not found")
        }
        
    }

    
    func fetchTrending<T: Object>(objectType: T.Type) -> [T] {
        let realm = try! Realm()
        let results = realm.objects(T.self)
        return Array(results)
    }
    
    

    
}
