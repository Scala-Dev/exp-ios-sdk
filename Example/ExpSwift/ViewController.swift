//
//  ViewController.swift
//  ExpSwift
//
//  Created by Cesar Oyarzun on 10/24/2016.
//  Copyright (c) 2016 Cesar Oyarzun. All rights reserved.
//

import UIKit
import ExpSwift

class ViewController: UIViewController {
    
    let host = "https://api-staging.goexp.io"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let host = "https://api-staging.goexp.io"
        // let host = "https://api.goexp.io"
        
        ExpSwift.start(host,user: "cesar.oyarzun@scala.com",password: "5715031Com@",organization: "").then{ result -> Void in
            debugPrint("test")
            
            let document = ExpSwift.auth?.getDocument()
            let channel = ExpSwift.getChannel("device uui",system: false,consumerApp: false)
            //socket connection
            let channel1 = ExpSwift.getChannel("channel1",system: false,consumerApp: true)
            let payload:Dictionary<String,Any> = ["test":"message"]
            channel1.listen("hi", callback: { (resultListen) -> Void in
                debugPrint(".... MESSAGE  RECIEVE ...." + resultListen.description);
            }).then { result -> Void in
                debugPrint(".... SENDING  BROADCAST ....");
                channel1.broadcast("hi", payload: payload, timeout: "2000");
            }
            }.then {result -> Void in
                //
                //            ExpSwift.findContentNodes(["limit":10, "skip":0, "sort":"name", "name": "10-26-2015"]).then { (devices: SearchResults<ContentNode>) -> Void in
                //                for device in devices.getResults() {
                //                    debugPrint(device.get("name"))
                //                }
                //                debugPrint(devices)
                //                }.error { error in
                //                    debugPrint(error)
                //            }
                ExpSwift.getLocation("eaf41ef9-8d34-4656-86c7-c9076049bb74").then { (location: Location) -> Void in

                    debugPrint(location)
                    debugPrint(location.getZones())
                    }.catch { error in
                        
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
        
        
        
        
        
        
        //        //GET DEVICES
        //        ExpSwift.findDevices(["limit":10, "skip":0, "sort":"name"]).then { (devices: SearchResults<Device>) -> Void in
        //            for device in devices.getResults() {
        //                debugPrint(device.get("name"))
        //            }
        //        }.error { error in
        //            debugPrint(error)
        //        }
        //
        ////        //GET DEVICE
        //        ExpSwift.getDevice("8930ff64-1063-4a03-b1bc-33e1ba463d7a").then { (device: Device) -> Void in
        //            debugPrint(device.get("name"))
        //        }.error { error in
        //            debugPrint(error)
        //        }
        //
        ////        //GET EXPERIENCE
        //        ExpSwift.getExperience("58dc59e4-a44c-4b6e-902b-e6744c09d933").then { (experience: Experience) -> Void in
        //            debugPrint(experience.get("name"))
        //        }.error { error in
        //            debugPrint(error)
        //        }
        ////
        ////        //GET EXPERIENCES
        //        ExpSwift.findExperiences(["limit":10, "skip":0, "sort":"name"]).then { (experiences: SearchResults<Experience>) -> Void in
        //            for experience in experiences.getResults() {
        //                debugPrint(experience.get("name"))
        //            }
        //        }.error { error in
        //            debugPrint(error)
        //        }
        ////
        ////        //GET LOCATION
        //        ExpSwift.getLocation("3e2e25df-8324-4912-91c3-810751f527a4").then { (location: Location) -> Void  in
        //            debugPrint(location.get("name"))
        //        }.error { error in
        //            debugPrint(error)
        //        }
        ////
        ////        //GET LOCATIONS
        //        ExpSwift.findLocations(["limit":10, "skip":0, "sort":"name"]).then { (locations: SearchResults<Location>) -> Void in
        //            for location in locations.getResults() {
        //                debugPrint(location.get("name"))
        //            }
        //        }.error { error in
        //            debugPrint(error)
        //        }
        //        
        //        ExpSwift.findFeeds(["limit":2, "skip":0, "sort":"name"]).then { (feeds: SearchResults<Feed>) -> Void in
        //            for feed in feeds.getResults() {
        //                debugPrint(feed.get("name"))
        //                
        //                feed.getData().then { (data) -> Void in
        //                    print(data)
        //                }
        //            }
        //            }.error { error in
        //                debugPrint(error)
        //        }
        //        
        //        //CALLBACK CONNECTION ONLINE
        //        ExpSwift.connection("online", callback: { obj -> Void in
        //            debugPrint(obj)
        //        })
        //        
        //        //CALLBACK CONNECTION OFFLINE
        //        ExpSwift.connection("offline", callback: { obj -> Void in
        //            debugPrint(obj)
        //        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

