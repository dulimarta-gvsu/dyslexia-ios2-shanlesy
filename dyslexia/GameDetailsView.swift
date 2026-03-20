//
//  GameDetailsView.swift
//  dyslexia
//
//  Created by Synjin J. Shanley on 2/26/26.
//

import SwiftUI

struct GameDetailsView: View {
    private var onBack: () -> Void
    init(onBack: @escaping () -> Void) {
        self.onBack = onBack
    }
    var body: some View {
        Text("This is the Detail Screen")
        VStack {
            Button("Back") {
                self.onBack()
            }
        }
        .padding()
    }
}

#Preview {
    //GameDetailsView(onBack: <#T##() -> Void#>)
}
