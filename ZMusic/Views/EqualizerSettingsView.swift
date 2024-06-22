//
//  EqualizerSettingsView.swift
//  ZMusic
//
//  Created by Анна on 22.06.2024.
//

import SwiftUI
import SwiftUI
import AVFoundation
import RealmSwift

// Кастомный стиль для слайдера, чтобы фон был прозрачным
import SwiftUI

struct EqualizerSettingsView: View {
    @ObservedObject var viewModel: YourTracksViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                RadialGradientView(colors: [.red.opacity(0.5), .purple.opacity(0.5), .blue.opacity(0.5), .black], location: .bottom, endRadius: 500)
                
                ScrollView {
                    VStack(spacing: 8) {
                        Group {
                            customSlider(
                                value: $viewModel.lowGain.doubleBinding,
                                range: -24...24,
                                label: "Low Gain (Низкие частоты)",
                                minValue: "-24",
                                maxValue: "24"
                            )
                            customSlider(
                                value: $viewModel.midGain.doubleBinding,
                                range: -24...24,
                                label: "Mid Gain (Средние частоты)",
                                minValue: "-24",
                                maxValue: "24"
                            )
                            customSlider(
                                value: $viewModel.highGain.doubleBinding,
                                range: -24...24,
                                label: "High Gain (Высокие частоты)",
                                minValue: "-24",
                                maxValue: "24"
                            )
                            customSlider(
                                value: $viewModel.reverb.doubleBinding,
                                range: 0...100,
                                label: "Reverb (Реверберация)",
                                minValue: "0",
                                maxValue: "100"
                            )
                            customSlider(
                                value: $viewModel.echoDelay.doubleBinding,
                                range: 0...2000,
                                label: "Echo Delay (Задержка эхо) ms",
                                minValue: "0",
                                maxValue: "2000"
                            )
                            customSlider(
                                value: $viewModel.echoDecay.doubleBinding,
                                range: 0...100,
                                label: "Echo Decay (Затухание эхо)",
                                minValue: "0",
                                maxValue: "100"
                            )
                        }
                        
                        HStack {
                            Button("Apply") {
                                viewModel.applyEqualizerSettings()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        Button("Close") {
                            dismiss()
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        }
                    }
                    .padding()
                    .navigationTitle("Equalizer Settings")
                }
            }
        }
    }
    
    @ViewBuilder
    private func customSlider(value: Binding<Double>, range: ClosedRange<Double>, label: String, minValue: String, maxValue: String) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(.white)
                .font(.headline)
            
            Text("Your value: \(Int(value.wrappedValue))")
                .foregroundColor(.white)
                .font(.subheadline)
            
            HStack {
                Text(minValue)
                
                Slider(value: value, in: range, step: 1)
                    .accentColor(.white)
                    .background(Color.clear)
                    .padding()
                    .background(Color.clear)
                .opacity(1)
                
                Text(maxValue)
            }
        }
    }
}

// Extension для преобразования Binding<Float> в Binding<Double>
extension Binding where Value == Float {
    var doubleBinding: Binding<Double> {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Float($0) }
        )
    }
}
