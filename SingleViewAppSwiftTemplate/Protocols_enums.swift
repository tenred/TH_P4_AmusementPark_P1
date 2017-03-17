//
//  Protocols_enums.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Sherief Wissa on 17/3/17.
//  Copyright © 2017 Treehouse. All rights reserved.
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
protocol EntrantIdentifiable{}  // Group all Entrant Types
protocol AmusementParkAccessable{} //Group all Privilage Types


enum Permissions{
    case accessGranted
    case accessDenied
}

enum EntrantInfoFields: String {
    case firstName = "First Name"
    case lastName = "Last Name"
    case addressStreet = "Street Address"
    case addressCity = "City"
    case addressState = "State"
    case addressZip = "Zip Code"
    case dateOfBirth = "Date of Birth"
    
    func isFieldManditory(forEntrant: EntrantIdentifiable) -> Bool {
        
        switch forEntrant {
        case GuestType.classic,GuestType.VIP:
            return false
            
        case GuestType.freeChild:
            let infoReqArr = [EntrantInfoFields.dateOfBirth]
            return infoReqArr.contains(self)
            
        case EmployeeType.foodServices, EmployeeType.rideServices, EmployeeType.maintenanceServices, ManagerType.manager:
            let infoReqArr = [EntrantInfoFields.firstName,EntrantInfoFields.lastName,EntrantInfoFields.addressStreet,EntrantInfoFields.addressCity,EntrantInfoFields.addressState,EntrantInfoFields.addressZip]
            return infoReqArr.contains(self)
            
        default:
            return false
        }
    }
}

enum RideAccessType: AmusementParkAccessable{
    case skipAllRideLines
    case accessAllRides
}

enum AreaAccessType: AmusementParkAccessable{
    case amusementAreas
    case kitchen
    case rideCotnrol
    case maintenance
    case office
}

enum DiscountAccessType: AmusementParkAccessable{
    case food
    case merchandise
    
    func percentageDiscount(forEntrant: EntrantIdentifiable) -> Double{
        
        switch self{
        case .food:
            
            switch forEntrant {
            case GuestType.classic,GuestType.freeChild:
                return 0.0
            case GuestType.VIP:
                return 0.10
            case EmployeeType.foodServices,EmployeeType.rideServices,EmployeeType.maintenanceServices:
                return 0.15
            case ManagerType.manager:
                return 0.25
            default:
                return 0
            }
            
        case .merchandise:
            
            switch forEntrant {
            case GuestType.classic,GuestType.freeChild:
                return 0.0
            case GuestType.VIP:
                return 0.20
            case EmployeeType.foodServices,EmployeeType.rideServices,EmployeeType.maintenanceServices,ManagerType.manager:
                return 0.25
            default:
                return 0
            }
            
        }
    }
}

enum GuestType: EntrantIdentifiable{
    case classic
    case VIP
    case freeChild
    
    func isAllowedInAreas() -> [AmusementParkAccessable]{
        
        switch self{
        case .classic:
            return [AreaAccessType.amusementAreas,
                    RideAccessType.accessAllRides]
        case .VIP:
            return [AreaAccessType.amusementAreas,
                    RideAccessType.accessAllRides,
                    RideAccessType.skipAllRideLines,
                    DiscountAccessType.food,
                    DiscountAccessType.merchandise]
        case .freeChild:
            return [AreaAccessType.amusementAreas,
                    RideAccessType.accessAllRides]
            
        }
        
    }
}

enum ManagerType: EntrantIdentifiable{
    case manager
    
    func isAllowedInAreas() -> [AmusementParkAccessable]{
        switch self {
        case .manager:
            return [AreaAccessType.amusementAreas,
                    AreaAccessType.kitchen,
                    AreaAccessType.kitchen,
                    AreaAccessType.rideCotnrol,
                    AreaAccessType.maintenance,
                    AreaAccessType.office,
                    RideAccessType.accessAllRides,
                    DiscountAccessType.food,
                    DiscountAccessType.merchandise]
        }
    }
}

enum EmployeeType: EntrantIdentifiable{
    case foodServices
    case rideServices
    case maintenanceServices
    
    func isAllowedInAreas() -> [AmusementParkAccessable]{
        switch self {
        case .foodServices:
            return [AreaAccessType.amusementAreas,
                    AreaAccessType.kitchen,
                    RideAccessType.accessAllRides,
                    DiscountAccessType.food,
                    DiscountAccessType.merchandise]
        case .rideServices:
            return [AreaAccessType.amusementAreas,
                    AreaAccessType.rideCotnrol,
                    RideAccessType.accessAllRides,
                    DiscountAccessType.food,
                    DiscountAccessType.merchandise]
        case .maintenanceServices:
            return [AreaAccessType.amusementAreas,
                    AreaAccessType.kitchen,
                    AreaAccessType.rideCotnrol,
                    AreaAccessType.maintenance,
                    RideAccessType.accessAllRides,
                    DiscountAccessType.food,
                    DiscountAccessType.merchandise]
        }
    }
}

enum VendorType: EntrantIdentifiable{
    case vendor
}


enum MissingInformation: Error{
    case missingRequiredField(Array<EntrantInfoFields>)
    case conversionError(EntrantInfoFields)
}

enum ErrorTypeCasting: Error{
    case UnknownUserType (String)
}
