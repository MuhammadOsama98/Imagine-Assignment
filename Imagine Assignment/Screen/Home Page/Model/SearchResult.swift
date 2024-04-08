import UIKit


struct ResponseModel : Codable{
    var data: [SearchResult]
}

struct GifDetailModel : Codable{
    var data: SearchResult
}

struct SearchResult : Codable{
    var id: String
    var source : String
    var title: String
    var rating : String
    var images : Images
    var slug:String
    var type:String
    var url:String
    var user: User?
    var isFavorite:Bool?


}
struct User:Codable {

    var description: String?

}

struct Images : Codable{
    var downsized : Downsized
    
}
struct Downsized : Codable{
    var width : String
    var height: String
    var url : String
}
