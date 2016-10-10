/**
 * Copyright Red Hat, Inc 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import Socket
import SwiftyJSON

public class Util {
    public class func readInt32(_ value: NSData) -> Int32 {
        var result: Int32 = 0

        let bytes = UnsafeBufferPointer<UInt8>(start: value.bytes.assumingMemoryBound(to: UInt8.self), count: 4)
        for n in 0...3 {
            result = result | (Int32(bytes[n]) << (8 * (3 - n)))
        }

        return result
    }

    public class func intToBytes(_ value: Int32) -> [UInt8] {
        var bytes = [UInt8]()

        var x = 3
        while x >= 0 {
            bytes.append(UInt8(value >> Int32(x * 8)))
            x -= 1
        }
        
        return bytes
    }

    public class func write(from: JSON, to: Socket) throws {
        guard let m = from.rawString() else {
            // TODO: throw
            return
        }
                    
        try write(from: m, to: to)
    }
    
    public class func write(from: String, to sock: Socket) throws {
        var data = [UInt8]()

        //write the size as 4 bytes, big-endian
        data += intToBytes(Int32(from.utf8.count))
        data += from.utf8
        try sock.write(from: data, bufSize: data.count)
    }

    public class func read(from: Socket) throws -> JSON? {
        let data = NSMutableData()

        let cnt = try from.read(into: data)
        var totalRead: Int32 = 0
        if cnt > 0 {
            totalRead += cnt
                
            // read until we at least have the size
            while totalRead < 4 {
                totalRead += try from.read(into: data)
            }
            
            let msgSize = Util.readInt32(data)
            
            // read until we have a full message
            while totalRead < msgSize + 4 {
                totalRead += try from.read(into: data)
            }

            //print("TC: rawMessage = \(String(data: data.subdata(with: NSRange(location: 4, length: Int(msgSize))), encoding: String.Encoding.utf8))")
            return JSON(data: data.subdata(with: NSRange(location: 4, length: Int(msgSize))))
        }

        return nil
    }
}
