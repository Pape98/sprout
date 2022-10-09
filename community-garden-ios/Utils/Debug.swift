//
//  Debug.swift
//  community-garden-ios
//
//  Created by Pape Sow Traoré on 08/10/2022.
//

import Foundation
import SwiftyBeaver

class Debug {
    static var log = Debug()
    
    init(){
        let console = ConsoleDestination()
        SwiftyBeaver.addDestination(console)
    }
    
    func verbose(_ message: Any){
        SwiftyBeaver.verbose(message)
    }
    
    func debug(_ message: Any){
        SwiftyBeaver.debug(message)
    }
    
    func info(_ message: Any){
        SwiftyBeaver.info(message)
    }
    
    func warning(_ message: Any){
        print(message)
        SwiftyBeaver.warning(message)
    }
    
    func error(_ message: Any){
        SwiftyBeaver.error(message)
    }
}
