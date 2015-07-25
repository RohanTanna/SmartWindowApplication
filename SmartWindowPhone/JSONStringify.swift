// Author - Santosh Rajan

import Foundation

let jsonObject: [AnyObject] = [
 ["name": "John", "age": 21],
 ["name": "Bob", "age": 35],
]

func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
    var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
    if NSJSONSerialization.isValidJSONObject(value) {
        if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
            if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                return string as String
            }
        }
    }
    return ""
}

/*
 *  Usage
 */


let jsonString = JSONStringify(jsonObject)
//println(jsonString)
// Prints - [{"age":21,"name":"John"},{"age":35,"name":"Bob"}]

/*
 *  Usage - Pretty Printed
 */


let jsonStringPretty = JSONStringify(jsonObject, prettyPrinted: true)
//println(jsonStringPretty)
/*  Prints the following - 

[
  {
    "age" : 21,
    "name" : "John"
  },
  {
    "age" : 35,
    "name" : "Bob"
  }
]

*/

