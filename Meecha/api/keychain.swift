//
//  keychain.swift
//  auth-test
//
//  Created by mattuu0 on 2025/05/18.
//

import Foundation

func saveKeyChain(tag:String, value:String) -> Bool{
    guard let data = value.data(using: .utf8) else {
        return false
    }
    
    let saveQurry:[String:Any] = [
        kSecClass               as String : kSecClassKey,
        kSecAttrApplicationTag  as String : tag,
        kSecValueData           as String : data
    ]
    
    let searchQuery:[String:Any] = [
        kSecClass               as String : kSecClassKey,
        kSecAttrApplicationTag  as String : tag,
        kSecReturnAttributes    as String : true
    ]
    
    // 検索実行
    let matchingstatus = SecItemCopyMatching( searchQuery as CFDictionary, nil)
    
    //
    var itemAddStatus : OSStatus
    if matchingstatus == errSecItemNotFound {
        // save
        itemAddStatus = SecItemAdd(saveQurry as CFDictionary, nil)
    } else if matchingstatus == errSecSuccess {
        // 更新(削除してから新規登録)
        
        //delete
        if SecItemDelete(saveQurry as CFDictionary) == errSecSuccess{
            print("削除成功")
        }else{
            print("削除失敗")
        }
        
        // save
        itemAddStatus = SecItemAdd(saveQurry as CFDictionary, nil)
    }else{
        return false
    }
    
    // check status
    if itemAddStatus == errSecSuccess{
        print("正常終了")
    } else {
        return false
    }
    
    return true
    
}


func deleteKeyChain(tag:String) -> Bool{
    
    let saveQurry:[String:Any] = [
        kSecClass               as String : kSecClassKey,
        kSecAttrApplicationTag  as String : tag,
        //kSecValueData           as String : ""
    ]
    
    let searchQuery:[String:Any] = [
        kSecClass               as String : kSecClassKey,
        kSecAttrApplicationTag  as String : tag,
        kSecReturnAttributes    as String : true
    ]
    
    // 検索実行
    let matchingstatus = SecItemCopyMatching( searchQuery as CFDictionary, nil)
    
    if matchingstatus == errSecItemNotFound {
        return false
    } else if matchingstatus == errSecSuccess {
        //delete
        if SecItemDelete(saveQurry as CFDictionary) == errSecSuccess{
            return true
        }else{
            return false
        }
        
    }else{
        return false
    }
    
}

func getKeyChain(key:String) -> String?{    
    let searchQuery:[String:Any] = [
        kSecClass               as String : kSecClassKey,
        kSecAttrApplicationTag  as String : key,
        kSecReturnData          as String : kCFBooleanTrue as Any,
        kSecReturnAttributes    as String : true
    ]
    
    var item: AnyObject?
    let status = SecItemCopyMatching(searchQuery as CFDictionary, &item)
    guard status == errSecSuccess else {
        return nil
    }
    let d = item as? NSDictionary
    
    guard let keyData = d!["v_Data"]! as? Data else {
        fatalError("Key was found, but can't be convert to expected object ")
    }
    let value = String(data: keyData, encoding: .utf8)!
    return value
    
}


