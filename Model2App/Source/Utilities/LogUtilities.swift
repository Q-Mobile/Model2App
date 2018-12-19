//
//  LogUtilities.swift
//  Model2App
//
//  Created by Karol Kulesza on 10/16/18.
//  Copyright © 2018 Q-Mobile.IT . All rights reserved.
//

import os.log


struct Log {
    static var general = OSLog(subsystem: "it.q-mobile.model2app", category: "Model2App-General")
    static var validation = OSLog(subsystem: "it.q-mobile.model2app", category: "Model2App-Validation")
}

func log(_ message: String, log: OSLog = Log.general) {
    os_log("%@", log: log, type: .default, message)
}

func log_info(_ message: String, log: OSLog = Log.general) {
    os_log("%@", log: log, type: .info, message)
}

func log_debug(_ message: String, log: OSLog = Log.general) {
    os_log("%@", log: log, type: .debug, message)
}

func log_error(_ message: String, log: OSLog = Log.general) {
    os_log("%@", log: log, type: .error, message)
}

func log_fault(_ message: String, log: OSLog = Log.general) {
    os_log("%@", log: log, type: .fault, message)
}
