//
//  ConstellationsParser.swift
//  ConstellationsWalker
//
//  Created by Lucas Pereira on 20/12/21.
//

import Foundation

let STARS: [Star] = [
    Star(name: "Ain (Epsilon Tauri)", id: .epsilon, ra: 67.1542, dec: 19.1803, lineTo: .delta),
    Star(name: "Hyadum II (Delta Tauri)", id: .delta, ra: 65.7333, dec: 17.5425, lineTo: .gamma),
    Star(name: "Hyadum I (Gamma Tauri)", id: .gamma, ra: 64.9458, dec: 15.6275, lineTo: .lambda),
    Star(name: "Theta Taurus (Theta Taurus)", id: .theta, ra: 67.1625, dec: 15.8708, lineTo: .gamma),
    Star(name: "Aldebaran (Alpha Tauri)", id: .alpha, ra: 68.9792, dec: 16.5092, lineTo: .theta),
    Star(name: "Zeta Taurus", id: .zeta, ra: 84.4083, dec: 21.1425, lineTo: .alpha),
    Star(name: "Nath (Beta Tauri)", id: .beta, ra: 81.5708, dec: 28.6072, lineTo: .epsilon),
    Star(name: "Lambda Taurus", id: .lambda, ra: 60.1667, dec: 12.4903, lineTo: .xi),
    Star(name: "Xi Taurus", id: .xi, ra: 51.7917, dec: 9.7325, lineTo: nil),
    Star(name: "Alcyone (Eta Tauri)", id: .eta, ra: 56.8708, dec: 24.1050, lineTo: .delta)
]
