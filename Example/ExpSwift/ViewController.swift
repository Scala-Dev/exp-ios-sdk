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
        
        ExpSwift.start(host,uuid: "5251de59-6123-4789-b73f-d4120174c7ac",secret: "442beccac548a7c97021b005d45e681eeb9cb82fddb38539e7149f196eda18d6e38508e8ff77a4e082c14b34c0c234c2").then{ result -> Void in
            
            //SENT REQUEST
            let systemChannel = ExpSwift.getChannel(SOCKET_CHANNELS.SYSTEM) as! SystemChannel
            let msg:Dictionary<String,String> = ["type": "request", "name": "getCurrentExperience"]
            systemChannel.request(msg).then { obj -> Void in
                debugPrint("request response")
                debugPrint(obj)
            }.error { error in
                debugPrint(error)
            }
            
            let orgchannel = ExpSwift.getChannel(SOCKET_CHANNELS.ORGANIZATION) as! OrganizationChannel
            //SEND BROADCAS MESSAGE
            let payload:Dictionary<String,String> = ["opening":"knock knock?"]
            let msg2:Dictionary<String,AnyObject> = ["name": "testing","payload":payload]
            orgchannel.broadcast(msg2)
            
            //LISTEN FOR BROADCAST MESSAGE
            let msg1:Dictionary<String,AnyObject> = ["name": "testing"]
            orgchannel.listen(msg1,  callback: { (resultListen) -> Void in
                debugPrint(resultListen)
            })
            
           
         }.then {result -> Void in
            ExpSwift.findDevices(["limit":10, "skip":0, "sort":"name"]).then { (devices: SearchResults<Device>) -> Void in
                for device in devices.getResults() {
                    debugPrint(device.get("name"))
                }
                debugPrint(devices)
            }.error { error in
                debugPrint(error)
            }

            ExpSwift.getDevice("5251de59-6123-4789-b73f-d4120174c7ac").then { (device: Device) -> Void in
                debugPrint(device)
            }.error { error in
                debugPrint(error)
            }
            
            ExpSwift.getContentNode("root").then { (content: ContentNode) -> Void  in
                print(content.get("path"))
                content.getChildren().then { (children: [ContentNode]) -> Void in
                    for child in children{
                        print(child.get("path"))
                        child.getChildren().then { (children: [ContentNode]) -> Void in
                            for child in children{
                                print(child.get("path"))
                            }
                        }.error { error in
                            print(error)
                        }
                    }
                }.error { error in
                    print(error)
                }
                
            }.error { error in
                print(error)
            }
        }
        
        
        //USER PASSS START
        
//                ExpSwift.start(host,user: "cesar.oyarzun@scala.com",password: "5715031Com",organization: "scala").then{ result -> Void in
////                    GET CONTENT
////                    GET CONTENT DETAIL PRODUCT COLLECTION
//                    ExpSwift.getContentNode("abf651e6-44ca-4e71-a074-23245f44f6d9").then { (content: ContentNode) -> Void  in
//                        content.getChildren().then { (childrens: [ContentNode]) -> Void in
//                            for child in childrens{
////                                debugPrint(child)
////                                debugPrint(child.getVariantUrl("100.png"))
////                                let url = NSURL(string:child.getVariantUrl("100.png"))
////                                let data = NSData(contentsOfURL: url!)
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
                debugPrint(device.get("name"))
            }
        }.error { error in
            debugPrint(error)
        }
        
//        //GET DEVICE
        ExpSwift.getDevice("8930ff64-1063-4a03-b1bc-33e1ba463d7a").then { (device: Device) -> Void in
            debugPrint(device.get("name"))
        }.error { error in
            debugPrint(error)
        }
        
//        //GET EXPERIENCE
        ExpSwift.getExperience("58dc59e4-a44c-4b6e-902b-e6744c09d933").then { (experience: Experience) -> Void in
            debugPrint(experience.get("name"))
        }.error { error in
            debugPrint(error)
        }
//
//        //GET EXPERIENCES
        ExpSwift.findExperiences(["limit":10, "skip":0, "sort":"name"]).then { (experiences: SearchResults<Experience>) -> Void in
            for experience in experiences.getResults() {
                debugPrint(experience.get("name"))
            }
        }.error { error in
            debugPrint(error)
        }
//
//        //GET LOCATION
        ExpSwift.getLocation("3e2e25df-8324-4912-91c3-810751f527a4").then { (location: Location) -> Void  in
            debugPrint(location.get("name"))
        }.error { error in
            debugPrint(error)
        }
//
//        //GET LOCATIONS
        ExpSwift.findLocations(["limit":10, "skip":0, "sort":"name"]).then { (locations: SearchResults<Location>) -> Void in
            for location in locations.getResults() {
                debugPrint(location.get("name"))
            }
        }.error { error in
            debugPrint(error)
        }
        
        //CALLBACK CONNECTION ONLINE
        ExpSwift.connection("online", callback: { obj -> Void in
            debugPrint(obj)
        })
        
        //CALLBACK CONNECTION OFFLINE
        ExpSwift.connection("offline", callback: { obj -> Void in
            debugPrint(obj)
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

