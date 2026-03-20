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
                            GameHistoryView() {
                                navCtrl.navigateBack()
                            } onDetails: {
                                navCtrl.navigate(to: .GameDetailsView)
                            }
                        case .GameDetailsView:
                            GameDetailsView() {
                                navCtrl.navigateBack()
                            }
                        case .SettingsView:
                            SettingsView() {
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
