//
//  main.swift
//  PicHelper
//
//  Created by Ki MNO on 2023/8/6.
//

import Foundation

func getAllFilePath(_ dirPath: String) -> [String]? {
    var filePaths = [String]()
    
    do {
        let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
        
        for fileName in array {
            var isDir: ObjCBool = true
            
            let fullPath = "\(dirPath)/\(fileName)"
            
            if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                if !isDir.boolValue {
                    filePaths.append(fullPath)
                }
            }
        }
        
    } catch let error as NSError {
        print("get file path error: \(error)")
    }
    
    return filePaths;
}

func runTerminalCommand(command: String) {
    
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]
    task.launch()
    task.waitUntilExit()
    
}

func timeTranslator(time: NSDate) -> String {
    
    // yyyy-MM-dd HH:mm:ss
    let date_new = time as Date
    
    let format_new = DateFormatter.init()
    format_new.dateStyle = .medium
    format_new.timeStyle = .short
    format_new.dateFormat = "MM/dd/yy hh:mm:ss"
    
    return format_new.string(from: date_new)
}


var folderBasePath = ""
folderBasePath = CommandLine.arguments[Int(CommandLine.argc)-1]

print("====================================")
print("Program Work Path: \(folderBasePath)")
print("====================================")

let allfiles = getAllFilePath(folderBasePath)!

if(allfiles.isEmpty) {
    
    print("No file error.")
    
} else {
    
    for filep in allfiles {
        
        let fileAttributes = try FileManager.default.attributesOfItem(atPath: filep)
        print("File \(filep) > ")

        if let creationDate = fileAttributes[FileAttributeKey.creationDate] {
            print("Creation Date: \(creationDate) > ")
        }
            
        if let modificationDate = fileAttributes[FileAttributeKey.modificationDate] {
            print("Modification Date: \(modificationDate) \n")
            let datemod = modificationDate as! NSDate
            let datestring = timeTranslator(time: datemod)
            print(datestring)
            
            print("setfile -d '\(datestring)' \(filep)")
            runTerminalCommand(command: "setfile -d '\(datestring)' \(filep)")
        }
        print("========================================\n")
    }
    
}



