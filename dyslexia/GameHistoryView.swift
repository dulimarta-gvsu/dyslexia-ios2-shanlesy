//
//  GameHistoryView.swift
//  dyslexia
//
//  Created by Synjin J. Shanley on 2/26/26.
//

import SwiftUI

struct GameHistoryView: View {
    @ObservedObject var viewModel: AppViewModel
    var onDetails: (Int, String, Int, Int, Int) -> Void
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .center) {
            // Header Row
            HStack {
                Button("Back") {
                    onBack()
                }
                Spacer()
                Text("Game History")
            }
            .padding(.vertical, 50)
            .padding(.horizontal)

            // Sort Buttons
            HStack {
                Button("By Word") { viewModel.sortByWord() }
                    .buttonStyle(.bordered)
                Button("By Moves") { viewModel.sortByMoves() }
                    .buttonStyle(.bordered)
                Button("By Time") { viewModel.sortByTime() }
                    .buttonStyle(.bordered)
                Button("By Round") { viewModel.sortByIndex() }
                    .buttonStyle(.bordered)
                Button("By Score") { viewModel.sortByScore() }
                    .buttonStyle(.bordered)
            }
            .padding(.horizontal, 4)

            // Column Headers
            HStack {
                Text("Game")
                Spacer()
                Text("Word")
                Spacer()
                Text("Score")
            }
            .padding(.horizontal)
            .background(Color.white)

            // Game History List
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.gameHistory) { record in
                        HStack {
                            Text("Game \(record.index + 1)")
                            Spacer()
                            Text(record.word)
                            Spacer()
                            Text("\(record.points)")
                        }
                        .padding(3)
                        .background(record.complete ? Color.green : Color.red)
                        .overlay(
                            Rectangle()
                                .stroke(record.complete ? Color.cyan : Color.gray, lineWidth: 2)
                        )
                        .onTapGesture {
                            onDetails(record.index, record.word, record.points, record.moves, record.seconds)
                        }
                        .listRowInsets(EdgeInsets())
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

// MARK: - Preview
struct GameHistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameHistoryView(
            viewModel: AppViewModel(),
            onDetails: { _, _, _, _, _ in },
            onBack: {}
        )
    }
}
