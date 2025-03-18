//
//  CoreDateUserResponseStorage.swift
//  Posts
//
//  Created by M-M-M on 17/03/2025.
//

import Foundation
import CoreData
import Combine

final class CoreDateUserResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private
    private func fetchRequest(for requestDto: FetchUserDataRequestDTO) -> NSFetchRequest<UserDataEntity> {
        let request: NSFetchRequest = UserDataEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %d",
                                        #keyPath(UserDataEntity.userId), requestDto.id)
        return request
    }

    private func deleteResponse(for requestDto: FetchUserDataRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDateUserResponseStorage: UserDataResponseStorage {

    func getResponse(for request: FetchUserDataRequestDTO) -> AnyPublisher<FetchUserDataResponseDTO?, CoreDataStorageError> {
        return Future<FetchUserDataResponseDTO?, CoreDataStorageError> { promise in
            self.coreDataStorage.performBackgroundTask { context in
                do {
                    let fetchRequest = self.fetchRequest(for: request)
                    let requestEntity = try context.fetch(fetchRequest).first
                    
                    promise(.success(requestEntity?.toDTO()))
                } catch {
                    promise(.failure(CoreDataStorageError.readError(error)))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func save(response: FetchUserDataResponseDTO, for request: FetchUserDataRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: request, in: context)

                let entity = response.toEntity(in: context)
                try context.save()
            } catch {
                debugPrint("CoreDateUserResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
