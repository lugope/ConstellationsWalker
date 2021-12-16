//
//  Star.swift
//  ConstellationsWalker
//
//  Created by Lucas Pereira on 16/12/21.
//

import Foundation
import SceneKit

enum ConstellationID {
    case alpha
    case beta
    case delta
    case gamma
    case epsilon
    case zeta
    case eta
    case theta
    case iota
    case kappa
    case lambda
    case mu
    case nu
    case xi
    case omikron
    case pi
    case rho
    case sigma
    case tau
    case upsilon
    case phi
    case chi
    case psi
    case omega
}

struct Star {
    let name: String
    let id: ConstellationID
    let ra: Float
    let dec: Float
    let lineTo: ConstellationID?
    let node: SCNNode
    
    init(name: String, id: ConstellationID, ra: Float, dec: Float, lineTo: ConstellationID?) {
        self.name = name
        self.id = id
        self.ra = ra
        self.dec = dec
        self.lineTo = lineTo
        
        node = SCNNode()
        node.geometry = SCNSphere(radius: 0.05)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.yellow
        node.position = CelestialToCartesian(radius: SKY_RADIUS-0.1, ra: ra, dec: dec)
    }
}
