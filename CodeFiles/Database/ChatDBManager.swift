//
//  ChatDBManager.swift
//  Clikat
//
//  Created by cblmacmini on 6/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import CoreData

enum CoreDataEntity : String {
    case Cart = "Cart"
    case Message = "Message"
    case Addons = "Addons"
}

typealias MessagesCompletionBlock = ([Message]?) -> ()

class ChatDBManager: DBManager {

    static var sharedChatManager = ChatDBManager()
    
    func getMessagesFromDatabase(result : @escaping MessagesCompletionBlock){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Message.rawValue)
        
        coreDataStack.managedObjectContext.perform {
            
            do {
                weak var weakSelf = self
                guard let results = try weakSelf?.coreDataStack.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToMessageArray(arrManagedObject: results) else { return }
                
                result(cartArray)
            }catch let error {
                print(error)
            }
        }
    }
    
    func convertManagedObjectArrayToMessageArray(arrManagedObject : [NSManagedObject]) -> [Message]{
        
        var arrCart : [Message] = []
        for mc in arrManagedObject {
            let message = Message()
            message.userId = mc.value(forKey: ChatKeys.userId.rawValue) as? String
            message.message = mc.value(forKey: ChatKeys.message.rawValue) as? String
            message.adminId = mc.value(forKey: ChatKeys.adminId.rawValue) as? String
            message.type = mc.value(forKey: ChatKeys.type.rawValue) as? String
            message.status =  ChatStatus(rawValue: (mc.value(forKey: ChatKeys.type.rawValue) as? String) ?? "") ?? .None
            arrCart.append(message)
        }
        
        return arrCart
    }
    
    func saveMessges(messages : [Message]?) {
        
        guard let arrMessages = messages else { return }
        
        for message in arrMessages {
            self.saveMessageToCart(entityName: CoreDataEntity.Message.rawValue, message: message)
        }
    }
    
    func saveMessageToCart(entityName : String,message : Message?){
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: (coreDataStack.managedObjectContext)),let tempMessage = message else {
            fatalError("Could not find entity descriptions!")
        }
        
        coreDataStack.managedObjectContext.mergePolicy = NSErrorMergePolicy
        let currentMessage = NSManagedObject(entity: entity, insertInto: coreDataStack.managedObjectContext)
        currentMessage.setValue(tempMessage.userId, forKey: ChatKeys.userId.rawValue)
        currentMessage.setValue(tempMessage.adminId, forKey: ChatKeys.adminId.rawValue)
        currentMessage.setValue(tempMessage.message, forKey: ChatKeys.message.rawValue)
        currentMessage.setValue(tempMessage.status.rawValue, forKey: ChatKeys.status.rawValue)
        currentMessage.setValue(tempMessage.type, forKey: ChatKeys.type.rawValue)
        coreDataStack.saveMainContext()
    }
}
