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
    var constellations: [Constellation] = []
    var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create a new scene
        let scene = SCNScene()
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        scnView.delegate = self
        // set the scene to the view
        scnView.scene = scene
        // show statistics such as fps and timing information
        scnView.showsStatistics = false
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        //Load constellations
        constellations.append(
            Constellation(name: "Taurus", stars: STARS, currentView: scnView)
        )
        
        // UI
        label = UILabel(frame: CGRect(x: (scnView.frame.width/2)-75, y: 750, width: 150, height: 50))
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 16
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Aldebaran"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.backgroundColor = UIColor(red: 0, green: 198/255, blue: 243/255, alpha: 0.8)
        scnView.addSubview(label)
        
        
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
//        ambientLightNode.light!.color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        ambientLightNode.light!.color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        scene.rootNode.addChildNode(ambientLightNode)
        
        //Create a Sphere
        let sphereNode = SCNNode()
        sphereNode.geometry = SCNSphere(radius: 0.1)
        sphereNode.position = SCNVector3.init(x: 0, y: 0, z: -10)
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.red
        sphereNode.geometry?.materials = [redMaterial]
//        scene.rootNode.addChildNode(sphereNode)
        
        //Create sky sphere
        let skyNode = SCNNode()
        skyNode.geometry = SCNSphere(radius: CGFloat(SKY_RADIUS))
        skyNode.eulerAngles = SCNVector3(x: 0, y: GLKMathDegreesToRadians(180), z: 0)
        
        let starMapMaterial = SCNMaterial()
        starMapMaterial.diffuse.contents = UIImage(named: "starmapArt_8k.jpg")
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
//        scene.rootNode.addChildNode(equatorLine2)
        
        //Create Y axis Line 2
        let equatorLine = SCNNode()
        equatorLine.geometry = SCNTube(innerRadius: 9.8, outerRadius: 9.9, height: 0.01)
        equatorLine.eulerAngles = SCNVector3(x: 0, y: 0, z: GLKMathDegreesToRadians(90))
        equatorLine.geometry?.firstMaterial = equatorLineMaterial
//        scene.rootNode.addChildNode(equatorLine)
        
        //Create X axis Line 3
        let equatorLine3 = SCNNode()
        equatorLine3.geometry = SCNTube(innerRadius: 8, outerRadius: 9.9, height: 0.01)
        equatorLine3.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(90), y: GLKMathDegreesToRadians(0), z: 0)
        equatorLine3.geometry?.firstMaterial = equatorLineMaterial
//        scene.rootNode.addChildNode(equatorLine3)
        
        //Create Plane
        //        let planeNode = SCNNode(geometry: SCNPlane(width: 40, height: 40))
        //        planeNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-90), y: 0, z: 0)
        //        let tealMaterial = SCNMaterial()
        //        tealMaterial.diffuse.contents = UIColor.systemTeal
        //        planeNode.geometry?.materials = [tealMaterial]
        //        scene.rootNode.addChildNode(planeNode)
        
        // Add Taurus Constellation
        addConstellations()
        
        // Create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x:0 , y: 1, z: 0)
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
    
    func addConstellations() {
        let scnView = self.view as! SCNView
        
        if let scene = scnView.scene {
            for constellation in constellations {
                for star in constellation.stars {
                    scene.rootNode.addChildNode(star.node)
                }
                
                for line in constellation.lines {
                    scene.rootNode.addChildNode(line)
                }
            }
        }
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

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
}
