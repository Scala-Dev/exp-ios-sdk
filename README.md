# ExpSwift

[![CI Status](http://img.shields.io/travis/Cesar Oyarzun/ExpSwift.svg?style=flat)](https://travis-ci.org/Cesar Oyarzun/ExpSwift)
[![Version](https://img.shields.io/cocoapods/v/ExpSwift.svg?style=flat)](http://cocoapods.org/pods/ExpSwift)
[![License](https://img.shields.io/cocoapods/l/ExpSwift.svg?style=flat)](http://cocoapods.org/pods/ExpSwift)
[![Platform](https://img.shields.io/cocoapods/p/ExpSwift.svg?style=flat)](http://cocoapods.org/pods/ExpSwift)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ExpSwift is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ExpSwift"
```
### ExpSwift.scala_init(host,uuid,secret)

```swift
import ExpSwift

 ExpSwift.scala_init("http://develop.exp.scala.com:9000","2c9c7750-4437-4687-bd42-5586f2e8079f",
 "7b674d4ab63e80c62591ef3fcb51da1505f420d2a9ffda8ed5d24aa6384ad1c1f10985a4fc858b046b065bcdacc105dd").then{ result -> Void in
            println(result)
            }.catch { error in
                println(error)
            }

```

# ExpSwift.connection
### ExpSwift.connection(name, callback)
Attaches a listener for connection events. The possible events are `online` (when a connection is established to EXP) and `offline` (when the connection to EXP is lost).

```swift
ExpSwift.connection("online", { obj -> Void in
            println(obj)
        })
        
ExpSwift.connection("offline", { obj -> Void in
            println(obj)
        })

```

### scala.channels

There are four channels available:
- "system": Messages to/from the system. 
- "organization": Messages to/from devices across the organization.
- "experience": Messages to/from devices in the current experience.
- "location": Messages to/from devices in the current location.

### How to get channels
```swift
var orgchannel = ExpSwift.getChannel(SCALA_SOCKET_CHANNELS.ORGANIZATION) as! ScalaOrgCh 
var systemChannel = ExpSwift.getChannel(SCALA_SOCKET_CHANNELS.SYSTEM) as! ScalaSystemCh

```
###  [Channel].listen(options, callback)
Register a callback for a message on this channel.
```swift
//LISTEN FOR BROADCAST MESSAGE
var orgchannel = ExpSwift.getChannel(SCALA_SOCKET_CHANNELS.ORGANIZATION) as! ScalaOrgCh
            var msg1:Dictionary<String,AnyObject> = ["name": "test"]
            orgchannel.listen(msg1,  callback: { (resultListen) -> Void in
                            println(resultListen)
            })
```
### [Channel].broadcast(options)
Broadcast a message out on this channel. 
```swift
 //SEND BROADCAS MESSAGE
var orgchannel = ExpSwift.getChannel(SCALA_SOCKET_CHANNELS.ORGANIZATION) as! ScalaOrgCh
            var payload:Dictionary<String,String> = ["opening":"knock knock?"]
            var msg2:Dictionary<String,AnyObject> = ["name": "testing","payload":payload]
            orgchannel.broadcast(msg2)
```
Broadcasts can be recieved by any device that is connected to the same organization/experience/location on the given channel

### [Channel].request(options)
Send a request to another device. Returns a promise.
```swift
 //SENT REQUEST
            var systemChannel = ExpSwift.getChannel(SCALA_SOCKET_CHANNELS.SYSTEM) as! ScalaSystemCh
            var msg:Dictionary<String,String> = ["type": "request", "name": "getCurrentExperience"]
            systemChannel.request(msg).then { obj -> Void in
                            println(obj)
            }.catch { error in
                println(error)
            }
```
For non-system channels, the target should be a [Device Object](#device-object). For the system channel, no target is necessary.

Requests can only reach devices that share the same organization/experience/location for the given channel.

### [Channel].respond(options, callback)
Respond to a request. The callback can throw an error to respond with an error. The callback can also return a promise.
```swift
//RESPOND  MESSAGE
var orgchannel = ExpSwift.getChannel(SCALA_SOCKET_CHANNELS.ORGANIZATION) as! ScalaOrgCh
            var msg1:Dictionary<String,AnyObject> = ["name": "testing"]
            orgchannel.respon(msg1, callback:{ (resultListen) -> Void in
                println(resultListen)
            })

```
Response callbacks will only be triggered when the request was sent on the same channel.

# scala.api
### ExpSwift.getCurrentDevice()
Get the current device. Resolves to a [Device Object](#device-object).
```swift
//GET CURRENT DEVICE
        ExpSwift.getCurrentDevice().then { device -> Void  in
            println(device)
            }.catch { error in
                println(error)
        }
```
### ExpSwift.getDevice(uuid:String)
Get a single device by UUID. Resolves to a [Device Object](#device-object).
```swift
 //GET DEVICE
        ExpSwift.getDevice("8930ff64-1063-4a03-b1bc-33e1ba463d7a").then { (device: Device) -> Void  in
                println(device.name)
            }.catch { error in
                println(error)
        }
```

### ExpSwift.getDevices(limit:String,skip:String,sort:String)
Query for multiple devices. Resolves to an array of [Device Objects](#device-object).
```swift
 //GET DEVICES
        ExpSwift.getDevices("10","0","name").then { (devices: Array<Device>) -> Void  in
            for device in devices{
                println(device.name)
            }
        }.catch { error in
            println(error)
        }
```
### ExpSwift.getCurrentExperience()
Get the current experience. Resolves to an [Experience Object](#experience-object).
```swift
//GET CURRENT EXPERIENCE
        ExpSwift.getCurrentDevice().then { experience -> Void  in
            println(experience)
            }.catch { error in
                println(error)
        }
```
### ExpSwift.getExperience(uuid:String)
Get a single experience by UUID. Resolves to a [Experience Object](#experience-object).
```swift
//GET EXPERIENCE
        ExpSwift.getExperience("58dc59e4-a44c-4b6e-902b-e6744c09d933").then { (experience: Experience) -> Void  in
            println(experience.name)
        }.catch { error in
                println(error)
        }
```
### ExpSwift.getExperiences(limit:String,skip:String,sort:String)
Query for multiple experiences. Resolves to an array of [Experience Objects](#experience-object).
```swift
 //GET EXPERIENCES
        ExpSwift.getExperiences("10","0","name").then { (experiences: Array<Experience>) -> Void  in
            for experience in experiences{
                println(experience.name)
            }
        }.catch { error in
                println(error)
        }

```

### ExpSwift.getLocation(uuid:String)
Get a single location by UUID. Resolves to a [Location Object](#location-object).
```swift
 //GET LOCATION
        ExpSwift.getLocation("3e2e25df-8324-4912-91c3-810751f527a4").then { (location: Location) -> Void  in
            println(location.name)
            }.catch { error in
                println(error)
        }

```

### ExpSwift.getLocations(limit:String,skip:String,sort:String)
Query for multiple locations. Resolves to an array of [Location Objects](#location-object).
```swift
//GET LOCATIONS
        ExpSwift.getLocations("10","0","name").then { (locations: Array<Location>) -> Void  in
            for location in locations{
                println(location.name)
            }
            }.catch { error in
                println(error)
        }

```

### ExpSwift.getZone(uuid:String)
Get a single zone by UUID. Resolves to a [Zone Object](#zone-object).
```swift
//GET ZONE
        ExpSwift.getZone("1").then { (zone: Zone) -> Void  in
                println(zone.name)
            }.catch { error in
                println(error)
        }

```

### ExpSwift.getZones(limit:String,skip:String,sort:String)
Query for multiple zones. Resolves to an array of [Zone Objects](#zone-object).
```swift
//GET ZONES
        ExpSwift.getZones("10","0","name").then { (zones: Array<Zone>) -> Void  in
            for zone in zones{
                println(zone.name)
            }
            }.catch { error in
                println(error)
        }

```
# Abstract API Objects

### Device Object

##### device.uuid
The devices UUID


### Location Object

##### location.uuid
The location's UUID.


### Zone Object
##### zone.uuid
The zone's UUID.



## Author

Cesar Oyarzun, cesar.oyarzun@scala.com

## License

ExpSwift is available under the MIT license. See the LICENSE file for more info.