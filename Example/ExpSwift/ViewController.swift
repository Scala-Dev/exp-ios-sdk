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
        let host = "http://api-develop.exp.scala.com"
        
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
        
        //        ExpSwift.start(host,"cesar.oyarzun@scala.com","Com5715031","scala").then{ result -> Void in
        //            //GET CONTENT
        //                    ExpSwift.getContentNode("root").then { (content: ContentNode) -> Void  in
        //                        println(content.document["name"])
        //                        println(content.getUrl())
        //                        content.getChildren().then { (childrens: [ContentNode]) -> Void in
        //                            for child in childrens{
        //                                println(child.getUrl())
        //                            }
        //                            }.catch { error in
        //                                println(error)
        //                            }
        //                        }.catch { error in
        //                            println(error)
        //                    }
        //        }
        
        
        //GET DEVICES
        ExpSwift.getDevices(["limit":10, "skip":0, "sort":"name"]).then { (devices: SearchResults<Device>) -> Void in
            for device in devices.getResults() {
                println(device.getDocuent()["name"])
            }
        }.catch { error in
            println(error)
        }
        
        //GET DEVICE
        
        ExpSwift.getDevice("8930ff64-1063-4a03-b1bc-33e1ba463d7a").then { (device: Device) -> Void in
            println(device.getDocuent()["name"])
        }.catch { error in
            println(error)
        }
        
        //GET EXPERIENCE
        ExpSwift.getExperience("58dc59e4-a44c-4b6e-902b-e6744c09d933").then { (experience: Experience) -> Void in
            println(experience.getDocuent()["name"])
        }.catch { error in
            println(error)
        }
        
        //GET EXPERIENCES
        ExpSwift.getExperiences(["limit":10, "skip":0, "sort":"name"]).then { (experiences: SearchResults<Experience>) -> Void in
            for experience in experiences.getResults() {
                println(experience.getDocuent()["name"])
            }
        }.catch { error in
            println(error)
        }
        
        //GET LOCATION
        ExpSwift.getLocation("3e2e25df-8324-4912-91c3-810751f527a4").then { (location: Location) -> Void  in
            println(location.getDocuent()["name"])
        }.catch { error in
            println(error)
        }
        
        //GET LOCATIONS
        ExpSwift.findLocations(["limit":10, "skip":0, "sort":"name"]).then { (locations: SearchResults<Location>) -> Void in
            for location in locations.getResults() {
                println(location.getDocuent()["name"])
            }
        }.catch { error in
            println(error)
        }
        
        //GET ZONES
        ExpSwift.findZones(["limit":10, "skip":0, "sort":"name"]).then { (zones: SearchResults<Zone>) -> Void in
            for zone in zones.getResults() {
                println(zone.getDocuent()["name"])
            }
        }.catch { error in
            println(error)
        }
        
        //GET ZONE
        ExpSwift.getZone("1").then { (zone: Zone) -> Void in
            println(zone.getDocuent()["name"])
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

