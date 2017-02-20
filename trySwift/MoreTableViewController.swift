//
//  MoreTableViewController.swift
//  trySwift
//
//  Created by Natasha Murashev on 2/12/16.
//  Copyright © 2016 NatashaTheRobot. All rights reserved.
//

import UIKit
import AcknowList
import TrySwiftData

class MoreTableViewController: UITableViewController {
    
    fileprivate let cellIdentifier = "BasicCell"
    

    fileprivate enum MoreSection: Int {
        case eventDetails, acknowledgements, feedback, slack
    }
    
    fileprivate enum EventDetailsRow: Int {
        case about, venue, codeOfConduct
    }
    
    fileprivate enum AcknowledgementsRow: Int {
        case organizers, libraries
    }
    
    fileprivate enum FeedbackRow: Int {
        case app, conference
    }
    
    fileprivate enum SlackRow: Int {
        case open
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title = "More".localized()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - Table view data source
extension MoreTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch MoreSection(rawValue: section)! {
        case .eventDetails:
            return 3
        case .acknowledgements:
            return 2
        case .feedback:
            return 2
        case .slack:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        switch MoreSection(rawValue: indexPath.section)! {
        case .eventDetails:
            switch EventDetailsRow(rawValue: indexPath.row)! {
            case .about:
                cell.textLabel?.text = "About".localized()
            case .venue:
                cell.textLabel?.text = "Venue".localized()
            case .codeOfConduct:
                cell.textLabel?.text = "Code of Conduct".localized()
            }
        case .acknowledgements:
            switch AcknowledgementsRow(rawValue: indexPath.row)! {
            case .organizers:
                cell.textLabel?.text = "Organizers".localized()
            case .libraries:
                cell.textLabel?.text = "Acknowledgements".localized()
            }
        case .feedback:
            switch FeedbackRow(rawValue: indexPath.row)! {
            case .app:
                cell.textLabel?.text = "App Feedback".localized()
            case .conference:
                cell.textLabel?.text = "Conference Feedback".localized()
            }
        case .slack:
            switch SlackRow(rawValue: indexPath.row)! {
            case .open:
                cell.textLabel?.text = "Open Slack".localized()
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MoreSection(rawValue: indexPath.section)! {
        case .eventDetails:
            switch EventDetailsRow(rawValue: indexPath.row)! {
            case .about:
                showAbout()
            case .venue:
                showVenue()
            case .codeOfConduct:
                showCodeOfConduct()
            }
        case .acknowledgements:
            switch AcknowledgementsRow(rawValue: indexPath.row)! {
            case .organizers:
                showOrganizers()
            case .libraries:
                showLibraries()
            }
        case .feedback:
            switch FeedbackRow(rawValue: indexPath.row)! {
            case .app:
                showAppFeedback()
            case .conference:
                showConferenceFeedback()
            }
        case .slack:
            switch SlackRow(rawValue: indexPath.row)! {
            case .open:
                openSlack()
            }

            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
}

private extension MoreTableViewController {
    
    func showAbout() {
        let aboutViewController = AboutTableViewController()
        navigationController?.pushViewController(aboutViewController, animated: true)
    }
    
    func showVenue() {
        let venueController = VenueTableViewController()
        venueController.venue = Conference.current.venue
        navigationController?.pushViewController(venueController, animated: true)
    }
    
    func showCodeOfConduct() {
        let webViewController = WebDisplayViewController()
        webViewController.url = URL(string: "https://github.com/NatashaTheRobot/trySwiftCodeOfConduct/blob/master/README.md")!
        webViewController.displayTitle = "Code of Conduct".localized()
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func showOrganizers() {
        let organizerViewController = OrganizersTableViewController()
        navigationController?.pushViewController(organizerViewController, animated: true)
    }
    
    func showLibraries() {
        let path = Bundle.main.path(forResource: "Pods-trySwift-acknowledgements", ofType: "plist")
        let acknowledgementesViewController = AcknowListViewController(acknowledgementsPlistPath: path)
        if #available(iOS 9.2, *) {
            acknowledgementesViewController.headerText = "We 🤗 Open Source Software"
        } else {
            acknowledgementesViewController.headerText = "We ❤️ Open Source Software"
        }
        
        navigationController?.pushViewController(acknowledgementesViewController, animated: true)
    }
    
    func showAppFeedback() {
        let url = URL(string: "https://github.com/tryswift/trySwiftAppFinal/issues")!
        openSafariViewController(withURL: url)
    }
    
    func showConferenceFeedback() {
        let configuration = MailConfiguration(recipients: ["info@tryswift.co"], subject: "Conference feedback via try! NYC app")
        sendMail(withConfiguration: configuration)
    }
    
    func openSlack() {
        let application = UIApplication.shared
        let appURL = URL(string: "slack://open")!
        if application.canOpenURL(appURL) {
            application.open(appURL, options: [String:Any](), completionHandler: nil)
        } else {
            let url = URL(string: "https://tryswiftjp2017.slack.com")!
            openSafariViewController(withURL: url)
        }
    }
}
