import Foundation

// MARK: Protocol Declaration

//protocol PassGenerator {
//    
//    var firstName: EntrantInfoFields? { get }
//    var lastName: EntrantInfoFields? { get }
//    var addressStreet: EntrantInfoFields? { get }
//    var addressCity: EntrantInfoFields? { get }
//    var addressState: EntrantInfoFields? { get }
//    var addressZip: EntrantInfoFields? { get }
//    var dateOfBirth: EntrantInfoFields? { get }

//    var entrantProfile: Any { get }
//    var parkAccess: AmusementParkAccessable { get }
    
//    func validateRequiredInfoIsSupplied()
    
    
//}

protocol PassValidator {}


// MARK: Enum Declaration

// Main Enum Types
protocol EntrantIdentifiable{}  // Group all Entrant Types
protocol AmusementParkAccessable{} //Group all Privilage Types


enum EntrantInfoFields {
    case firstName
    case lastName
    case addressStreet
    case addressCity
    case addressState
    case addressZip
    case dateOfBirth

    func requiredInfo(forEntrant: EntrantIdentifiable) -> Bool {
        
        switch forEntrant {
        case GuestType.classic,GuestType.freeChild:
            return false
            
        case GuestType.VIP:
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
    case missingRequiredField(EntrantInfoFields)
}

enum ErrorTypeCasting: Error{
    case UnknownUserType (String)
}


struct EntrantProfileInformation{
    
    var firstName: String?
    var lastName: String?
    var addressStreet: String?
    var addressCity: String?
    var addressState: String?
    var addressZip: Int?
    var dateOfBirth: NSDate?
    
 }
    



//class Pass: PassGenerator{
class Pass{

//    var firstName: EntrantInfoFields?
//    var lastName: EntrantInfoFields?
//    var addressStreet: EntrantInfoFields?
//    var addressCity: EntrantInfoFields?
//    var addressState: EntrantInfoFields?
//    var addressZip: EntrantInfoFields?
//    var dateOfBirth: EntrantInfoFields?
    
    let entrantProfile: EntrantIdentifiable
    let entrantInfo = EntrantProfileInformation()
    
    init(forEntrant: EntrantIdentifiable, firstName: String?, lastName: String?, street: String?, city: String?, state: String?, ZIP: Int?, DOB: NSDate?)throws{
        
        switch forEntrant {
            case is GuestType:
                self.entrantProfile = forEntrant as! GuestType
                print("Guest")
            case is EmployeeType:
                self.entrantProfile  = forEntrant as! EmployeeType
                print("Employee")
            case is ManagerType:
                self.entrantProfile  = forEntrant as! ManagerType
                print("Manager")
            default:
                throw ErrorTypeCasting.UnknownUserType("Unknow Entrant Type: \(forEntrant)")
        }
        
//           entrantInfo = EntrantProfileInformation(firstName: firstName, lastName: lastName, addressStreet: street, addressCity: city, addressState: state, addressZip: ZIP, dateOfBirth: DOB)
//        
        
//        if let firstName = firstName{
//            self.firstName = EntrantInfoFields.firstName(firstName)
//        }
//        
//        if let lastName = lastName{
//            self.lastName = EntrantInfoFields.lastName(lastName)
//        }
//        
//        if let street = street{
//            self.addressStreet = EntrantInfoFields.addressStreet(street)
//        }
//        
//        if let city = city{
//            self.addressCity = EntrantInfoFields.addressCity(city)
//        }
//
//        if let state = state{
//            self.addressState = EntrantInfoFields.addressState(state)
//        }
//        
//        if let ZIP = ZIP{
//            self.addressZip = EntrantInfoFields.addressZip(ZIP)
//        }
//        
//        if let DOB = DOB{
//            self.dateOfBirth = EntrantInfoFields.dateOfBirth(DOB)
//        }
    
    }
    
//    func validateRequiredInfo(){
//        
//            let requiredFieldsforProfile =  EntrantInformation.requiredData(forEntrant: entrantProfile)
//        
//        
//            if let fieldDict = requiredFieldsforProfile{
//                for field in fieldDict{
//                    print("Required Fields are: \(field)")
//        
//                    if  firstName == field {
//                        print("True")
//                    } else {
//                        print("false")
//                    }
//                    
//                }
//            }else{
//                print("No Information Required from Entrant")
//            }
//        
//        print
//    }
//    
}

let person = ManagerType.manager

//
//do{
//    let NewPass = try Pass(forEntrant: person, firstName: "Sherief", lastName: "Wissa", street: nil, city: nil, state: nil, ZIP: nil, DOB: nil)
//    let discountAmount = DiscountAccessType.merchandise.percentageDiscount(forEntrant: NewPass.entrantProfile)
//    NewPass.validateRequiredInfo()
//} catch ErrorTypeCasting.UnknownUserType(let string) {
//    print(string)
//}

let required = EntrantInfoFields.addressZip.requiredInfo(forEntrant: GuestType.classic)

