//
//  AmusementParkGenerator.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Sherief Wissa on 1/3/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation

// MARK: Protocol Declaration

protocol PassGenerator {

    var firstName: String? { get }
    var lastName: String? { get }
    var addressStreet: String? { get }
    var addressCity: String? { get }
    var addressState: String? { get }
    var addressZip: Int? { get }
    var dateOfBirth: Date? { get }
    
    var entrantProfile: EntrantType { get }
    var entrantSubProfile: PrivilageSubType { get }

    func validateRequiredInfo(forEntrant: EntrantType)
    func generatePass()
    
    }

protocol IdentityAccessManager {}

protocol PassValidator {}


// MARK: Enum Declaration

enum PrivilageType{
    case rideAccess
    case areaAccess
    case discountAccess
}

enum PrivilageSubType{
    case amusementAccess
    case kitchenAccess
    case rideControlAccess
    case maintenanceAccess
    case officeAccess
    case accessAllRides
    case skipAllRideLines
    case foodDiscount (forEntrant: EntrantSubType )
    case merchandiseDiscount (forEntrant: EntrantSubType)

}

enum EntrantType{
    case guest
    case manager
    case vendor
    case employee
}

enum EntrantSubType{
    case classicGuest
    case vipGuest
    case freeChildGuest
    case foodServices
    case rideServices
    case maintenanceServices
    case manager
    case vendor

}


