// SPDX-License-Identifier: ice License 1.0

import Foundation
import SQLite3

class DatabaseManager {
    private let storage: SharedStorageService
    
    private var database: OpaquePointer?
    private let fileManager = FileManager.default
    
    init(storage: SharedStorageService) {
        self.storage = storage
    }
    
    /// Opens the Drift database used by the Flutter app
    /// - Returns: True if the database was successfully opened, false otherwise
    @discardableResult
    func openDatabase() -> Bool {
        guard let pubkey = storage.getCurrentPubkey() else {
            return false
        }
        
        guard let databasePath = getDatabasePath(pubkey: pubkey) else {
            return false
        }
        
        if !fileManager.fileExists(atPath: databasePath) {
            return false
        }
        
        if sqlite3_open(databasePath, &database) != SQLITE_OK {
            sqlite3_close(database)
            database = nil
            return false
        }
        
        return true
    }
    
    /// Closes the database connection
    func closeDatabase() {
        if database != nil {
            sqlite3_close(database)
            database = nil
        }
    }
    
    // Mark: - Private Helper Methods
    
    /// Gets the path to the database file
    /// - Parameter pubkey: The pubkey used to construct the database name
    /// - Returns: The full path to the database file if available, nil otherwise
    private func getDatabasePath(pubkey: String) -> String? {
        let appGroupIdentifier = storage.appGroupIdentifier
        
        if let sharedContainerURL = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier) {
            let databaseName = "user_metadata_database_\(pubkey).sqlite"
            let sharedDatabaseURL = sharedContainerURL.appendingPathComponent(databaseName)
            
            if fileManager.fileExists(atPath: sharedDatabaseURL.path) {
                return sharedDatabaseURL.path
            }
        }
        
        return nil
    }
    
    /// Executes a SQL query on the database
    /// - Parameter query: The SQL query to execute
    /// - Returns: An array of dictionaries representing the query results, or nil if the query failed
    func executeQuery(_ query: String) -> [[String: Any]]? {
        guard database != nil else {
            return nil
        }
        
        var statement: OpaquePointer?
        var results: [[String: Any]] = []
        
        if sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                var row: [String: Any] = [:]
                
                let columns = sqlite3_column_count(statement)
                
                for i in 0..<columns {
                    let columnName = String(cString: sqlite3_column_name(statement, i))
                    
                    let columnType = sqlite3_column_type(statement, i)
                    
                    switch columnType {
                    case SQLITE_INTEGER:
                        let value = sqlite3_column_int64(statement, i)
                        row[columnName] = Int64(value)
                    case SQLITE_FLOAT:
                        let value = sqlite3_column_double(statement, i)
                        row[columnName] = Double(value)
                    case SQLITE_TEXT:
                        if let cString = sqlite3_column_text(statement, i) {
                            let value = String(cString: cString)
                            row[columnName] = value
                        }
                    case SQLITE_BLOB:
                        if let dataPtr = sqlite3_column_blob(statement, i) {
                            let size = sqlite3_column_bytes(statement, i)
                            let data = Data(bytes: dataPtr, count: Int(size))
                            row[columnName] = data
                        }
                    case SQLITE_NULL:
                        row[columnName] = NSNull()
                    default:
                        NSLog("Unknown column type: \(columnType)")
                    }
                }
                
                results.append(row)
            }
        } else {
            NSLog("Error preparing query: \(String(cString: sqlite3_errmsg(database)))")
            sqlite3_finalize(statement)
            return nil
        }
        
        sqlite3_finalize(statement)
        return results
    }
}
