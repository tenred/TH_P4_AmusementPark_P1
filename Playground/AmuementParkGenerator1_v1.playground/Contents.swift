import Foundation

// MARK: Protocol Declaration

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


struct EntrantProfileInformation: Identity{
    
    var firstName: String?
    var lastName: String?
    var addressStreet: String?
    var addressCity: String?
    var addressState: String?
    var addressZip: String?
    var dateOfBirth: String?
    
    let allEnumInfoField: [EntrantInfoFields] = [.firstName, .lastName, .addressStreet, .addressCity, .addressState, .addressZip, .dateOfBirth]
    
    func requiredInfo(forEntrant: EntrantIdentifiable) -> Dictionary<EntrantInfoFields,Bool>{
        var required: [EntrantInfoFields: Bool] = [:]
        
        for field in allEnumInfoField{
            required[field] = field.isFieldManditory(forEntrant: forEntrant)
        }
        return required
    }
    
    
    func suppliedInfo(forEntrant: EntrantIdentifiable) -> Dictionary<EntrantInfoFields,String?>{
        
        var infoDict: [EntrantInfoFields: String] = [:]
        
        if let fname = self.firstName{infoDict[.firstName] = fname} else{infoDict[.firstName] = nil}
        if let lname = self.lastName{infoDict[.lastName] = lname} else{infoDict[.lastName] = nil}
        if let street = self.addressStreet{infoDict[.addressStreet] = street} else{infoDict[.addressStreet] = nil}
        if let city = self.addressCity{infoDict[.addressCity] = city}else{infoDict[.addressCity] = nil}
        if let state = self.addressState{infoDict[.addressState] = state} else{infoDict[.addressState] = nil}
        if let ZIP = self.addressZip{infoDict[.addressZip] = ZIP} else{infoDict[.addressZip] = nil}
        if let DOB = self.dateOfBirth{infoDict[.dateOfBirth] = DOB} else{infoDict[.dateOfBirth] = nil}
        
        return infoDict
    }

    //TODO: Implement func convertedDOB
    
//    func convertedDOB() throws -> NSDate {
//
//        var convertedDB: NSDate
//        
//        guard convertedDB = NSDate(self.dateOfBirth) else{
//            throw MissingInformation.conversionError(EntrantInfoFields.dateOfBirth)
//        }
//        return NSDate(1/1/2011)
//
//    }
    
}

//class Pass: PassGenerator{
class Pass{
    
    var entrant: EntrantIdentifiable
    var entrantProfile = EntrantProfileInformation()

    
    init(forEntrant: EntrantIdentifiable, firstName: String?, lastName: String?, street: String?, city: String?, state: String?, ZIP: String?, DOB: String?)throws{
        
        switch forEntrant {
            case is GuestType:
                self.entrant = forEntrant as! GuestType
                print("Guest")
            case is EmployeeType:
                self.entrant  = forEntrant as! EmployeeType
                print("Employee")
            case is ManagerType:
                self.entrant  = forEntrant as! ManagerType
                print("Manager")
            default:
                throw ErrorTypeCasting.UnknownUserType("Unknow Entrant Type: \(forEntrant)")
        }

        entrantProfile = EntrantProfileInformation(firstName: firstName, lastName: lastName, addressStreet: street, addressCity: city, addressState: state, addressZip: ZIP, dateOfBirth: DOB)
    }
    

    
    //Method Queries EntrantProfile for supplied data versus Manditory data and throws is not all requirements are met.
    
    func hasManditoryInfoBeenSupplied() throws -> Bool{
    
        let manditoryFields = entrantProfile.requiredInfo(forEntrant: entrant)
        let providedFields = entrantProfile.suppliedInfo(forEntrant: entrant)
        var missingField: [EntrantInfoFields]?
        
        for (key,value) in manditoryFields{
            
            if value {
                print("Checking Key: \(key.rawValue)")

                if providedFields[key] == nil {
                    print("Missing: \(key.rawValue)")
                    
                    if missingField != nil{
                        missingField?.append(key)
                    } else{
                        missingField = [key]
                    }
                }
            }
        }
    
        if let errorMissinArr = missingField{
            throw MissingInformation.missingRequiredField(errorMissinArr)

        } else {
            return true
        }
        
    }

//    func validateAccess(forArea: AmusementParkAccessable) -> Permissions{
//        
//        let areasAllowed = entrant.isAllowedInAreas()
//        
//        
//    }
    
} // End of Pass Class
        


let person = GuestType.freeChild

do{
    let ParkPass = try Pass(forEntrant: person, firstName: "Sherief", lastName: "Wissa", street: nil, city: nil, state: nil, ZIP: nil, DOB: nil)
    try ParkPass.hasManditoryInfoBeenSupplied()
    
    ParkPass.entrant
    
    
} catch ErrorTypeCasting.UnknownUserType(let errorString){
    print("ERROR: \(errorString)")

} catch MissingInformation.missingRequiredField(let errorString){
        print ("ERROR: Missing Information for the below field(s):")
    for obj in errorString{
        print("OBJECT: \(obj) | \(obj.rawValue)")
    }

} catch{
    fatalError("BOOM")
}




