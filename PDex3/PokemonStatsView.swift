//
//  PokemonStatsView.swift
//  PDex3
//
//  Created by Nils Müller on 30.11.24.
//

import Charts
import SwiftUI

struct PokemonStatsView: View {
    @EnvironmentObject var pokemon: Pokemon

    var body: some View {
        Chart(pokemon.stats) { stat in
            BarMark(
                x: .value("Value", stat.value),
                y: .value("Stat", stat.label)
            )
            .annotation(position: .trailing) {
                Text("\(stat.value)")
                    .padding(.top, -5)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        .frame(height: 200)
        .padding([.leading, .bottom, .trailing])
        .foregroundColor(.primary)
        // 200 is the highest single stat, add 10 to avoid UI cutoff.
        .chartXScale(domain: 0 ... 210)
    }
}

#Preview {
    PokemonStatsView()
        .environmentObject(SamplePokemon.value)
}
