//
//  Protocols.swift
//  yTrap
//
//  Created by Pawan on 2020-01-28.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

protocol ManageServerCommandsProtocol: class {
    func playAudio(withSong: Song)
    func isPlaying() -> Bool
    func isRoomHost() -> Bool
}

protocol PlayerDelegateProtocol: class {
    func playPause()
    func skip()
}
