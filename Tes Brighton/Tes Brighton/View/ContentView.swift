import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var sortOption: SortOption = .title
    @State private var selectedTab = 0

    enum SortOption: String, CaseIterable, Identifiable {
        case title = "Title"
        case year = "Year"

        var id: String { self.rawValue }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MoviesListView(viewModel: viewModel, sortOption: $sortOption, showingFavorites: false)
                    .navigationTitle("Movies")
                    .navigationBarTitleDisplayMode(.inline)
                    .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
                    .onAppear {
                        viewModel.fetchMovies()
                    }
            }
            .tabItem {
                Image(systemName: "film.fill")
                Text("Movies")
            }
            .tag(0)

            NavigationView {
                MoviesListView(viewModel: viewModel, sortOption: $sortOption, showingFavorites: true)
                    .navigationTitle("Favorites")
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        viewModel.fetchMovies()
                    }
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("Favorites")
            }
            .tag(1)

            Text("Tickets Page")
                .tabItem {
                    Image(systemName: "ticket.fill")
                    Text("Tickets")
                }
                .tag(2)

            Text("Profile Page") 
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
    }
}

struct MoviesListView: View {
    @ObservedObject var viewModel: MovieViewModel
    @Binding var sortOption: ContentView.SortOption
    var showingFavorites: Bool // Removed @Binding

    var body: some View {
        VStack {
            Picker("Sort By", selection: $sortOption) {
                ForEach(ContentView.SortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            List(sortedMovies) { movie in
                NavigationLink(destination: MovieDetailView(viewModel: viewModel, movie: movie)) {
                    HStack(alignment: .top) {
                        AsyncImage(url: URL(string: movie.posterURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 150)
                                    .clipped()
                                    .cornerRadius(10)
                            } else if phase.error != nil {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 150)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            } else {
                                ProgressView()
                                    .frame(width: 100, height: 150)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.trailing, 10)

                        VStack(alignment: .leading, spacing: 5) {
                            Text(movie.title)
                                .font(.headline)
                                .multilineTextAlignment(.leading)
                                .lineLimit(2)

                            Text(movie.year)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 5)
                    }
                    .padding(.vertical, 5)
                }
            }
            .listStyle(PlainListStyle())
        }
    }

    private var sortedMovies: [Movie] {
        if showingFavorites {
            return viewModel.favoriteMovies // Assuming you have a favoriteMovies property
        }
        
        switch sortOption {
        case .title:
            return viewModel.filteredMovies.sorted { $0.title < $1.title }
        case .year:
            return viewModel.filteredMovies.sorted { $0.year < $1.year }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
