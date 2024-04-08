//
//  SearchResultRealm.swift
//  Imagine Assignment
//
//  Created by Pillars Fintech on 06/04/2024.
//

import RealmSwift

class ResponseModelRealm: Object {
    @Persisted var data: List<SearchResultRealm> = List<SearchResultRealm>()
}

class GifDetailModelRealm: Object {
    @Persisted var data: SearchResultRealm?
}

class SearchResultRealm: Object {
    @Persisted var id: String = ""
    @Persisted var source: String = ""
    @Persisted var title: String = ""
    @Persisted var rating: String = ""
    @Persisted var images:String = ""
    @Persisted var slug: String = ""
    @Persisted var type: String = ""
    @Persisted var url: String = ""
    @Persisted var user: String = ""

    @Persisted var isFavorite: Bool? = false
}

class ImagesRealm: Object {
    @Persisted var downsized: DownsizedRealm?
}

class DownsizedRealm: Object {
    @Persisted var width: String = ""
    @Persisted var height: String = ""
    @Persisted var url: String = ""
}

class UserRealm: Object {
    @Persisted var descriptionText: String?
}
