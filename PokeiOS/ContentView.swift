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
@MainActor private var pokemonNames: [String] = []
@MainActor private var errorMessage: String?

@MainActor
func fetchPokemon() async {
    do {
        var names: [String] = []
        for id in 1...50 {
            let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(id)
            if let name = pokemon.name {
                names.append(name.capitalized)
            }
        }
        pokemonNames = names
    } catch {
        errorMessage = error.localizedDescription
    }
}

struct ContentView: View {

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
    ]

    @State private var pokemonNames: [String] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    if let error = errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    } else if pokemonNames.isEmpty {
                        Text("Loading...")
                    } else {
                        ForEach(pokemonNames, id: \.self) { name in
                            NavigationLink(destination: DetailView(name: name)) {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 165, height: 75)
                                    .glassEffect(in: .rect(cornerRadius: 12))
                                
                                    .overlay(
                                        Text(name)
                                            .foregroundColor(.white)
                                    )
                                    
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .navigationTitle("Pokemon")
            }
        }
        .task {
            await loadPokemon()
        }
    }

    @MainActor
    func loadPokemon() async {
        do {
            var names: [String] = []
            for id in 1...50 {
                let pokemon = try await PokemonAPI().pokemonService.fetchPokemon(id)
                if let name = pokemon.name {
                    names.append(name.capitalized)
                }
            }
            pokemonNames = names
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct DetailView: View {
    let name: String
    var body: some View {
        Text(name)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
