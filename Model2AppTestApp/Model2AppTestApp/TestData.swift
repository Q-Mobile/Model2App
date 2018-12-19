//
//  TestData.swift
//  Model2AppTestApp
//
//  Created by Karol Kulesza on 11/14/18.
//  Copyright © 2018 Q Solutions. All rights reserved.
//

import Foundation
import Model2App


class TestData {
    
    static func load() {
        guard M2A.storage.firstObject(Company.self) == nil else { return } // Add test data only if storage is empty
        
        addTestCompaniesToStorage()
        addTestPeopleToStorage()
        addTestProductsToStorage()
        addTestActivitiesToStorage()
        addTestDealsToStorage()
    }
    
    static func addTestCompaniesToStorage() {
        M2A.storage.write {
            addTestCompany("Tesla")
            addTestCompany("Amazon")
            addTestCompany("GitHub")
            addTestCompany("Google")
            addTestCompany("Microsoft")
            addTestCompany("Oracle")
            addTestCompany("IBM")
            addTestCompany("Intel")
            addTestCompany("HP")
            addTestCompany("SAP")
        }
    }
    
    static func addTestPeopleToStorage() {
        M2A.storage.write {
            addTestPerson("Steve", "Jobs", "Mr.", "123456789", "steve@amazon.com", Date(dateString: "1955-02-24"), "Amazon", "steve_jobs")
            addTestPerson("Nikola", "Tesla", "Mr.", "123456789", "nikola@tesla.com", Date(dateString: "1856-07-10"), "Tesla", "nikola_tesla")
            addTestPerson("Benjamin", "Franklin", "Mr.", "123456789", "benjamin@google.com", Date(dateString: "1706-01-17"), "Google", "benjamin_franklin")
            addTestPerson("Henry", "Ford", "Mr.", "123456789", "henry@tesla.com", Date(dateString: "1863-07-30"), "Tesla", "henry_ford")
            addTestPerson("Charles", "Babbage", "Mr.", "123456789", "charles@google.com", Date(dateString: "1791-12-26"), "Google", "charles_babbage")
            addTestPerson("Alexander", "Bell", "Mr.", "123456789", "alexander@microsoft.com", Date(dateString: "1847-03-03"), "Microsoft", "alexander_bell")
            addTestPerson("Thomas", "Edison", "Mr.", "123456789", "thomas@amazon.com", Date(dateString: "1847-02-11"), "Amazon", "thomas_edison")
            addTestPerson("Albert", "Einstein", "Mr.", "123456789", "albert@github.com", Date(dateString: "1879-03-14"), "GitHub", "albert_einstein")
            addTestPerson("Marie", "Curie", "Mrs.", "123456789", "marie@oracle.com", Date(dateString: "1867-11-07"), "Oracle", "marie_curie")
            addTestPerson("Leonardo", "Da Vinci", "Mr.", "123456789", "leonardo@github.com", Date(dateString: "1452-04-15"), "GitHub", "leonardo_da_vinci")
        }
    }
    
    static func addTestProductsToStorage() {
        M2A.storage.write {
            addTestProduct("iPhone", "A1920", "Hardware", 99900, "iphone")
            addTestProduct("iPad Pro", "A1876", "Hardware", 99900, "ipad_pro")
            addTestProduct("iPad Mini", "A1538", "Hardware", 39900, "ipad_mini")
            addTestProduct("MacBook Pro", "MR932LL/A", "Hardware", 129900, "macbook_pro")
            addTestProduct("MacBook Air", "MRE82D/A", "Hardware", 119900, "macbook_air")
            addTestProduct("iMac", "MMQA2LL/A", "Hardware", 109900, "imac")
            addTestProduct("Mac Mini", "MRTR2D/A", "Hardware", 79900, "mac_mini")
            addTestProduct("Apple Watch", "A2007", "Hardware", 39900, "apple_watch")
            addTestProduct("AirPods", "A1523", "Hardware", 15900, "airpods")
            addTestProduct("Apple TV", "A1842", "Hardware", 17900, "apple_tv")
        }
    }
    
    static func addTestActivitiesToStorage() {
        M2A.storage.write {
            addTestActivity("Phone Call", "Call with Charles", "Babbage", "Google", Date(dateTimeString: "2018-01-04 10:30"), Date(dateTimeString: "2018-01-04 11:00"), ["iPhone", "MacBook Pro"])
            addTestActivity("Meeting", "Meeting with Thomas", "Edison", "Amazon", Date(dateTimeString: "2018-02-23 09:00"), Date(dateTimeString: "2018-02-23 10:00"), ["iPad Pro", "iMac"])
            addTestActivity("Phone Call", "Follow-up call @ Google", "Franklin", "Google", Date(dateTimeString: "2018-03-01 13:00"), Date(dateTimeString: "2018-03-01 14:00"), ["MacBook Air", "Apple TV"])
            addTestActivity("Phone Call", "Call with Steve", "Jobs", "Amazon", Date(dateTimeString: "2018-04-18 16:30"), Date(dateTimeString: "2018-04-18 17:30"), ["Mac Mini", "Apple Watch"])
            addTestActivity("Email", "Email to Henry", "Ford", "Tesla", Date(dateTimeString: "2018-05-09 08:30"), Date(dateTimeString: "2018-05-09 08:45"), ["MacBook Pro", "AirPods"])
            addTestActivity("Task", "Samples preparation", "Curie", "Oracle", Date(dateTimeString: "2018-06-11 11:00"), Date(dateTimeString: "2018-06-11 13:00"), ["iPad Mini", "iPhone"])
            addTestActivity("Meeting", "On-site meeting @ Tesla", "Tesla", "Tesla", Date(dateTimeString: "2018-07-27 09:00"), Date(dateTimeString: "2018-07-27 10:30"), ["iPad Pro", "AirPods"])
            addTestActivity("Phone Call", "Review call with Thomas", "Edison", "Amazon", Date(dateTimeString: "2018-08-05 15:30"), Date(dateTimeString: "2018-08-05 16:00"), ["iMac", "Apple Watch"])
            addTestActivity("Email", "Email to Nikola", "Tesla", "Tesla", Date(dateTimeString: "2018-09-16 13:30"), Date(dateTimeString: "2018-09-16 14:30"), ["MacBook Air", "iPad Pro"])
            addTestActivity("Meeting", "Meeting with Albert", "Einstein", "GitHub", Date(dateTimeString: "2018-10-02 10:30"), Date(dateTimeString: "2018-10-02 12:00"), ["Apple TV", "iPad Mini"])
            addTestActivity("Phone Call", "Follow-up call with Leo", "Da Vinci", "GitHub", Date(dateTimeString: "2018-11-06 11:00"), Date(dateTimeString: "2018-11-06 11:30"), ["Apple Watch", "iMac"])
            addTestActivity("Task", "Demo review for MS", "Bell", "Microsoft", Date(dateTimeString: "2018-11-12 16:00"), Date(dateTimeString: "2018-11-12 18:00"), ["iPhone", "MacBook Pro"])
        }
    }
    
    static func addTestDealsToStorage() {
        M2A.storage.write {
            addTestDeal("iPhones for Tesla", 54800000, "Prospecting", "Referral", Date(dateString: "2018-01-24"), "Tesla")
            addTestDeal("New tablets for Amazon", 17000000, "Qualified", "Partner", Date(dateString: "2018-02-03"), "Amazon")
            addTestDeal("Workstations @ GitHub", 835000000, "Reviewed", "Website", Date(dateString: "2018-03-17"), "GitHub")
            addTestDeal("Accessories for Google", 31000000, "Prospecting", "Referral", Date(dateString: "2018-04-27"), "Google")
            addTestDeal("Smartwatches for MS", 8350000, "Won", "Website", Date(dateString: "2018-05-01"), "Microsoft")
            addTestDeal("Apple TV @ Tesla", 5120000, "Quote", "Partner", Date(dateString: "2018-06-19"), "Tesla")
            addTestDeal("iPads update at Amazon", 38720000, "Qualified", "Referral", Date(dateString: "2018-07-09"), "Amazon")
            addTestDeal("Github mobile laptops", 47900000, "Prospecting", "Cold Call", Date(dateString: "2018-08-07"), "GitHub")
            addTestDeal("New phones @ Google", 85500000, "Won", "Advertisement", Date(dateString: "2018-09-22"), "Google")
            addTestDeal("Hardware update for MS", 137000000, "Lost", "Referral", Date(dateString: "2018-10-12"), "Microsoft")
            addTestDeal("CI setup @ Oracle", 20800000, "Reviewed", "Partner", Date(dateString: "2018-11-05"), "Oracle")
            addTestDeal("IBM’s gadgets", 69000000, "Qualified", "Advertisement", Date(dateString: "2018-11-12"), "IBM")
        }
    }
    
    private static func addTestCompany(_ name: String) {
        let company = Company()
        company.name = name
        company.industry = "Technology"
        M2A.storage.add(company)
    }
    
    private static func addTestPerson(_ firstName: String,
                                      _ lastName: String,
                                      _ salutation: String,
                                      _ phoneNumber: String,
                                      _ workEmail: String,
                                      _ birthday: Date?,
                                      _ companyName: String,
                                      _ imageFileName: String? = nil) {
        let p = Person()
        p.firstName = firstName
        p.lastName = lastName
        p.salutation = salutation
        p.phoneNumber = phoneNumber
        p.workEmail = workEmail
        p.birthday = birthday
        if let company = M2A.storage.objects(Company.self).first(where: { $0.name == companyName }) {
            p.company = company
        }
        if let imageName = imageFileName {
            let image = UIImage(named: imageName, in: Bundle(for: TestData.self), compatibleWith: nil)
            p.setImage(image, for: #keyPath(Person.picture))
        }
        M2A.storage.add(p)
    }
    
    private static func addTestProduct(_ name: String,
                                      _ productCode: String,
                                      _ category: String,
                                      _ unitPrice: Int,
                                      _ imageFileName: String? = nil) {
        let p = Product()
        p.name = name
        p.productCode = productCode
        p.category = category
        p["unitPrice"] = unitPrice
        p["isActive"] = true
        if let imageName = imageFileName {
            let image = UIImage(named: imageName, in: Bundle(for: TestData.self), compatibleWith: nil)
            p.setImage(image, for: #keyPath(Product.productImage))
        }
        M2A.storage.add(p)
    }
    
    private static func addTestActivity(_ activityType: String,
                                       _ subject: String,
                                       _ contactLastName: String,
                                       _ companyName: String,
                                       _ startTime: Date?,
                                       _ endTime: Date?,
                                       _ discussedProductNames: [String]) {
        let a = Activity()
        a.activityType = activityType
        a.subject = subject
        a.startTime = startTime
        a.endTime = endTime

        if let contact = M2A.storage.objects(Person.self).first(where: { $0.lastName == contactLastName }) {
            a.contact = contact
        }
        if let company = M2A.storage.objects(Company.self).first(where: { $0.name == companyName }) {
            a.company = company
        }
        
        discussedProductNames.forEach { productName in
            if let product = M2A.storage.objects(Product.self).first(where: { $0.name == productName }) {
                let discussedProduct = ActivityProduct()
                discussedProduct.activity = a
                discussedProduct.product = product
                M2A.storage.add(discussedProduct)
            }
        }
        M2A.storage.add(a)
    }
    
    private static func addTestDeal(_ name: String,
                                    _ value: Int,
                                    _ stage: String,
                                    _ source: String,
                                    _ closingDate: Date?,
                                    _ companyName: String) {
        let d = Deal()
        d.name = name
        d["value"] = value
        d.stage = stage
        d.source = source
        d.closingDate = closingDate
        
        if let company = M2A.storage.objects(Company.self).first(where: { $0.name == companyName }) {
            d.company = company
        }
        M2A.storage.add(d)
    }
}
