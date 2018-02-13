//
//  ViewController.swift
//  closest-beacon
//
//  Created by Eric Mertz on 11/19/17.
//  Copyright © 2017 Eric Mertz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate {
    @IBOutlet weak var candyFlossStatus: UILabel!
    @IBOutlet weak var lemonTartStatus: UILabel!
    @IBOutlet weak var sweetBeetrootStatus: UILabel!
    @IBOutlet weak var estimoteColor: UILabel!
    @IBOutlet weak var colorModeStatus: UILabel!
    
    var colorMode = false
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "Estimotes")
    let DB_URL = "http://msi.apps.northwestern.edu/estimote_beacons.php"
    

    let colors = [
        60321: "Sweet Beetroot",//UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        11755: "Lemon Tart", //UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        36999: "Candy Floss" //UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]
    
    /*
     this is the list of uuids majors and minors
     [CLBeacon (uuid:B9407F30-F5F8-466E-AFF9-25556B57FE6D, major:12543, minor:60321, proximity:2 +/- 0.32m, rssi:-67),
     CLBeacon (uuid:B9407F30-F5F8-466E-AFF9-25556B57FE6D, major:48173, minor:11755, proximity:2 +/- 0.41m, rssi:-69),
     CLBeacon (uuid:B9407F30-F5F8-466E-AFF9-25556B57FE6D, major:44679, minor:36999, proximity:2 +/- 0.60m, rssi:-72)] (regular expression, then split on comma)
    */
    
    
    @IBAction func changeStatus(_ sender: UIButton) {
        if colorMode {
            colorModeStatus.text = "Color Mode: OFF"
            self.view.backgroundColor = UIColor.white
            colorMode = false
        }
        else {
            colorModeStatus.text = "Color Mode: ON"
            colorMode = true
        }
    }
    func convertDistance(_ distance: Double, cap: Int) -> Double{
        let temp = distance/(Double(cap))
        if temp > 1{
            return 1
        }
        return temp
    }
    func getcolors(_ beacons: [CLBeacon], distance: Int) -> [Double]?{
        let indexred = beacons.index(where: { (item) -> Bool in item.minor.intValue == 60321})
        let indexgreen = beacons.index(where: { (item) -> Bool in item.minor.intValue  == 11755})
        let indexblue = beacons.index(where: { (item) -> Bool in item.minor.intValue  == 36999})
//        print(Double(beacons[indexred!].proximity.rawValue))
//        let temp = beacons[indexred!]
//        print(temp)
//        print(temp.accuracy)
        return [convertDistance(beacons[indexred!].accuracy, cap: distance), convertDistance(beacons[indexgreen!].accuracy, cap: distance), convertDistance(beacons[indexblue!].accuracy, cap: distance)]
    }
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon],
                       in region: CLBeaconRegion) {
        if beacons.count == 3, colorMode {
            let colorArray = getcolors(beacons, distance: 4)
            //print(colorArray)
            let r = 255.0 - colorArray![0] * 255
            let g = 255.0 - colorArray![1] * 255
            let b = 255.0 - colorArray![2] * 255
            //print(r/255)
            //print(g)
            //print(b)
            self.view.backgroundColor = UIColor(red: CGFloat(r/255), green: CGFloat(g/255), blue: CGFloat(b/255), alpha: 1)
        }
        //print("hi there")
        if let nearestBeacon = beacons.first {
            estimoteColor.text = colors[nearestBeacon.minor.intValue]
        }
        
        for b in beacons{
            switch (b.minor.intValue)
            {
            case 60321: //Sweet Beetroot
                sweetBeetrootStatus.text = textForProximity(proximity: b.proximity) as String
            case 11755: //Lemon Tart
                lemonTartStatus.text = textForProximity(proximity: b.proximity) as String
            case 36999: //Candy Floss
                candyFlossStatus.text = textForProximity(proximity: b.proximity) as String
            default:
                continue
            }
        }
        for b in beacons{
            //created NSURL
            let requestURL = NSURL(string: DB_URL)
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            
            //getting values from text fields
            let UUID = b.proximityUUID.uuidString
            let majorID = b.major.stringValue
            let minorID = b.minor.stringValue
            let proximity = textForProximity(proximity: b.proximity)
            let accuracy = String(b.accuracy)
            let rssi = String(b.rssi)
            let time_uploaded = String(NSDate().timeIntervalSince1970)
            print(proximity)
            
            //creating the post parameter by concatenating the keys and values from text field
            var postParameters = "UUID="+UUID
            postParameters += "&majorID="+majorID
            postParameters += "&minorID="+minorID
            postParameters += "&proximity="+(proximity as String)
            postParameters += "&accuracy="+accuracy
            postParameters += "&rssi="+rssi
            postParameters += "&time_uploaded="+time_uploaded

            let other = postParameters
            request.httpBody = other.data(using: String.Encoding.utf8)
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                if error != nil{
//                    print("error is \(error)")
                    return;
                }
                //parsing the response
                do {
                    //converting resonse to NSDictionary
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //parsing the json
                    if let parseJSON = myJSON {
                        //creating a string
                        var msg : String!
                        //getting the json response
                        msg = parseJSON["message"] as! String?
                        //printing the response
//                        print(msg)
                    }
                } catch {
//                    print(error)
                }
            }
            //executing the task
            task.resume()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 3. Set the beacon manager's delegate
        self.beaconManager.delegate = self
        // 4. We need to request this authorization for every beacon manager
        self.beaconManager.requestWhenInUseAuthorization()
        
        //self.view.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 122/255, alpha: 1)
        beaconManager.startRangingBeacons(in: beaconRegion)
        
    }
    
    
    func textForProximity(proximity:CLProximity) -> (NSString)
    {
        var distance : NSString!
        
        switch(proximity)
        {
        case .far:
            distance = "far"
            return distance
        case .near:
            distance = "Near"
            return distance
        case .immediate:
            distance = "Immediate"
            return distance
        case .unknown:
            distance = "Unknown"
            return distance
        default:
            break;
        }
        return distance
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeacons(in: self.beaconRegion)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.beaconManager.stopRangingBeacons(in: self.beaconRegion)
    }
    

}

