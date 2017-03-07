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
    
    var IdentityAccessProfile: AccessManager { get }
    
    func validateRequiredInfo(forEntrant: EntrantType)
    func generatePass()
    
}

protocol AccessManager {
    var entrant: EntrantType { get }
    var entrantProfile: EntrantProfileType { get }
    
    }

protocol PassValidator {}


// MARK: Enum Declaration

enum PrivilageType{
    case ride
    case area
    case discount
    
    func areaAccess() -> [PrivilageSubType]{
        
        switch self{
        case .ride:
            return [.skipAllRideLines, .accessAllRides]
        case .area:
            return [.amusementAccess, .kitchenAccess, .rideControlAccess, .maintenanceAccess, .officeAccess]
        case .discount:
            return [.foodDiscount(forEntrant: .empltyPlaceHolder), .merchandiseDiscount(forEntrant: .empltyPlaceHolder)]
        }
    }
}

enum PrivilageSubType{
    case amusementAccess
    case kitchenAccess
    case rideControlAccess
    case maintenanceAccess
    case officeAccess
    case accessAllRides
    case skipAllRideLines
    case foodDiscount (forEntrant: EntrantProfileType )
    case merchandiseDiscount (forEntrant: EntrantProfileType)
    
    func percentageDiscount() -> Double{
        
        switch self{
            case .foodDiscount(let entrant):
            
                switch entrant {
                    case .classicGuest:
                        return 0.0
                    case .vipGuest:
                        return 0.10
                    case .freeChildGuest:
                        return 0
                    case .foodServices:
                        return 0.15
                    case .rideServices:
                        return 0.15
                    case .maintenanceServices:
                        return 0.15
                    case .manager:
                        return 0.25
                    case .vendor:
                        return 0.0
                    default:
                        return 0
                }
            
        case .merchandiseDiscount(let entrant):
            
            switch entrant {
                case .classicGuest:
                    return 0.0
                case .vipGuest:
                    return 0.20
                case .freeChildGuest:
                    return 0
                case .foodServices:
                    return 0.25
                case .rideServices:
                    return 0.25
                case .maintenanceServices:
                    return 0.25
                case .manager:
                    return 0.25
                case .vendor:
                    return 0.0
                default:
                    return 0
            }

        default:
            return 0
        }
    }
}

enum EntrantType: String{
    case guest = "Guest"
    case manager = "Manager"
    case vendor = "Vendor"
    case employee = "Employee"

    func entrantProfiles() -> [EntrantProfileType]{
        switch self {
        case .guest:
            return [.classicGuest, .vipGuest, .freeChildGuest]
        case .manager:
            return [.manager]
        case .vendor:
            return [.vendor]
        case .employee:
            return [.foodServices,.rideServices,.maintenanceServices]
        }
    }
}

enum EntrantProfileType: String{
    case empltyPlaceHolder = "<PLACEHOLDER>"
    case classicGuest = "Classic"
    case vipGuest = "VIP"
    case freeChildGuest = "Free Child"
    case foodServices = "Food"
    case rideServices = "Ride"
    case maintenanceServices = "Maintenance"
    case manager = "Manager"
    case vendor = "Vendor"
    
}


struct IdentityAccessManager: AccessManager{
    
    var entrant: EntrantType
    var entrantProfile: EntrantProfileType

    init (forEntrant: EntrantType, profile: EntrantProfileType){
        self.entrant = forEntrant
        self.entrantProfile = profile
    }

    

    
}



