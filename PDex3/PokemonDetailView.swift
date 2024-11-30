//
//  PokemonDetailView.swift
//  PDex3
//
//  Created by Nils Müller on 30.11.24.
//

import SwiftUI

struct PokemonDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny = false

    var body: some View {
        ScrollView {
            ZStack {
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black, radius: 6)
                AsyncImage(url: showShiny ? pokemon.shinySprite : pokemon.sprite) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 50)
                        .shadow(color: .black, radius: 6)
                } placeholder: {
                    ProgressView()
                }
            }

            HStack {
                ForEach(pokemon.types!, id: \.self) { type in
                    Text(type.capitalized)
                        .font(.title2)
                        .shadow(color: .white, radius: 1)
                        .padding([.top, .bottom], 7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .clipShape(.capsule)
                }
                Spacer()
                Button {
                    pokemon.favourite.toggle()
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error: \(nsError), \(nsError.userInfo)")
                    }
                } label: {
                    Image(systemName: pokemon.favourite ? "heart.fill" : "heart")
                }
                .font(.title)
                .foregroundStyle(.red)
            }
            .padding()

            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)

            PokemonStatsView()
                .environmentObject(pokemon)
        }
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showShiny.toggle()
                } label: {
                    Image(showShiny ? "custom.sparkles.circle.fill" : "custom.sparkles.circle")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PokemonDetailView()
            .environmentObject(SamplePokemon.value)
    }
}
