//
//  PokemonImage.swift
//  PDex3
//
//  Created by Nils Müller on 30.11.24.
//

import SwiftUI

struct PokemonImage: View {
    let url: URL?

    var body: some View {
        if let url,
           let imageData = try? Data(contentsOf: url),
           let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius: 6)
        } else {
            Image("bulbasaur")
        }
    }
}

#Preview {
    PokemonImage(url: SamplePokemon.value.sprite)
}
