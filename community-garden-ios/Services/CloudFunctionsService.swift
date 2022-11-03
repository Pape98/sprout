//
//  CloudFunctionsService.swift
//  community-garden-ios
//
//  Created by Pape Sow Traore on 11/2/22.
//

import Foundation
import FirebaseFunctions

class CloudFunctionsService {
    static let shared = CloudFunctionsService()
    lazy var functions = Functions.functions()
    
    func sendMessageToTopic(data: [String: Any]){
        functions.httpsCallable("sendMessageToTopic").call(data) { result, error in
            if let error = error as NSError? {
                if error.domain == FunctionsErrorDomain {
                    Debug.log.error("sendMessageToTopic error",error.localizedDescription)
                }
            }
            if let data = result?.data as? [String: Any], let text = data["text"] as? String {
                Debug.log.debug("sendMessageToTopic data",text)
            }
        }
    }
    
}
