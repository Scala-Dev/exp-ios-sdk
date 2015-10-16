//
//  ViewController.swift
//  ExpSwift
//
//  Created by Cesar Oyarzun on 09/04/2015.
//  Copyright (c) 2015 Cesar Oyarzun. All rights reserved.
//

import UIKit
import ExpSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        let host = "http://api.develop.exp.scala.com:9000"
        //        let host = "http://develop.exp.scala.com:9000"
        let host = "https://api-develop.exp.scala.com"
        
        ExpSwift.start(host,"74c05552-5b9f-4d06-a3f8-8299ff1e1e3a","7b674d4ab63e80c62591ef3fcb51da1505f420d2a9ffda8ed5d24aa6384ad1c1f10985a4fc858b046b065bcdacc105dd").then{ result -> Void in
            
            //SENT REQUEST
            var systemChannel = ExpSwift.getChannel(SOCKET_CHANNELS.SYSTEM) as! SystemChannel
            var msg:Dictionary<String,String> = ["type": "request", "name": "getCurrentExperience"]
            systemChannel.request(msg).then { obj -> Void in
                println("request response")
                println(obj)
            }.catch { error in
                println(error)
            }
            
            var orgchannel = ExpSwift.getChannel(SOCKET_CHANNELS.ORGANIZATION) as! OrganizationChannel
            //SEND BROADCAS MESSAGE
            var payload:Dictionary<String,String> = ["opening":"knock knock?"]
            var msg2:Dictionary<String,AnyObject> = ["name": "testing","payload":payload]
            orgchannel.broadcast(msg2)
            
            //LISTEN FOR BROADCAST MESSAGE
            var msg1:Dictionary<String,AnyObject> = ["name": "testing"]
            orgchannel.listen(msg1,  callback: { (resultListen) -> Void in
                println(resultListen)
            })
        }
        
        
        //USER PASSS START
        
//                ExpSwift.start(host,"cesar.oyarzun@scala.com","5715031Com","scala").then{ result -> Void in
                    //GET CONTENT
                    //GET CONTENT DETAIL PRODUCT COLLECTION
//                    ExpSwift.getContentNode("abf651e6-44ca-4e71-a074-23245f44f6d9").then { (content: ContentNode) -> Void  in
//                        content.getChildren().then { (childrens: [ContentNode]) -> Void in
//                            for child in childrens{
//                                println(child)
//                                println(child.getVariantUrl("100.png"))
//                                let url = NSURL(string:child.getVariantUrl("100.png"))
//                                let data = NSData(contentsOfURL: url!)
//                                //                    var image = UIImage(data: data!)
//                                //                    self.product_options.append(image!)
//                            }
//                            //                self.collectionView.reloadData()
//                        }
//                    }
//        }
        
      
        
        
        //GET DEVICES
        ExpSwift.findDevices(["limit":10, "skip":0, "sort":"name"]).then { (devices: SearchResults<Device>) -> Void in
            for device in devices.getResults() {
                println(device.get("name"))
            }
        }.catch { error in
            println(error)
        }
        
        //GET DEVICE
        ExpSwift.getDevice("8930ff64-1063-4a03-b1bc-33e1ba463d7a").then { (device: Device) -> Void in
            println(device.get("name"))
        }.catch { error in
            println(error)
        }
        
        //GET EXPERIENCE
        ExpSwift.getExperience("58dc59e4-a44c-4b6e-902b-e6744c09d933").then { (experience: Experience) -> Void in
            println(experience.get("name"))
        }.catch { error in
            println(error)
        }
        
        //GET EXPERIENCES
        ExpSwift.findExperiences(["limit":10, "skip":0, "sort":"name"]).then { (experiences: SearchResults<Experience>) -> Void in
            for experience in experiences.getResults() {
                println(experience.get("name"))
            }
        }.catch { error in
            println(error)
        }

        //GET LOCATION
        ExpSwift.getLocation("3e2e25df-8324-4912-91c3-810751f527a4").then { (location: Location) -> Void  in
            println(location.get("name"))
        }.catch { error in
            println(error)
        }
        
        //GET LOCATIONS
        ExpSwift.findLocations(["limit":10, "skip":0, "sort":"name"]).then { (locations: SearchResults<Location>) -> Void in
            for location in locations.getResults() {
                println(location.get("name"))
            }
        }.catch { error in
            println(error)
        }
        
        //CALLBACK CONNECTION ONLINE
        ExpSwift.connection("online", { obj -> Void in
            println(obj)
        })
        
        //CALLBACK CONNECTION OFFLINE
        ExpSwift.connection("offline", { obj -> Void in
            println(obj)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

