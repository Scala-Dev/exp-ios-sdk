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

        ExpSwift.scala_init("http://develop.exp.scala.com:9000","2c9c7750-4437-4687-bd42-5586f2e8079f","7b674d4ab63e80c62591ef3fcb51da1505f420d2a9ffda8ed5d24aa6384ad1c1f10985a4fc858b046b065bcdacc105dd").then{ result -> Void in
            println(result)
            
            //SENT REQUEST
            var systemChannel = ExpSwift.getChannel(SCALA_SOCKET_CHANNELS.SYSTEM) as! ScalaSystemCh
            var msg:Dictionary<String,String> = ["type": "request", "name": "getCurrentExperience"]
            systemChannel.request(msg).then { obj -> Void in
                            println("request response")
                            println(obj)
            }.catch { error in
                println(error)
            }
            
            var orgchannel = ExpSwift.getChannel(SCALA_SOCKET_CHANNELS.ORGANIZATION) as! ScalaOrgCh
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


        //GET DEVICES
        ExpSwift.getDevices("10","0","name").then { (devices: Array<Device>) -> Void  in
            for device in devices{
                println(device.name)
            }
        }.catch { error in
            println(error)
        }

        //GET DEVICE
        
        ExpSwift.getDevice("8930ff64-1063-4a03-b1bc-33e1ba463d7a").then { (device: Device) -> Void  in
                println(device.name)
            }.catch { error in
                println(error)
        }
        
        //GET EXPERIENCE
        ExpSwift.getExperience("58dc59e4-a44c-4b6e-902b-e6744c09d933").then { (experience: Experience) -> Void  in
            println(experience.name)
        }.catch { error in
                println(error)
        }
        
        //GET EXPERIENCES
        ExpSwift.getExperiences("10","0","name").then { (experiences: Array<Experience>) -> Void  in
            for experience in experiences{
                println(experience.name)
            }
        }.catch { error in
                println(error)
        }

        //GET LOCATION
        ExpSwift.getLocation("3e2e25df-8324-4912-91c3-810751f527a4").then { (location: Location) -> Void  in
            println(location.name)
            }.catch { error in
                println(error)
        }
        
        //GET LOCATIONS
        ExpSwift.getLocations("10","0","name").then { (locations: Array<Location>) -> Void  in
            for location in locations{
                println(location.name)
            }
            }.catch { error in
                println(error)
        }
        
        //GET ZONES
        ExpSwift.getZones("10","0","name").then { (zones: Array<Zone>) -> Void  in
            for zone in zones{
                println(zone.name)
            }
            }.catch { error in
                println(error)
        }
        
        //GET ZONE
        ExpSwift.getZone("1").then { (zone: Zone) -> Void  in
                println(zone.name)
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

