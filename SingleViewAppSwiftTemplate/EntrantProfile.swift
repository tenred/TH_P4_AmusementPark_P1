//
//  EntrantProfileInformation.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Sherief Wissa on 17/3/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation

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
