//
//  PDex3Tests.swift
//  PDex3Tests
//
//  Created by Nils Müller on 30.11.24.
//

@testable import PDex3
import Testing

struct PDex3Tests {
    @Test func testFetchController() async throws {
        let fetcher = PokemonController()
        let pokemon = try await fetcher.fetchAllPokemon()
        #expect(pokemon.count == 386)
    }
}
