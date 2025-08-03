//
//  ContentView.swift
//  PokeiOS
//
//  Created by Amaan Asim on 2025-08-01.
//

import SwiftUI
import SwiftData
import PokemonAPI

let pokemonAPI = PokemonAPI()

struct ContentView: View {
    @State private var berryNames: [String] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else if berryNames.isEmpty {
                    Text("Loading...")
                } else {
                    ForEach(berryNames, id: \.self) { name in
                        NavigationLink(name){
                            Text(name)
                        }
                    }
                }
            }
            .navigationTitle("Berries")
        }
        .task {
            await fetchBerries()
        }
    }

    func fetchBerries() async {
        do {
            var names: [String] = []
            for id in 1...10 {
                let berry = try await PokemonAPI().berryService.fetchBerry(id)
                if let name = berry.name {
                    names.append(name.capitalized)
                }
            }
            berryNames = names
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
