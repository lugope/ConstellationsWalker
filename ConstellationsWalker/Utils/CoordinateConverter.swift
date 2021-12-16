//
//  CoordinateConverter.swift
//  ConstellationsWalker
//
//  Created by Lucas Pereira on 15/12/21.
//

import Foundation
import SceneKit

func CelestialToCartesian(radius: Float, ra: Float, dec: Float) -> SCNVector3 {
    //Ajusting the angles to get -z as initial axis of theta
    //and phi increase from the z*x axis
    let theta: Float = ra + 180.0
    let phi: Float = 90.0 - dec
    
    let z = radius * sin(GLKMathDegreesToRadians(phi)) * cos(GLKMathDegreesToRadians(theta))
    let x = radius * sin(GLKMathDegreesToRadians(phi)) * sin(GLKMathDegreesToRadians(theta))
    let y = radius * cos(GLKMathDegreesToRadians(phi))
    
    return SCNVector3(x: x, y: y, z: z)
}

