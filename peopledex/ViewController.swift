//
//  ViewController.swift
//  peopledex
//
//  Created by Blake Brown on 2018-08-25.
//  Copyright © 2018 Blake Brown. All rights reserved.
//

import UIKit
import SceneKit
import SceneKit.ModelIO
import CoreLocation
import ARKit
import PusherSwift

let pusher = Pusher(
    key: "e683ac5d287400ba35ac",
    options: PusherClientOptions(
        authMethod: .inline(secret: "4ea539cb935d709829c0"),
        host: .cluster("us2")
    )
)

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var statusTextView: UITextView!
    
    let locationManager = CLLocationManager()
    var blakeLocation = CLLocation()
    var franzLocation = CLLocation()
    
    // original position of the 3D model
    var originalTransform:SCNMatrix4!
    var modelNode:SCNNode!
    let rootNodeName = "shipMesh"
    
    var heading : Double! = 0.0
    var distance : Float! = 0.0 {
        didSet {
            setStatusText()
        }
    }

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Start location services
        
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .fitness
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        self.connectToPusher()
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.startUpdatingLocation()
        
        
        
        // Set the initial status
//        status = "Getting user location..."
        
        
        // Set a padding in the text view
//        statusTextView.textContainerInset = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 0.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // sets the y-axis to the direction of gravity as detected by the device
        configuration.worldAlignment = .gravityAndHeading

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func setStatusText() {
//        var text = "Status: \(status!)\n"
        var text = "Distance: \(String(format: "%.2f m", distance))\n"
        text += "Latitude: \(blakeLocation.coordinate.latitude)\n"
        text += "Longitude: \(blakeLocation.coordinate.longitude)\n"
        text += "Franz Latitude: \(franzLocation.coordinate.latitude)\n"
        text += "Franz Longitude: \(franzLocation.coordinate.longitude)\n"
        statusTextView.text = text
    }
    
    
    // Gets the clients location
    //MARK: - CLLocationManager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Implementing this method is required
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            print("requesting location")
        } else {
            print("not requesting location")
        }
    }
    
    // Update Blake's position
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
//            userLocation = location
//            print("(\(location.coordinate.latitude), \(location.coordinate.longitude))")
//            self.distance = Float(franzLocation.distance(from: self.userLocation))
            var locationAdded: Bool
            locationAdded = filterAndAddLocation(location)
            
            if locationAdded{
                //notifiyDidUpdateLocation(newLocation: newLocation)
                blakeLocation = location
                print("Blake Location: (\(location.coordinate.latitude), \(location.coordinate.longitude))")
                self.distance = Float(franzLocation.distance(from: self.blakeLocation))
                if self.modelNode != nil {
                    positionModel()
                }
//                if franzLocation.coordinate.latitude != nil {
//                    positionModel(franzLocation)
//                }
            }
//            print("Got initial location")
//            print(userLocation.coordinate.latitude)
//            print(userLocation.coordinate.longitude)
//            let handle = setTimeout(3, block: { () -> Void in
                // do this stuff after 3 seconds
//            self.status = "Uodated other person's location"
//            self.updateLocation(43.6686301,-79.3932099)
//            self.updateLocation
//            })
//            self.status = "Connecting to pusher..."
        }
    }
    
    func filterAndAddLocation(_ location: CLLocation) -> Bool{
        let age = -location.timestamp.timeIntervalSinceNow
        
        if age > 10{
            return false
        }
        
        if location.horizontalAccuracy < 0{
            return false
        }
        
        if location.horizontalAccuracy > 100{
            return false
        }
        
//        locationDataArray.append(location)
        
        return true
        
    }
    
    // Update Franz's location
    func updateLocation(_ latitude : Double, _ longitude : Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        franzLocation = location
        self.distance = Float(location.distance(from: self.blakeLocation))
//        print(latitude)
//        print(longitude)
//        print("Updating Franz's location")
//        print(latitude)
//        print(longitude)
        print("Franz Location: (\(latitude), \(longitude))")
        if self.modelNode == nil {
            let modelScene = SCNScene(named: "art.scnassets/ship.scn")!
//            let fileUrl = NSURL(string: "model.obj")
//            let fileUrl = NSURL(fileURLWithPath: "model.obj")
//            let fileUrl = URL(string: "model.obj")
//            let rootNode = nodeForURL(url: fileUrl!)
            self.modelNode = modelScene.rootNode.childNode(withName: rootNodeName, recursively: true)!
//            self.modelNode = rootNode.childNode(withName: rootNodeName, recursively: true)!
            // Move model's pivot to its center in the Y axis
            let (minBox, maxBox) = self.modelNode.boundingBox
            self.modelNode.pivot = SCNMatrix4MakeTranslation(0, (maxBox.y - minBox.y)/2, 0)
            // Save original transform to calculate future rotations
            self.originalTransform = self.modelNode.transform
            
            // Position the model in the correct place
            positionModel()
            
            // Add the model to the scene
            sceneView.scene.rootNode.addChildNode(self.modelNode)
            
            // Create arrow from the emoji
            let arrow = makeBillboardNode("⬇️".image()!)
            // Position it on top of the car
            arrow.position = SCNVector3Make(0, 4, 0)
            // Add it as a child of the car model
            self.modelNode.addChildNode(arrow)
        } else {
            // Begin animation
//            SCNTransaction.begin()
//            SCNTransaction.animationDuration = 1.0
            
            // Position the model in the correct place
            positionModel()
            
            // End animation
//            SCNTransaction.commit()
        }
    }
    
    func connectToPusher() {
        // subscribe to channel and bind to event
        let channel = pusher.subscribe("private-channel")
        
        let _ = channel.bind(eventName: "client-new-location", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let latitude = Double(data["latitude"] as! String),
                    let longitude = Double(data["longitude"] as! String) {
//                    let heading = Double(data["heading"] as! String)  {
//                    self.status = "User's location received"
//                    self.heading = heading
                    
                    self.updateLocation(latitude, longitude)
                }
            }
        })
        
//        status = "Connecting to pusher"
        pusher.connect()
//        status = "Waiting to receive location events..."
    }
    
    // Scales the emoji
    func makeBillboardNode(_ image: UIImage) -> SCNNode {
        let plane = SCNPlane(width: 2, height: 2)
        plane.firstMaterial!.diffuse.contents = image
        let node = SCNNode(geometry: plane)
        node.constraints = [SCNBillboardConstraint()]
        return node
    }
    
    func positionModel() {
        // Animate
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1.0
        // Rotate node
        self.modelNode.transform = rotateNode(Float(-1 * (self.heading - 180).toRadians()), self.originalTransform)
        
        // Translate node
        self.modelNode.position = translateNode(franzLocation)
        
        // Scale node
        self.modelNode.scale = scaleNode(franzLocation)
//        Finish animation
        SCNTransaction.commit()
    }
    
    func rotateNode(_ angleInRadians: Float, _ transform: SCNMatrix4) -> SCNMatrix4 {
        let rotation = SCNMatrix4MakeRotation(angleInRadians, 0, 1, 0)
        return SCNMatrix4Mult(transform, rotation)
    }
    
    func scaleNode (_ location: CLLocation) -> SCNVector3 {
//        print("Scaling the plane")
//        print(distance)
//        let scale = min( max( Float(1000/distance), 1.5 ), 3 )
//        let scale = Float(10)
        let scale = Float(0.0000001)
        return SCNVector3(x: scale, y: scale, z: scale)
    }
    
    func translateNode (_ location: CLLocation) -> SCNVector3 {
        let locationTransform =
            transformMatrix(matrix_identity_float4x4, blakeLocation, location)
        return positionFromTransform(locationTransform)
    }
    
    func positionFromTransform(_ transform: simd_float4x4) -> SCNVector3 {
        return SCNVector3Make(
            transform.columns.3.x, transform.columns.3.y, transform.columns.3.z
        )
    }
    
    func transformMatrix(_ matrix: simd_float4x4, _ originLocation: CLLocation, _ driverLocation: CLLocation) -> simd_float4x4 {
        let bearing = bearingBetweenLocations(blakeLocation, driverLocation)
        let rotationMatrix = rotateAroundY(matrix_identity_float4x4, Float(bearing))
        
        let position = vector_float4(0.0, 0.0, -distance, 0.0)
        let translationMatrix = getTranslationMatrix(matrix_identity_float4x4, position)
        
        let transformMatrix = simd_mul(rotationMatrix, translationMatrix)
        
        return simd_mul(matrix, transformMatrix)
    }
    
    func getTranslationMatrix(_ matrix: simd_float4x4, _ translation : vector_float4) -> simd_float4x4 {
        var matrix = matrix
        matrix.columns.3 = translation
        return matrix
    }
    
    func rotateAroundY(_ matrix: simd_float4x4, _ degrees: Float) -> simd_float4x4 {
        var matrix = matrix
        
        matrix.columns.0.x = cos(degrees)
        matrix.columns.0.z = -sin(degrees)
        
        matrix.columns.2.x = sin(degrees)
        matrix.columns.2.z = cos(degrees)
        return matrix.inverse
    }
    
    func bearingBetweenLocations(_ originLocation: CLLocation, _ driverLocation: CLLocation) -> Double {
        let lat1 = originLocation.coordinate.latitude.toRadians()
        let lon1 = originLocation.coordinate.longitude.toRadians()
        
        let lat2 = driverLocation.coordinate.latitude.toRadians()
        let lon2 = driverLocation.coordinate.longitude.toRadians()
        
        let longitudeDiff = lon2 - lon1
        
        let y = sin(longitudeDiff) * cos(lat2);
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(longitudeDiff);
        
        return atan2(y, x)
    }

    // helper function for delaying execution
   func setTimeout(_ delay:TimeInterval, block:@escaping ()->Void) -> Timer {        return Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
    
    func nodeForURL(url: URL) -> SCNNode
    {
        let asset = MDLAsset(url: url)
        let object = asset.object(at: 0)
        let node = SCNNode(mdlObject: object)
        return node
    }
}
