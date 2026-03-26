//
//  ContentView.swift
//  dyslexia
//
//  Created by Synjin J. Shanley on 2/26/26.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var navCtrl = MyNavigator()
    @StateObject var vm = AppViewModel()
    var body: some View {
        NavigationStack(path: $navCtrl.navPath) {
            WordView(viewModel: vm,
                    onHistory: {navCtrl.navigate(to: .GameHistoryView)},
                    onSettings: { navCtrl.navigate(to: .SettingsView)})
                .navigationDestination(for: Route.self) { dest in
                    switch dest {
                    case .GameHistoryView:
                        GameHistoryView(viewModel: vm) { index, word, points, moves, time in
                            navCtrl.navigate(to: .GameDetailsView(game: index, word: word, points: points, moves: moves, time: time))
                        } onBack: {
                            navCtrl.navigateBack()
                        }
                        case .GameDetailsView(let game, let word, let points, let moves, let time):
                            GameDetailsView(game: game, word: word, points: points, moves: moves, time: time) {
                                navCtrl.navigateBack()
                            }
                        case .SettingsView:
                            SettingsView(viewModel: vm) {
                                navCtrl.navigateBack()
                            }
                        }
                }
        }
    }
}

//#Preview {
//    MainView()
//}
