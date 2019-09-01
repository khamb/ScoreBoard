//
//  WindowController.swift
//  ScoreBoard
//
//  Created by Khadim Mbaye on 2019-08-31.
//  Copyright © 2019 Khadim Mbaye. All rights reserved.
//

import Cocoa

final class WindowController: NSWindowController {

    // MARK: - NSTouchBar
    
    @IBOutlet private var touchBarScrubber: NSScrubber!
    
    // MARK: - Private Properties
    
    private var liveGames: [Game]? {
        didSet  {
            DispatchQueue.main.async { self.touchBarScrubber.reloadData() }
        }
    }
    
    // MARK: - Lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
        setupTouchBarScrubber()
        setLiveGamesString()
    }
    
    
    // MARK: - Private Methods
    
    private func setupTouchBarScrubber() {
        touchBarScrubber.dataSource = self
    }
    
    private func setLiveGamesString() {
        DataService.shared.fetchLiveGames { liveGames in
            self.liveGames = liveGames
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func touchBarRefreshButtonTapped(_ sender: Any) {
       setLiveGamesString()
    }
}

// MARK: - NSScrubberDataSource

@available(OSX 10.12.2, *)
extension WindowController: NSScrubberDataSource {
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return liveGames?.count ?? 0
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        guard let liveGames = liveGames else { return NSScrubberTextItemView() }
        let liveGame = liveGames[index]
        let scrubberItem = NSScrubberTextItemView()
        scrubberItem.textField.textColor = .red
        scrubberItem.title = "\(liveGame.awayTeamName) \(liveGame.goalsAwayTeam)-\(liveGame.goalsHomeTeam) \(liveGame.homeTeamName) (\(liveGame.time))"
        return scrubberItem
    }
}
