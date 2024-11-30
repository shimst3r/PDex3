//
//  Pokemon+Extension.swift
//  PDex3
//
//  Created by Nils Müller on 30.11.24.
//

import Foundation

extension Pokemon {
    var background: String {
        switch self.types!.first! {
        case "normal", "grass", "electric", "poison", "fairy": return "normalgrasselectricpoisonfairy"
        case "rock", "ground", "steel", "fighting", "ghost", "dark", "psychic": return "rockgroundsteelfightingghostdarkpsychic"
        case "fire", "dragon": return "firedragon"
        case "flying", "bug": return "flyingbug"
        case "ice": return "ice"
        case "water": return "water"
        default: return "normalgrasselectricpoisonfairy"
        }
    }
    
    var stats: [Stat] {
        [
            .init(id: 1, label: "HP", value: self.hp),
            .init(id: 2, label: "Attack", value: self.attack),
            .init(id: 3, label: "Defense", value: self.defense),
            .init(id: 4, label: "Sp. Attack", value: self.specialAttack),
            .init(id: 5, label: "Sp. Defense", value: self.specialDefense),
            .init(id: 6, label: "Speed", value: self.speed)
        ]
    }
    
    var highestStat: Stat {
        stats.max(by: { $0.value < $1.value })!
    }
}
