//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import Foundation
import SwiftUI

struct Game: Codable, Identifiable {
    let date: String
    let id: Int
    let opponent: String
    let team: String
    let isHomeGame: Bool
    let score: Score
}

struct Score: Codable {
    let unc: Int
    let opponent: Int
}

struct ContentView: View {
    @State private var games: [Game] = []

    var body: some View {
        NavigationView {
            List(self.games) { game in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(game.team) vs. \(game.opponent)")
                            .font(.headline)

                        Text("\(game.date)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(game.score.unc) - \(game.score.opponent)")
                            .font(.headline)

                        if game.isHomeGame {
                            Text("Home")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                        } else {
                            Text("Away")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("UNC Basketball")
            .task {
                await self.loadData()
            }
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball")
        else {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedGames = try? JSONDecoder().decode(
                [Game].self, from: data
            ) {
                self.games = decodedGames
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
