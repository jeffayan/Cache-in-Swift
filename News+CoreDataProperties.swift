//
//  News+CoreDataProperties.swift
//  SampleWatsApp
//
//  Created by Developer on 29/09/17.
//  Copyright © 2017 Developer. All rights reserved.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetch() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var desc: String?

}
