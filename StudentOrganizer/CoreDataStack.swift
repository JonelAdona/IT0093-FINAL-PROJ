internal import CoreData
 
/// One shared object that owns the Core Data "stack" (model + database + context).
/// Every screen talks to the database through CoreDataStack.shared.
final class CoreDataStack {
 
    static let shared = CoreDataStack()
 
    /// Loads StudentOrganizer.xcdatamodeld and creates the SQLite file on the device.
    let container: NSPersistentContainer
 
    /// The "scratchpad" where we create, change, and delete objects before saving.
    var context: NSManagedObjectContext { container.viewContext }
 
    private init() {
        // The name MUST match the .xcdatamodeld file name exactly.
        container = NSPersistentContainer(name: "StudentOrganizer")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                // If the database cannot load, the app cannot work at all.
                fatalError("Core Data failed to load: \(error)")
            }
            print("Database file: \(storeDescription.url?.path ?? "unknown")")
        }

        print(
            container.managedObjectModel.entities.map {
                "\($0.name ?? "No name") -> \($0.managedObjectClassName ?? "No class")"
            }
        )
    }
    
    
//    private init() {
//        guard let modelURL = Bundle.main.url(
//            forResource: "StudentOrganizer",
//            withExtension: "momd"
//        ) else {
//            fatalError("StudentOrganizer.momd was not found in the app bundle")
//        }
//
//        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
//            fatalError("Could not open StudentOrganizer.momd")
//        }
//
//        print("Entities:", model.entities.map {
//            "\($0.name ?? "Unknown") -> \($0.managedObjectClassName ?? "Unknown")"
//        })
//
//        container = NSPersistentContainer(
//            name: "StudentOrganizer",
//            managedObjectModel: model
//        )
//
//        container.loadPersistentStores { storeDescription, error in
//            if let error = error {
//                fatalError("Core Data failed to load: \(error)")
//            }
//
//            print("Database file:", storeDescription.url?.path ?? "unknown")
//        }
//    }
 
    /// Writes any pending changes to the database file.
    func save() {
        guard context.hasChanges else { return }
                do {
                    try context.save()
                } catch {
                    print("Core Data save failed: \(error)")
                }
            }
        }
