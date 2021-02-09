//
//  Application+CoreDataProperties.swift
//  HomeLoanApp
//
//  Created by David Young on 2020/12/14.
//
//

import Foundation
import CoreData


extension Application {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Application> {
        return NSFetchRequest<Application>(entityName: "Application")
    }

    // MARK: - General
    @NSManaged public var applicantType: String?
    @NSManaged public var applicationType: String?
    @NSManaged public var coApplicantOneName: String?
    @NSManaged public var coApplicantThreeName: String?
    @NSManaged public var coApplicantTwoName: String?
    @NSManaged public var loanID: UUID?
    @NSManaged public var loanPurpose: String?
    @NSManaged public var loanStatus: String?
    @NSManaged public var numberOfApplicants: String?
    @NSManaged public var propertyType: String?
    @NSManaged public var salesConsultant: String?
    @NSManaged public var loanCreatedDate: Date?
    
    // MARK: - Personal Details
    @NSManaged public var title: String?
    @NSManaged public var surname: String?
    @NSManaged public var firstNames: String?
    @NSManaged public var gender: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var iDType: String?
    @NSManaged public var iDPassNumber: String?
    @NSManaged public var iDPassExpiryDate: Date?
    @NSManaged public var taxNumber: String?
    @NSManaged public var taxReturn: String?
    @NSManaged public var educationLevel: String?
    @NSManaged public var ethnicGroup: String?
    @NSManaged public var singleHouse: String?
    @NSManaged public var maritalStatus: String?
    @NSManaged public var countryMarriage: String?
    @NSManaged public var spouseIncome: String?
    @NSManaged public var aNC: String?
    @NSManaged public var numDependents: Int16
    @NSManaged public var mainResidence: String?
    @NSManaged public var firstTimeHomeBuyer: String?
    @NSManaged public var socialGrant: String?
    @NSManaged public var publicOfficial: String?
    @NSManaged public var relatedOfficial: String?
    
    // MARK: - Residency & Contact
    @NSManaged public var sACitizen: String?
    @NSManaged public var nationality: String?
    @NSManaged public var countryPassport: String?
    @NSManaged public var countryBirth: String?
    @NSManaged public var cityOfBirth: String?
    @NSManaged public var permanentResident: String?
    @NSManaged public var countryOfPermanentResidence: String?
    @NSManaged public var permitType: String?
    @NSManaged public var countryOfPermit: String?
    @NSManaged public var permitIssueDate: Date?
    @NSManaged public var permitExpiryDate: Date?
    @NSManaged public var contractIssueDate: Date?
    @NSManaged public var contractExpiryDate: Date?
    @NSManaged public var workPermitNumber: String?
    @NSManaged public var homeLanguage: String?
    @NSManaged public var correspondenceLanguage: String?
    @NSManaged public var cellNumber: String?
    @NSManaged public var emailAddress: String?
    @NSManaged public var resCountry: String?
    @NSManaged public var resLine1: String?
    @NSManaged public var resLine2: String?
    @NSManaged public var resSuburb: String?
    @NSManaged public var resCity: String?
    @NSManaged public var resProvince: String?
    @NSManaged public var resStreetCode: String?
    @NSManaged public var lengthAtAddress: String?
    @NSManaged public var resIsPostal: String?
    @NSManaged public var postalCountry: String?
    @NSManaged public var postalLine1: String?
    @NSManaged public var postalLine2: String?
    @NSManaged public var postalSuburb: String?
    @NSManaged public var postalCity: String?
    @NSManaged public var postalProvince: String?
    @NSManaged public var postalStreetCode: String?
    
    // MARK: - Subsidy & Credit
    @NSManaged public var subsidyForHome: String?
    @NSManaged public var applyingSubsidy: String?
    @NSManaged public var housingScheme: String?
    @NSManaged public var currentAdmin: String?
    @NSManaged public var previousAdmin: String?
    @NSManaged public var judgement: String?
    @NSManaged public var debtReview: String?
    @NSManaged public var debtReArrange: String?
    @NSManaged public var insolvent: String?
    @NSManaged public var creditBureau: String?
    @NSManaged public var creditListings: String?
    @NSManaged public var suretyAgreements: String?
    
    // MARK: - Employment
    @NSManaged public var occupationalStatus: String?
    @NSManaged public var payingScheme: String?
    @NSManaged public var incomeSource: String?
    @NSManaged public var natureOfOccupation: String?
    @NSManaged public var occupationLevel: String?
    @NSManaged public var employmentSector: String?
    @NSManaged public var natureOfBusiness: String?
    @NSManaged public var employer: String?
    @NSManaged public var companyRegNum: String?
    @NSManaged public var employeeNum: String?
    @NSManaged public var employmentPeriod: String?
    @NSManaged public var employerCountry: String?
    @NSManaged public var employerLine1: String?
    @NSManaged public var employerLine2: String?
    @NSManaged public var employerSuburb: String?
    @NSManaged public var employerCity: String?
    @NSManaged public var employerProvince: String?
    @NSManaged public var employerStreetCode: String?
    @NSManaged public var workPhoneNum: String?
    @NSManaged public var purchaseJobChange: String?
    @NSManaged public var workInZA: String?
    @NSManaged public var previouslyEmployed: String?
    @NSManaged public var previousEmployer: String?
    @NSManaged public var pEContact: String?
    @NSManaged public var pEDuration: String?
    
    // MARK: - Income
    @NSManaged public var basicSalary: String?
    @NSManaged public var wages: String?
    @NSManaged public var averageComm: String?
    @NSManaged public var investments: String?
    @NSManaged public var rentIncome: String?
    @NSManaged public var futureRentIncome: String?
    @NSManaged public var housingSub: String?
    @NSManaged public var averageOvertime: String?
    @NSManaged public var monthCarAllowance: String?
    @NSManaged public var interestIncome: String?
    @NSManaged public var travelAllowance: String?
    @NSManaged public var entertainment: String?
    @NSManaged public var incomeFromSureties: String?
    @NSManaged public var maintenanceAlimony: String?
    @NSManaged public var other: String?
    @NSManaged public var tax: String?
    @NSManaged public var pension: String?
    @NSManaged public var uIF: String?
    @NSManaged public var medicalAid: String?
    @NSManaged public var otherDeductions: String?
    
    // MARK: - Expenses
    @NSManaged public var rental: String?
    @NSManaged public var expensesInvestments: String?
    @NSManaged public var ratesTaxes: String?
    @NSManaged public var waterLights: String?
    @NSManaged public var homeMain: String?
    @NSManaged public var petrolCar: String?
    @NSManaged public var insurance: String?
    @NSManaged public var assurance: String?
    @NSManaged public var timeshare: String?
    @NSManaged public var groceries: String?
    @NSManaged public var clothing: String?
    @NSManaged public var levies: String?
    @NSManaged public var domesticWages: String?
    @NSManaged public var education: String?
    @NSManaged public var expensesEntertainment: String?
    @NSManaged public var security: String?
    @NSManaged public var propertyRentExp: String?
    @NSManaged public var medical: String?
    @NSManaged public var donations: String?
    @NSManaged public var cellphone: String?
    @NSManaged public var telephoneISP: String?
    @NSManaged public var expensesMaintenanceAlimony: String?
    @NSManaged public var installmentExp: String?
    @NSManaged public var otherExpenses: String?
    
    // MARK: - Assets & Liabilities
    @NSManaged public var fixedProperty: String?
    @NSManaged public var vehicles: String?
    @NSManaged public var furnitureFittings: String?
    @NSManaged public var assetLiabilityInvestments: String?
    @NSManaged public var cashonHand: String?
    @NSManaged public var otherAsset: String?
    @NSManaged public var mortgageBonds: String?
    @NSManaged public var installmentSales: String?
    @NSManaged public var creditCards: String?
    @NSManaged public var currentAcc: String?
    @NSManaged public var personalLoans: String?
    @NSManaged public var retailAcc: String?
    @NSManaged public var otherDebt: String?
    @NSManaged public var otherAcc: String?
    @NSManaged public var otherLiabilities: String?
    
    // MARK: - Notification/Warranty
    @NSManaged public var notificationsCheck: String?
    
    var status: Status {
        set {
            loanStatus = newValue.rawValue
        }
        get {
            Status(rawValue: loanStatus ?? Status.pending.rawValue) ?? .pending
        }
    }

}

extension Application : Identifiable {

}

/*enum Status: String {
    case unsubmitted = "Unsubmitted"
    case submitted = "Submitted"
    case pending = "Pending"
    case waitingApproval = "Waiting for approval"
    case approved = "Approved"
    case denied = "Denied"
}*/
