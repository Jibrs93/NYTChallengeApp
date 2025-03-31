//
//  CATransition+Fade.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import UIKit

extension CATransition {
    static func fade(duration: CFTimeInterval = 0.3) -> CATransition {
        let transition = CATransition()
        transition.duration = duration
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return transition
    }
}
