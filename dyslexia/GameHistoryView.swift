//
//  GameHistoryView.swift
//  dyslexia
//
//  Created by Synjin J. Shanley on 2/26/26.
//

import SwiftUI

struct GameHistoryView: View {
    private var onBack: () -> Void
    private var onDetails: () -> Void
    init(onBack: @escaping () -> Void, onDetails: @escaping () -> Void) {
        self.onBack = onBack
        self.onDetails = onDetails
    }
    var body: some View {
        Text("This is the History Screen")
        VStack {
            Button("Back") {
                self.onBack()
            }
            Button("Details") {
                self.onDetails()
            }
        }
        .padding()
    }
}

//#Preview {
//    GameHistoryView(onBack: <#() -> Void#>)
//}
