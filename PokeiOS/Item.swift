//
//  Item.swift
//  PokeiOS
//
//  Created by Amaan Asim on 2025-08-01.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
