//
//  GameViewController.swift
//  ConstellationsWalker
//
//  Created by Lucas Pereira on 09/12/21.
//

import UIKit
import QuartzCore
import SceneKit

let SKY_RADIUS: Float = 10.0

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create a new scene
        let scene = SCNScene()
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        // set the scene to the view
        scnView.scene = scene
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        //        ambientLightNode.light!.color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        scene.rootNode.addChildNode(ambientLightNode)
        
        //Create a Sphere
        let sphereNode = SCNNode()
        sphereNode.geometry = SCNSphere(radius: 0.1)
        sphereNode.position = SCNVector3.init(x: 0, y: 0, z: -10)
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.red
        sphereNode.geometry?.materials = [redMaterial]
        scene.rootNode.addChildNode(sphereNode)
        
        //Create sky sphere
        let skyNode = SCNNode()
        skyNode.geometry = SCNSphere(radius: CGFloat(SKY_RADIUS))
        skyNode.eulerAngles = SCNVector3(x: 0, y: GLKMathDegreesToRadians(180), z: 0)
        
        let starMapMaterial = SCNMaterial()
        starMapMaterial.diffuse.contents = UIImage(named: "starmap_8k.jpg")
        starMapMaterial.isDoubleSided = true
        skyNode.geometry?.materials = [starMapMaterial]
        
        //        let constellationsMaterial = SCNMaterial()
        //        constellationsMaterial.diffuse.contents = UIImage(named: "starmapAndConstellations_8k.jpg")
        //        constellationsMaterial.isDoubleSided = true
        //        skyNode.geometry?.materials = [constellationsMaterial]
        scene.rootNode.addChildNode(skyNode)
        
        //Create Equator Line
        let equatorLineMaterial = SCNMaterial()
        equatorLineMaterial.diffuse.contents = UIColor.yellow
        equatorLineMaterial.isDoubleSided = true
        let equatorLine2 = SCNNode()
        equatorLine2.geometry = SCNTube(innerRadius: 9.8, outerRadius: 9.9, height: 0.01)
        equatorLine2.geometry?.firstMaterial = equatorLineMaterial
        scene.rootNode.addChildNode(equatorLine2)
        
        //Create Y axis Line 2
        let equatorLine = SCNNode()
        equatorLine.geometry = SCNTube(innerRadius: 9.8, outerRadius: 9.9, height: 0.01)
        equatorLine.eulerAngles = SCNVector3(x: 0, y: 0, z: GLKMathDegreesToRadians(90))
        equatorLine.geometry?.firstMaterial = equatorLineMaterial
        scene.rootNode.addChildNode(equatorLine)
        
        //Create X axis Line 3
        let equatorLine3 = SCNNode()
        equatorLine3.geometry = SCNTube(innerRadius: 8, outerRadius: 9.9, height: 0.01)
        equatorLine3.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(90), y: GLKMathDegreesToRadians(0), z: 0)
        equatorLine3.geometry?.firstMaterial = equatorLineMaterial
        scene.rootNode.addChildNode(equatorLine3)
        
        //Create Plane
        //        let planeNode = SCNNode(geometry: SCNPlane(width: 40, height: 40))
        //        planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
        //        let tealMaterial = SCNMaterial()
        //        tealMaterial.diffuse.contents = UIColor.systemTeal
        //        planeNode.geometry?.materials = [tealMaterial]
        //        scene.rootNode.addChildNode(planeNode)
        
        // Add Taurus Constellation
        addTaurusConstelation()
        
        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x:0 , y: 2, z: 0)
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        scnView.defaultCameraController.interactionMode = .fly
        scnView.defaultCameraController.inertiaEnabled = true
        scnView.defaultCameraController.maximumVerticalAngle = 89
        scnView.defaultCameraController.minimumVerticalAngle = -89
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func addTaurusConstelation() {
        let scnView = self.view as! SCNView
        let stars: [Star] = [
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
        
        let lines: [SCNNode] = createLinesBetweenStars(stars: stars)
        
        if let scene = scnView.scene {
            for star in stars {
                scene.rootNode.addChildNode(star.node)
            }
            
            for line in lines {
                scene.rootNode.addChildNode(line)
            }
        }
    }
    
    func createLine(positionA: SCNVector3, positionB: SCNVector3) -> SCNNode {
        let scnView = self.view as! SCNView
        let positionA = positionA
        let positionB = positionB
        
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
        
        if let scene = scnView.scene {
            lineNode.look (at: positionB, up: (scene.rootNode.worldUp), localFront: lineNode.worldUp)
        }
        
        return lineNode
    }
    
    func createLinesBetweenStars(stars: [Star]) -> [SCNNode] {
        var lines: [SCNNode] = []
        
        for star in stars {
            if let nextStarId = star.lineTo {
                if let nextStar = stars.first(where: {$0.id == nextStarId}) {
                    let line = createLine(positionA: star.node.position, positionB: nextStar.node.position)
                    lines.append(line)
                }
            }
        }
        
        return lines
    }
    
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
}
