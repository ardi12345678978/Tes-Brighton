import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var filteredMovies: [Movie] = []
    @Published var favoriteMovies: [Movie] = []

    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .combineLatest($movies)
            .map { searchText, movies in
                if searchText.isEmpty {
                    return movies
                } else {
                    return movies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
                }
            }
            .assign(to: &$filteredMovies)

        $movies
            .map { movies in
                movies.filter { $0.isLiked }
            }
            .assign(to: &$favoriteMovies)
    }

    func fetchMovies() {
        guard let url = URL(string: "https://www.omdbapi.com/?s=movie&apikey=6e414c4e") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .map { $0.Search }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.movies = movies
                self?.filteredMovies = movies
                print("Movies: \(movies)")
            }
            .store(in: &cancellables)
    }

    func toggleLike(for movie: Movie) {
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isLiked.toggle()
            filteredMovies = movies // Update filtered list
        }
    }
}
