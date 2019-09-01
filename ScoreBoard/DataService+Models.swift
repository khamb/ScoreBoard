//
//  DataService.swift
//  ScoreBoard
//
//  Created by Khadim Mbaye on 2019-08-31.
//  Copyright © 2019 Khadim Mbaye. All rights reserved.
//

import Foundation


// MARK: - DataService

final class DataService {
    
    // MARK: - Public Properties
    
    static let shared = DataService()
    
    // MARK: - Private Properties
    
    func fetchLiveGames(completion: @escaping ((_ games: [Game]) -> Void)) {
        guard let url = URL(string: "http://soccer-cli.appspot.com") else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, urlRequest, error in
            guard let data = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let games = try? JSONDecoder().decode([String: [Game]].self, from: data)["games"] else { return }
            completion(games)
        }
        
        dataTask.resume()
    }
    
}


// MARK: - Game Model

final class Game: Decodable {
    
    var awayTeamName: String
    var goalsAwayTeam: Int
    var goalsHomeTeam: Int
    var homeTeamName: String
    var league: String
    var time: String
    
    private enum CodingKeys: String, CodingKey {
        case awayTeamName
        case goalsAwayTeam
        case goalsHomeTeam
        case homeTeamName
        case league
        case time
    }
    
    init(awayTeamName: String, goalsAwayTeam: Int, goalsHomeTeam: Int, homeTeamName: String, league: String, time: String) {
        self.awayTeamName = awayTeamName
        self.goalsAwayTeam = goalsAwayTeam
        self.goalsHomeTeam = goalsHomeTeam
        self.homeTeamName = homeTeamName
        self.league = league
        self.time = time
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let awayTeamScore = try container.decode(Int.self, forKey: .goalsAwayTeam)
        let homeTeamScore = try container.decode(Int.self, forKey: .goalsHomeTeam)
        
        awayTeamName = try container.decode(String.self, forKey: .awayTeamName)
        goalsAwayTeam = awayTeamScore == -1 ? 0 : awayTeamScore
        goalsHomeTeam = homeTeamScore == -1 ? 0 : homeTeamScore
        homeTeamName = try container.decode(String.self, forKey: .homeTeamName)
        league = try container.decode(String.self, forKey: .league)
        time = try container.decode(String.self, forKey: .time)
    }
}


