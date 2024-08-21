import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieViewModel
    let movie: Movie

    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: movie.posterURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .cornerRadius(10)
                } else if phase.error != nil {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal)

            
            Text(movie.title)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal)
                .padding(.top, 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                    Text(movie.year)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.top, 2)

            Spacer()

            
            Button(action: {
                viewModel.toggleLike(for: movie)
            }) {
                HStack {
                    Image(systemName: movie.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(movie.isLiked ? .red : .gray)
                    Text(movie.isLiked ? "Liked" : "Like")
                        .font(.title2)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .frame(maxHeight: .infinity)
        .padding()
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
