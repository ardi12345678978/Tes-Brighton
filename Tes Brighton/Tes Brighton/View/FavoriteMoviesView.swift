import SwiftUI

struct FavoriteMoviesView: View {
    @ObservedObject var viewModel: MovieViewModel

    var body: some View {
        NavigationView {
            List(viewModel.favoriteMovies) { movie in
                NavigationLink(destination: MovieDetailView(viewModel: viewModel, movie: movie)) {
                    HStack {
                        AsyncImage(url: URL(string: movie.posterURL)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 120)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            } else if phase.error != nil {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 120)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            } else {
                                ProgressView()
                                    .frame(width: 80, height: 120)
                                    .background(Color.gray.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.trailing, 10)

                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                                .fontWeight(.bold)
                            Text(movie.year)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
            }
            .navigationTitle("Favorite Movies")
        }
    }
}

struct FavoriteMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteMoviesView(viewModel: MovieViewModel())
    }
}
