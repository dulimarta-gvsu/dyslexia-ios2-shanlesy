//
//  SwiftUIView.swift
//  dyslexia
//
//  Created by Synjin J. Shanley on 2/26/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: AppViewModel
    var onBack: () -> Void

    var body: some View {
        VStack(alignment: .center) {
            // Header Row
            HStack {
                Button("Back") {
                    onBack()
                }
                Spacer()
                Text("Settings")
            }
            .padding(.horizontal)

            WordLengthRangeSelector(
                range: viewModel.range,
                onRangeChanged: { newRange in
                    viewModel.updateRange(newRange)
                }
            )

            Text("Block Color")

            RGBSlider(label: "Red", value: $viewModel.red, activeColor: .red)
            RGBSlider(label: "Green", value: $viewModel.green, activeColor: .green)
            RGBSlider(label: "Blue", value: $viewModel.blue, activeColor: .blue)

            Spacer()
        }
        .padding(.vertical, 50)
    }
}

// MARK: - RGB Slider
struct RGBSlider: View {
    var label: String
    @Binding var value: Float
    var activeColor: Color

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(label): \(Int(value))")
            Slider(value: $value, in: 0...255)
                .accentColor(activeColor)
        }
        .padding(.horizontal)
    }
}

// MARK: - Word Length Range Selector
struct WordLengthRangeSelector: View {
    var range: ClosedRange<Int>
    var minAllowed: Int = 5
    var maxAllowed: Int = 10
    var onRangeChanged: (ClosedRange<Int>) -> Void

    // Local float state for the two slider handles
    @State private var lower: Double
    @State private var upper: Double

    init(range: ClosedRange<Int>, minAllowed: Int = 5, maxAllowed: Int = 10, onRangeChanged: @escaping (ClosedRange<Int>) -> Void) {
        self.range = range
        self.minAllowed = minAllowed
        self.maxAllowed = maxAllowed
        self.onRangeChanged = onRangeChanged
        _lower = State(initialValue: Double(range.lowerBound))
        _upper = State(initialValue: Double(range.upperBound))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Word length: \(Int(lower)) - \(Int(upper))")
                .font(.body)

            // Lower bound slider
            HStack {
                Text("Min")
                Slider(value: $lower, in: Double(minAllowed)...Double(maxAllowed), step: 1) { _ in
                    if lower > upper { lower = upper }
                    onRangeChanged(Int(lower)...Int(upper))
                }
            }

            // Upper bound slider
            HStack {
                Text("Max")
                Slider(value: $upper, in: Double(minAllowed)...Double(maxAllowed), step: 1) { _ in
                    if upper < lower { upper = lower }
                    onRangeChanged(Int(lower)...Int(upper))
                }
            }
        }
        .padding(16)
    }
}

// MARK: - Preview
struct SettingScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            viewModel: AppViewModel(),
            onBack: {}
        )
    }
}
