import Foundation



class ItemDetailViewModel{
    var apiResultUpdated:()->Void = {}
    
    let apiClient = GifAPIClient()
    
    var gifDetails : SearchResult?
    
    weak var itemDetailCoordinator:ItemDetailCoordinator?
    
    var gifId:String?
    
    // Property to hold error message
     var errorMessage: String? {
         didSet {
             errorOccurred?(errorMessage)
         }
     }
     
     // Closure to notify view about error occurrence
     var errorOccurred: ((String?) -> Void)?
    
    
    func BackHome(){
        itemDetailCoordinator?.backToHome()
    }
    func backFavoriteItem(){
        itemDetailCoordinator?.backFavoriteItem()
    }

    func fetchGifDetails(){
        
        guard let gifId = self.gifId else{
            return
        }
        
        apiClient.requestGifDetails(id: gifId) { result,error  in
            
            if let error = error {
                 // Handle error
                 print("Error: \(error)")
                self.errorMessage = "Error fetching trending GIFs: \(error.localizedDescription)"
             } else {
                 // Use gifs
                 self.gifDetails = result
                 self.apiResultUpdated()
             }
    
        }
    }
}
