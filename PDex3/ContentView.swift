//
//  ContentView.swift
//  PDex3
//
//  Created by Nils Müller on 28.11.24.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    private var pokedex: FetchedResults<Pokemon>

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favourite = %d", true),
        animation: .default)
    private var favouritePokedex: FetchedResults<Pokemon>

    @State private var filterByFavourites = false
    @StateObject private var vm = PokemonViewModel(controller: PokemonController())

    var body: some View {
        switch vm.status {
        case .success:
            NavigationStack {
                List(filterByFavourites ? favouritePokedex : pokedex) { pokemon in
                    NavigationLink(value: pokemon) {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100, height: 100)

                        Text(pokemon.name!.capitalized)
                        if pokemon.favourite {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.red)
                        }
                    }
                }
                .navigationTitle("Pokédex")
                .navigationDestination(
                    for: Pokemon.self,
                    destination: { pokemon in
                        PokemonDetailView()
                            .environmentObject(pokemon)
                    })
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation {
                                filterByFavourites.toggle()
                            }
                        } label: {
                            Label("Filter By Favourites", systemImage: filterByFavourites ? "heart.circle.fill" : "heart.circle")
                        }
                        .font(.title)
                        .foregroundStyle(.red)
                    }
                }
            }
        default:
            ProgressView()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
