//
//  PokemonWidget.swift
//  PDex3
//
//  Created by Nils Müller on 30.11.24.
//

import SwiftUI

struct PokemonWidget: View {
    @EnvironmentObject var pokemon: Pokemon
    let widgetSize: WidgetSize

    var body: some View {
        ZStack {
            Color(pokemon.types!.first!.capitalized)

            switch widgetSize {
            case .small:
                PokemonImage(url: pokemon.sprite)
            case .medium:
                HStack {
                    PokemonImage(url: pokemon.sprite)
                    VStack(alignment: .leading) {
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    }
                    .padding(.trailing, 30)
                }
            case .large:
                VStack {
                    HStack {
                        PokemonImage(url: pokemon.sprite)
                        VStack(alignment: .leading) {
                            Text(pokemon.name!.capitalized)
                                .font(.title)
                            Text(pokemon.types!.joined(separator: ", ").capitalized)
                        }
                        .padding(.trailing, 30)
                    }
                    PokemonStatsView()
                }
            }
        }
    }
}

enum WidgetSize {
    case small, medium, large
}

#Preview {
    PokemonWidget(widgetSize: .large)
        .environmentObject(SamplePokemon.value)
}
