//
//  SamplePokemon.swift
//  PDex3
//
//  Created by Nils Müller on 30.11.24.
//

import CoreData
import Foundation

@MainActor
struct SamplePokemon {
    static let value = {
        let context = PersistenceController.preview.container.viewContext
        
        let request: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        request.fetchLimit = 1
        
        let results = try! context.fetch(request)
        
        return results.first!
    }()
}
