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
@MainActor private var berryNames: [String] = []
@MainActor private var errorMessage: String?

@MainActor
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

struct ContentView: View {

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    @State private var berryNames: [String] = []
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    if let error = errorMessage {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    } else if berryNames.isEmpty {
                        Text("Loading...")
                    } else {
                        ForEach(berryNames, id: \.self) { name in
                            NavigationLink(destination: DetailView(name: name)) {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 200, height: 50)
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
                .navigationTitle("Berries")
            }
        }
        .task {
            await loadBerries()
        }
    }

    @MainActor
    func loadBerries() async {
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
