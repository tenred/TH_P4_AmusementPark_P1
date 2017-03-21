//
//  ParkPass.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Sherief Wissa on 17/3/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation

class ParkPass{
    
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
