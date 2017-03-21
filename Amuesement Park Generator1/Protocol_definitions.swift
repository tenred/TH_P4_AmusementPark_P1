//
//  Protocol_definitions.swift
//  Amuesement Park Generator1
//
//  Created by Sherief Wissa on 21/3/17.
//  Copyright © 2017 10 Red Hacks Pty Ltd. All rights reserved.
//

import Foundation

protocol Identity{
    
    var firstName: String? { get }
    var lastName: String? { get }
    var addressStreet: String? { get }
    var addressCity: String? { get }
    var addressState: String? { get }
    var addressZip: String? { get }
    var dateOfBirth: String? { get }
    
    //    func convertedDOB() throws -> NSDate
}


protocol PassGenerator {
    
    var entrant: EntrantIdentifiable {get}
    var entrantProfile: Identity {get}
    
    func hasManditoryInfoBeenSupplied() throws -> Bool
    func isEntrantAllowed(inArea: AmusementParkAccessable) -> Permissions
    
}



// MARK: Enum Declaration

// Main Enum Types
protocol EntrantIdentifiable{
    func isAllowedInAreas() -> [AmusementParkAccessable]
    static func allValues() -> [EntrantIdentifiable]
}  // Group all Entrant Types

protocol AmusementParkAccessable{} //Group all Privilage Types

