import Foundation

struct Movie: Decodable, Identifiable {
    let id: String
    let title: String
    let year: String
    let posterURL: String
    var isLiked: Bool = false 

    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case posterURL = "Poster"
    }
}

struct MovieResponse: Decodable {
    let Search: [Movie]
}
