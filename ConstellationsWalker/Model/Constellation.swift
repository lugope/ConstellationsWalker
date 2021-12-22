//
//  Constellation.swift
//  ConstellationsWalker
//
//  Created by Lucas Pereira on 20/12/21.
//

import Foundation
import SceneKit

struct Constellation {
    let name: String
    let stars: [Star]
    let currentView: SCNView
    let centralPoint: SCNVector3
    var defaultLines: [SCNNode]?
    var lines: [SCNNode] {
        guard defaultLines == nil else { return defaultLines!}
        
        var lines: [SCNNode] = []
        for star in stars {
            if let nextStarId = star.lineTo {
                if let nextStar = stars.first(where: {$0.id == nextStarId}) {
                    let line = createLineBetweenStars(positionA: star.node.position, positionB: nextStar.node.position, currentView: currentView)
                    lines.append(line)
                }
            }
        }
        
        return lines
    }
    
    init(name: String, stars: [Star], currentView: SCNView) {
        //Name
        self.name = name
        
        //Stars
        self.stars = stars
        
        //Current View
        self.currentView = currentView
        
        //Central Position
        var xSum: Float = 0
        var ySum: Float = 0
        var zSum: Float = 0
        
        for star in stars {
            xSum += star.node.position.x
            ySum += star.node.position.y
            zSum += star.node.position.z
        }
        
        self.centralPoint = SCNVector3(
            x: xSum/Float(stars.count),
            y: ySum/Float(stars.count),
            z: zSum/Float(stars.count)
        )
        
        // Lines
        self.defaultLines = lines
    }
    
    func createLineBetweenStars(positionA: SCNVector3, positionB: SCNVector3, currentView: SCNView) -> SCNNode {
        let vector = SCNVector3(positionA.x - positionB.x, positionA.y - positionB.y, positionA.z - positionB.z)
        let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
        let midPosition = SCNVector3 (x:(positionA.x + positionB.x) / 2, y:(positionA.y + positionB.y) / 2, z:(positionA.z + positionB.z) / 2)
        
        let lineGeometry = SCNCylinder()
        lineGeometry.radius = 0.01
        lineGeometry.height = CGFloat(distance)
        lineGeometry.radialSegmentCount = 5
        lineGeometry.firstMaterial!.diffuse.contents = UIColor.white
        
        let lineNode = SCNNode(geometry: lineGeometry)
        lineNode.position = midPosition
        
        if let scene = currentView.scene {
            lineNode.look (at: positionB, up: (scene.rootNode.worldUp), localFront: lineNode.worldUp)
        }
        
        return lineNode
    }
}
