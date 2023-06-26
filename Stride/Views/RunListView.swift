////
////  RunListView.swift
////  Stride
////
////  Created by Madhu Ramkumar on 6/21/23.
////
//
//import SwiftUI
//import CoreData
//
//struct RunListView: View {
//    @Environment(\.managedObjectContext) var managedObjectContext
//    
//    var body: some View {
//        Button(action: {
//            // Create a new run.
//            let run = Run(context: managedObjectContext)
//            run.date = Date.now
//            run.distance = 5.0
//            run.duration = 30
//
//            // Save the run to persistent storage.
//            try? managedObjectContext.save()
//        }) {
//            Text("Save Run")
//        }
//        
//        let fetchRequest = NSFetchRequest<Run>(entityName: "Run")
//        let runs = try? managedObjectContext.fetch(fetchRequest)
//        List(runs ?? []) { run in
//            Text("Distance: \(run.distance)")
//        }
//    }
//}
//
//struct RunListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RunListView()
//    }
//}
