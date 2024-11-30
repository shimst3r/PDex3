//
//  PokemonViewModel.swift
//  PDex3
//
//  Created by Nils Müller on 30.11.24.
//

import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    @Published private(set) var status = Status.notStarted
    private let controller: PokemonController
    
    init(controller: PokemonController) {
        self.controller = controller
        
        Task {
            await getPokemon()
        }
    }
    
    private func getPokemon() async {
        status = .fetching
        
        do {
            guard let pokedex = try await controller.fetchAllPokemon() else {
                status = .success
                return
            }
            
            for pokemon in pokedex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shinySprite = pokemon.shinySprite
                newPokemon.favourite = false
                
                try PersistenceController.shared.container.viewContext.save()
            }
            status = .success
        } catch {
            status = .failed(error: error)
        }
    }
    
    enum Status {
        case notStarted
        case fetching
        case success
        case failed(error: Error)
    }
}
