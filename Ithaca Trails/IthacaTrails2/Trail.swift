//
//  Trail.swift
//  IthacaTrails2
//
//  Created by Justin Gu on 12/7/20.
//

import Foundation

struct Activity: Codable {
    public var id: Int
    public var name : String
}

struct Review : Codable{
    public var id : Int
    public var title : String?
    public var username : String
    public var body: String
    public var rating: Int
    public var trail: Trail?
    public var comments: [String]?
    public var imageUrl: String?
}

struct Trail : Codable, Equatable{
    static func == (lhs: Trail, rhs: Trail) -> Bool {
        return lhs.name == rhs.name
    }
    public var id : Int
    public var name : String
    public var imageUrl : String
    public var latitude : Float
    public var longitude : Float
    public var length : Float
    public var rating: Int
    public var difficulty : String
    public var activities : [Activity]?
    public var reviews : [Review]?
    public var description: String

}

struct Response<T: Codable>: Codable {
    public var success: Bool
    public var data: T
}
