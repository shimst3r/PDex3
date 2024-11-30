//
//  FetchController.swift
//  PDex3
//
//  Created by Nils Müller on 30.11.24.
//

import CoreData
import Foundation

struct PokemonController {
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon")
    
    var havePokemon: Bool {
        let context = PersistenceController.shared.container.newBackgroundContext()
        
        let request: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        request.predicate = NSPredicate(format: "id IN %@", [1, 386])
        
        do {
            let result = try context.fetch(request)
            return result.count == 2
        } catch {
            return false
        }
    }
    
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        guard !havePokemon else { return nil }
        
        var fetchComponents = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        
        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any], let pokedex = pokeDictionary["results"] as? [[String: String]] else {
            throw NetworkError.badData
        }
        
        let allPokemon: [TempPokemon] = try await withThrowingTaskGroup(of: TempPokemon.self) { group in
            for pokemon in pokedex {
                group.addTask {
                    let url = pokemon["url"]!
                    return try await fetchPokemon(from: URL(string: url)!)
                }
            }
            var arr = [TempPokemon]()
            for try await pokemon in group {
                arr.append(pokemon)
            }
            
            return arr.sorted { $0.id < $1.id }
        }
        
        return allPokemon
    }
    
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        return tempPokemon
    }
    
    enum NetworkError: Error {
        case invalidURL, badResponse, badData
    }
}
