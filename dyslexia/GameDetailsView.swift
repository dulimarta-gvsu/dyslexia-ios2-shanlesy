//
//  GameDetailsView.swift
//  dyslexia
//
//  Created by Synjin J. Shanley on 2/26/26.
//

import SwiftUI

struct GameDetailsView: View {
    var game: Int
    var word: String
    var points: Int
    var moves: Int
    var time: Int
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .center) {
            // Header Row
            HStack {
                Button("Back") {
                    onBack()
                }
                Spacer()
                Text("Game Details")
            }
            .padding(.horizontal)

            // Game Info Rows
            HStack {
                Text("Game \(game + 1)")
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Text("Word: \(word)")
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Text("Points: \(points)")
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Text("Moves: \(moves)")
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Text("Time: \(time)")
                Spacer()
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.vertical, 50)
    }
}

// MARK: - Preview
struct GameDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailsView(
            game: 1,
            word: "pikachu",
            points: 10,
            moves: 10,
            time: 10,
            onBack: {}
        )
    }
}


