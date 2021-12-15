//
//  CoordinateConverter.swift
//  ConstellationsWalker
//
//  Created by Lucas Pereira on 15/12/21.
//

import Foundation
import SceneKit

func CelestialToCartesian(radius: Float, ra: Float, dec: Float) -> SCNVector3 {
    // Rotation Right Ascension
    let x = radius * sin(GLKMathDegreesToRadians(ra+180))
    var z = radius * cos(GLKMathDegreesToRadians(ra+180))
    
    // Rotation Declination
    let radiusDecCirc = abs(z)
    let y = radiusDecCirc * sin(GLKMathDegreesToRadians(180-dec))
    z = radiusDecCirc * cos(GLKMathDegreesToRadians(180-dec))
    
    return SCNVector3(x: x, y: y, z: z)
}

