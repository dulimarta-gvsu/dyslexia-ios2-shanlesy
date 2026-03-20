//
//  WordView.swift
//  dyslexia
//
//  Created by Synjin J. Shanley on 2/26/26.
//

import SwiftUI

struct WordView: View {
    @ObservedObject var viewModel: AppViewModel
    var onHistory: () -> Void
    var onSettings: () -> Void

    // Drag state
    @State private var dragDistance: CGSize = .zero
    @State private var dragBeginAt: CGPoint = .zero
    @State private var blankBoxIndex: Int? = nil
    @State private var pointerIndex: Int? = nil
    @State private var rowWidth: CGFloat = 0
    
    func offsetToLetterIndex(_ xOffset: CGFloat, rowWidth: CGFloat, count: Int) -> Int {
        guard rowWidth > 0, count > 0 else { return 0 }
        let percentage = min(max(xOffset / rowWidth, 0), 1)
        let index = Int(percentage * CGFloat(count))
        return min(index, count - 1)
    }

    // Convert x-offset to zero-based index of letter box in the Row
    func offsetToLetterIndex(_ xOffset: CGFloat) -> Int {
        guard rowWidth > 0 else { return 0 }
        let percentage = min(max(xOffset / rowWidth, 0), 1)
        let index = Int(percentage * CGFloat(viewModel.letters.count))
        return min(index, viewModel.letters.count - 1)
    }

    var body: some View {
        ZStack {
            // Background image
            Image("Image")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(alignment: .center) {

                // Top navigation buttons
                HStack {
                    Button("Game History") { self.onHistory() }
                    Button("Settings") { self.onSettings() }
                }
                .padding(.all)
                .background()

                // Status rows
                if viewModel.isComplete {
                    HStack {
                        Text("Congratulations! You solved the word")
                            .padding(.horizontal)
                    }
                    .background(Color.white)

                    HStack {
                        Text("Moves: \(viewModel.moves)")
                        Spacer().frame(width: 30)
                        Text("Time: \(viewModel.finalTime)")
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                } else {
                    HStack {
                        Text("Moves: \(viewModel.moves)")
                        Spacer().frame(width: 30)
                        Text("Time: \(viewModel.seconds)")
                    }
                    .padding(.horizontal)
                    .background(Color.white)
                }

                HStack {
                    Text("Score: \(viewModel.score)")
                }
                .padding(.horizontal)
                .background(Color.white)

                Button("New Word") {
                    viewModel.selectNewWord()
                }
                .padding(.all, 4)
                .background()

                // Letter tiles area
                Spacer()
                ZStack(alignment: .center) {
                    GeometryReader { geo in
                        let letterSize = 1.5 * geo.size.width / CGFloat(viewModel.letters.count)
                        let rowWidth = letterSize * CGFloat(viewModel.letters.count)
                        let rowStartX = (geo.size.width - rowWidth) / 2  // center offset

                        // Letter row with drag gesture
                        HStack(spacing: 0) {
                            ForEach(Array(viewModel.letters.enumerated()), id: \.offset) { _, letter in
                                BigLetter(
                                    letter: letter?.character,
                                    size: letterSize,
                                    points: letter?.point,
                                    viewModel: viewModel
                                )
                            }
                        }
                        .background(Color.gray)
                        .frame(width: geo.size.width, alignment: .center) // center the HStack
                        .position(x: geo.size.width / 2, y: geo.size.height / 2.5)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if blankBoxIndex == nil {
                                        dragBeginAt = value.startLocation
                                        dragDistance = .zero
                                        // Adjust for row centering when finding index
                                        let localX = value.startLocation.x - rowStartX
                                        blankBoxIndex = offsetToLetterIndex(localX, rowWidth: rowWidth, count: viewModel.letters.count)
                                        viewModel.removeLetterAt(pos: blankBoxIndex!)
                                    }
                                    dragDistance = value.translation
                                    let currentX = (dragBeginAt.x - rowStartX) + dragDistance.width
                                    pointerIndex = offsetToLetterIndex(currentX, rowWidth: rowWidth, count: viewModel.letters.count)
                                    if let pi = pointerIndex, let bi = blankBoxIndex, pi != bi {
                                        viewModel.swapLetters(aPos: pi, bPos: bi)
                                        blankBoxIndex = pi
                                    }
                                }
                                .onEnded { _ in
                                    blankBoxIndex = nil
                                    pointerIndex = nil
                                    dragBeginAt = .zero
                                    dragDistance = .zero
                                    viewModel.unremoveLetter()
                                }
                        )

                        // Floating dragged letter — rendered on top
                        if let removed = viewModel.removedLetter {
                            let fingerX = dragBeginAt.x + dragDistance.width
                            let fingerY = dragBeginAt.y + dragDistance.height
                            BigLetter(
                                letter: removed.character,
                                size: letterSize,
                                points: removed.point,
                                viewModel: viewModel
                            )
                            .position(x: fingerX, y: fingerY) // follow finger directly
                        }
                    }
                }
                Spacer()
            }.padding(.all, 80)
        }
    }
}

// MARK: - BigLetter View

struct BigLetter: View {
    var modifier: AnyView? = nil
    var letter: Character?
    var size: CGFloat
    var points: Int?
    @ObservedObject var viewModel: AppViewModel

    var tileColor: Color {
        Color(
            red: Double(viewModel.red) / 255.0,
            green: Double(viewModel.green) / 255.0,
            blue: Double(viewModel.blue) / 255.0
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                Rectangle()
                    .fill(letter != nil ? tileColor : Color.white)
                    .frame(width: size, height: size)
                    .border(Color.black, width: 1)
                    .cornerRadius(4)

                Text(letter.map { String($0) } ?? "")
                    .font(.system(size: size * 0.60))
            }

            Text(points.map { String($0) } ?? "")
                .font(.system(size: size * 0.35))
                .padding(2)
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Preview

struct WordScreen_Previews: PreviewProvider {
    static var previews: some View {
        WordView(
            viewModel: AppViewModel(),
            onHistory: {},
            onSettings: {}
        )
    }
}
