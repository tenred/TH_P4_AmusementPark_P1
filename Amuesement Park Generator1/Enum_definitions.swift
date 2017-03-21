//
//  Enum_definitions.swift
//  Amuesement Park Generator1
//
//  Created by Sherief Wissa on 21/3/17.
//  Copyright © 2017 10 Red Hacks Pty Ltd. All rights reserved.
//

import Foundation

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
    
    static func allInfoFields() -> [EntrantInfoFields]{
        return [.firstName,.lastName, .addressStreet, .addressCity, .addressState, .addressZip, .dateOfBirth]
    }
    
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

enum GuestType:String, EntrantIdentifiable{
    
    case classic = "Classic"
    case VIP = "VIP"
    case freeChild = "Free Child"
    
    static func allValues() -> [EntrantIdentifiable]{
        return [self.classic,self.VIP,self.freeChild]
    }
    
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

enum ManagerType:String, EntrantIdentifiable{
    case manager = "Manager"
    
    static func allValues() -> [EntrantIdentifiable]{
        return [self.manager]
    }
    
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

enum EmployeeType:String, EntrantIdentifiable{
    case foodServices = "Food Services"
    case rideServices = "Ride Services"
    case maintenanceServices = "Maintenance Services"
    
    static func allValues() -> [EntrantIdentifiable]{
        return [self.foodServices,self.rideServices,self.maintenanceServices]
    }
    
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

enum VendorType:String, EntrantIdentifiable{
    
    case vendor
    
    func isAllowedInAreas() -> [AmusementParkAccessable] {
        return [AreaAccessType.amusementAreas]
    }
    
    static func allValues() -> [EntrantIdentifiable] {
        return [self.vendor]
    }
    
    
}


enum MissingInformation: Error{
    case missingRequiredField(Array<EntrantInfoFields>)
    case conversionError(EntrantInfoFields)
}

enum ErrorTypeCasting: Error{
    case UnknownUserType (String)
}
