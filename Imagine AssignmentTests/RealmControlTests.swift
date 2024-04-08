import XCTest
@testable import Imagine_Assignment

class RealmControlTests: XCTestCase {
    
    var realmControl: RealmControl!

    override func setUp() {
        super.setUp()
        realmControl = RealmControl.shared
    }

    override func tearDown() {
        realmControl = nil
        super.tearDown()
    }

    // Test adding a favorite
    func testAddFavorite() {
        // Create a sample search result
        let searchResult = SearchResult(id: "JMFnkekdFIyFGaw2c2", source: "https://sketchmachine.net", title: "GIF by Sketch Machine", rating: "g", images: Images(downsized: Downsized(width: "512", height: "512", url: "https://media2.giphy.com/media/JMFnkekdFIyFGaw2c2/giphy.gif?cid=389012344xhq4l0tvahojcj8b8kneklllrnq4zzeucgyabf3&ep=v1_gifs_random&rid=giphy.gif&ct=g")), slug: "sketchmachine-JMFnkekdFIyFGaw2c2", type: "gif", url: "https://giphy.com/gifs/sketchmachine-JMFnkekdFIyFGaw2c2", user: User(description: "The Sketch Machine wants you to draw; it's waiting for you! Sketch Machine was created by Casey REAS with help from GIPHY."))

        // Add the sample search result as favorite
        realmControl.addFavorite(searchResultss: searchResult)

        // Retrieve the added favorite from Realm
        let favorite = realmControl.getDataID(id: "JMFnkekdFIyFGaw2c2")

        // Check if the retrieved favorite matches the added one
        XCTAssertEqual(favorite.id, "JMFnkekdFIyFGaw2c2")
        XCTAssertEqual(favorite.source, "https://sketchmachine.net")
        // Add more assertions for other properties if needed
    }

    // Test retrieving data by ID
    func testGetDataByID() {
        
        // Assuming there is a favorite with id "123" in Realm
        let favorite = realmControl.getDataID(id: "JMFnkekdFIyFGaw2c2")

        // Ensure that the retrieved favorite is not nil
        XCTAssertNotNil(favorite)
        // Add more assertions for other properties if needed
    }

    // Test deleting a favorite
    func testDeleteFavorite() {
   
//          // Attempt to delete the favorite
          realmControl.deleteFavorite(id: "JMFnkekdFIyFGaw2c2")

    }

    // Test updating a favorite
    func testUpdateFavorite() {
        


        // Create a sample SearchResultRealm object
         let searchResultRealm = SearchResultRealm()
         searchResultRealm.id = "JMFnkekdFIyFGaw2c2"



         // Update the favorite
         realmControl.updateFavorite(searchResultRealm: searchResultRealm)

         // Retrieve the updated favorite
         let updatedFavorite = realmControl.getDataID(id: "JMFnkekdFIyFGaw2c2")

         // Check if the favorite is updated as expected
         XCTAssertEqual(updatedFavorite.isFavorite ?? false, false)

    }
    
  
    
    
}
