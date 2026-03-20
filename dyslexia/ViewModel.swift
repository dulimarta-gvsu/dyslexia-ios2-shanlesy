//
//  ViewModel.swift
//  dyslexia
//
//  Created by Synjin J. Shanley on 2/26/26.
//

import Foundation
import Combine
import SwiftUI

class AppViewModel: ObservableObject {

    // MARK: - Word Stock
    let wordStock = [
        "carnivine", "furret", "vileplume", "magnezone", "deoxys", "palpitoad",
        "cubone", "liepard", "groudon", "glameow", "machoke", "sealeo", "tentacool", "vanillish",
        "breloom", "golduck", "koffing", "ninetails", "pignite", "grubbin", "duskull", "silicobra",
        "jigglypuff", "pachirisu", "duosion", "grookey", "falinks", "roserade", "ludicolo", "absol"
    ]

    let letterScore: [Character: Int] = [
        "A": 1, "B": 3, "C": 2, "D": 2, "E": 1, "F": 4, "G": 5, "H": 3,
        "I": 1, "J": 5, "K": 4, "L": 2, "M": 3, "N": 3, "O": 1, "P": 2,
        "Q": 6, "R": 3, "S": 3, "T": 3, "U": 1, "V": 4, "W": 5, "X": 6,
        "Y": 3, "Z": 5
    ]

    // MARK: - Data Models
    struct WordRecord {
        let word: String
        let points: Int
        let moves: Int
        let seconds: Int
        let index: Int
        let complete: Bool
    }

    struct Letter {
        var character: Character = "#"
        var point: Int = 1
    }

    // MARK: - Published State
    @Published var minWord: Int = 5
    @Published var maxWord: Int = 10
    @Published var range: ClosedRange<Int> = 5...10

    @Published var red: Float = 128
    @Published var green: Float = 128
    @Published var blue: Float = 128

    @Published var wordScore: Int = 0
    @Published var isComplete: Bool = true

    @Published var selectedWord: String = ""
    @Published var letters: [Letter?] = []
    @Published var removedLetter: Letter? = nil

    @Published var gameHistory: [WordRecord] = []
    @Published var score: Int = 0
    @Published var moves: Int = 0
    @Published var seconds: Int = 0
    @Published var finalTime: Int = 0

    // MARK: - Private State
    private var idx: Int = 0
    private var gameTotal: Int = 0
    private var timerTask: AnyCancellable?

    // MARK: - Init
    init() {
        selectNewWord()
        startTimer()
    }

    // MARK: - Timer
    func startTimer() {
        timerTask = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.seconds += 1
            }
    }

    // MARK: - Word Selection
    func getRandomWord(words: [String], range: ClosedRange<Int>) -> String? {
        let filtered = words.filter { range.contains($0.count) }
        return filtered.randomElement()
    }

    func selectNewWord() {
        if !isComplete {
            gameHistory.append(WordRecord(
                word: selectedWord,
                points: wordScore,
                moves: moves,
                seconds: seconds,
                index: gameHistory.count,
                complete: false
            ))
        }

        selectedWord = getRandomWord(words: wordStock, range: range)?.uppercased() ?? "PIKACHU"
        letters = selectedWord.map { char in
            Letter(character: char, point: letterScore[char] ?? 0)
        }.shuffled()

        var word = 0
        for i in selectedWord.indices {
            let idx = selectedWord.distance(from: selectedWord.startIndex, to: i)
            word += letters[idx]?.point ?? 0
        }

        wordScore = word
        removedLetter = nil
        moves = 0
        seconds = 0
        score = gameTotal
        isComplete = false
    }

    // MARK: - Letter Manipulation
    func removeLetterAt(pos: Int) {
        guard pos >= 0 && pos < letters.count else { return }
        idx = pos
        removedLetter = letters[pos]
        letters[pos] = nil
    }

    func unremoveLetter() {
        guard removedLetter != nil else { return }
        if idx != letters.firstIndex(where: { $0 == nil }) {
            moves += 1
        }
        letters = letters.map { ch in
            if let ch = ch { return ch }
            return removedLetter!
        }

        var total = gameTotal
        let wordChars = Array(selectedWord)
        for i in wordChars.indices {
            if wordChars[i] == letters[i]?.character {
                total += letters[i]?.point ?? 0
            }
        }
        score = total
        removedLetter = nil

        if score == wordScore + gameTotal {
            isComplete = true
            gameTotal += wordScore
            finalTime = seconds
            gameHistory.append(WordRecord(
                word: selectedWord,
                points: wordScore,
                moves: moves,
                seconds: finalTime,
                index: gameHistory.count,
                complete: true
            ))
        }
    }

    func swapLetters(aPos: Int, bPos: Int) {
        guard aPos < letters.count && bPos < letters.count else {
            moves -= 1
            return
        }
        guard aPos != bPos else { return }
        letters.swapAt(aPos, bPos)
    }

    // MARK: - Sorting
    func sortByWord() {
        gameHistory.sort { $0.word < $1.word }
    }

    func sortByScore() {
        gameHistory.sort { $0.points > $1.points }
    }

    func sortByMoves() {
        gameHistory.sort { $0.moves < $1.moves }
    }

    func sortByTime() {
        gameHistory.sort { $0.seconds > $1.seconds }
    }

    func sortByIndex() {
        gameHistory.sort { $0.index < $1.index }
    }

    // MARK: - Color Controls
    func changeRed(_ value: Float) {
        red = value
    }

    func changeGreen(_ value: Float) {
        green = value
    }

    func changeBlue(_ value: Float) {
        blue = value
    }

    func updateRange(_ newRange: ClosedRange<Int>) {
        range = newRange
    }
}
