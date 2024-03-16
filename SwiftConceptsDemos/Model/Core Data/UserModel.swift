//
//  UsersModel.swift
//  SwiftConceptsDemos
//
//  Created by ETechM23 on 07/03/24.
//

import Foundation

struct UserModel: Codable, Identifiable {
    var id = UUID().uuidString
    var srNoStr: String
    var email: String
    var password: String
    var username: String
    var createdAt: Date = .now
    
    var srNo: Int32 {
        return Int32(srNoStr) ?? Int32.random(in: 1...999)
    }
}
