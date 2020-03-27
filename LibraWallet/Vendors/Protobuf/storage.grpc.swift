//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: storage.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import Foundation
import Dispatch
import SwiftGRPC
import SwiftProtobuf

internal protocol Storage_StorageSaveTransactionsCall: ClientCallUnary {}

fileprivate final class Storage_StorageSaveTransactionsCallBase: ClientCallUnaryBase<Storage_SaveTransactionsRequest, Storage_SaveTransactionsResponse>, Storage_StorageSaveTransactionsCall {
  override class var method: String { return "/storage.Storage/SaveTransactions" }
}

internal protocol Storage_StorageUpdateToLatestLedgerCall: ClientCallUnary {}

fileprivate final class Storage_StorageUpdateToLatestLedgerCallBase: ClientCallUnaryBase<Types_UpdateToLatestLedgerRequest, Types_UpdateToLatestLedgerResponse>, Storage_StorageUpdateToLatestLedgerCall {
  override class var method: String { return "/storage.Storage/UpdateToLatestLedger" }
}

internal protocol Storage_StorageGetTransactionsCall: ClientCallUnary {}

fileprivate final class Storage_StorageGetTransactionsCallBase: ClientCallUnaryBase<Storage_GetTransactionsRequest, Storage_GetTransactionsResponse>, Storage_StorageGetTransactionsCall {
  override class var method: String { return "/storage.Storage/GetTransactions" }
}

internal protocol Storage_StorageGetLatestStateRootCall: ClientCallUnary {}

fileprivate final class Storage_StorageGetLatestStateRootCallBase: ClientCallUnaryBase<Storage_GetLatestStateRootRequest, Storage_GetLatestStateRootResponse>, Storage_StorageGetLatestStateRootCall {
  override class var method: String { return "/storage.Storage/GetLatestStateRoot" }
}

internal protocol Storage_StorageGetLatestAccountStateCall: ClientCallUnary {}

fileprivate final class Storage_StorageGetLatestAccountStateCallBase: ClientCallUnaryBase<Storage_GetLatestAccountStateRequest, Storage_GetLatestAccountStateResponse>, Storage_StorageGetLatestAccountStateCall {
  override class var method: String { return "/storage.Storage/GetLatestAccountState" }
}

internal protocol Storage_StorageGetAccountStateWithProofByVersionCall: ClientCallUnary {}

fileprivate final class Storage_StorageGetAccountStateWithProofByVersionCallBase: ClientCallUnaryBase<Storage_GetAccountStateWithProofByVersionRequest, Storage_GetAccountStateWithProofByVersionResponse>, Storage_StorageGetAccountStateWithProofByVersionCall {
  override class var method: String { return "/storage.Storage/GetAccountStateWithProofByVersion" }
}

internal protocol Storage_StorageGetStartupInfoCall: ClientCallUnary {}

fileprivate final class Storage_StorageGetStartupInfoCallBase: ClientCallUnaryBase<Storage_GetStartupInfoRequest, Storage_GetStartupInfoResponse>, Storage_StorageGetStartupInfoCall {
  override class var method: String { return "/storage.Storage/GetStartupInfo" }
}

internal protocol Storage_StorageGetEpochChangeLedgerInfosCall: ClientCallUnary {}

fileprivate final class Storage_StorageGetEpochChangeLedgerInfosCallBase: ClientCallUnaryBase<Storage_GetEpochChangeLedgerInfosRequest, Types_ValidatorChangeProof>, Storage_StorageGetEpochChangeLedgerInfosCall {
  override class var method: String { return "/storage.Storage/GetEpochChangeLedgerInfos" }
}

internal protocol Storage_StorageBackupAccountStateCall: ClientCallServerStreaming {
  /// Do not call this directly, call `receive()` in the protocol extension below instead.
  func _receive(timeout: DispatchTime) throws -> Storage_BackupAccountStateResponse?
  /// Call this to wait for a result. Nonblocking.
  func receive(completion: @escaping (ResultOrRPCError<Storage_BackupAccountStateResponse?>) -> Void) throws
}

internal extension Storage_StorageBackupAccountStateCall {
  /// Call this to wait for a result. Blocking.
  func receive(timeout: DispatchTime = .distantFuture) throws -> Storage_BackupAccountStateResponse? { return try self._receive(timeout: timeout) }
}

fileprivate final class Storage_StorageBackupAccountStateCallBase: ClientCallServerStreamingBase<Storage_BackupAccountStateRequest, Storage_BackupAccountStateResponse>, Storage_StorageBackupAccountStateCall {
  override class var method: String { return "/storage.Storage/BackupAccountState" }
}

internal protocol Storage_StorageGetAccountStateRangeProofCall: ClientCallUnary {}

fileprivate final class Storage_StorageGetAccountStateRangeProofCallBase: ClientCallUnaryBase<Storage_GetAccountStateRangeProofRequest, Storage_GetAccountStateRangeProofResponse>, Storage_StorageGetAccountStateRangeProofCall {
  override class var method: String { return "/storage.Storage/GetAccountStateRangeProof" }
}

internal protocol Storage_StorageBackupTransactionCall: ClientCallServerStreaming {
  /// Do not call this directly, call `receive()` in the protocol extension below instead.
  func _receive(timeout: DispatchTime) throws -> Storage_BackupTransactionResponse?
  /// Call this to wait for a result. Nonblocking.
  func receive(completion: @escaping (ResultOrRPCError<Storage_BackupTransactionResponse?>) -> Void) throws
}

internal extension Storage_StorageBackupTransactionCall {
  /// Call this to wait for a result. Blocking.
  func receive(timeout: DispatchTime = .distantFuture) throws -> Storage_BackupTransactionResponse? { return try self._receive(timeout: timeout) }
}

fileprivate final class Storage_StorageBackupTransactionCallBase: ClientCallServerStreamingBase<Storage_BackupTransactionRequest, Storage_BackupTransactionResponse>, Storage_StorageBackupTransactionCall {
  override class var method: String { return "/storage.Storage/BackupTransaction" }
}

internal protocol Storage_StorageBackupTransactionInfoCall: ClientCallServerStreaming {
  /// Do not call this directly, call `receive()` in the protocol extension below instead.
  func _receive(timeout: DispatchTime) throws -> Storage_BackupTransactionInfoResponse?
  /// Call this to wait for a result. Nonblocking.
  func receive(completion: @escaping (ResultOrRPCError<Storage_BackupTransactionInfoResponse?>) -> Void) throws
}

internal extension Storage_StorageBackupTransactionInfoCall {
  /// Call this to wait for a result. Blocking.
  func receive(timeout: DispatchTime = .distantFuture) throws -> Storage_BackupTransactionInfoResponse? { return try self._receive(timeout: timeout) }
}

fileprivate final class Storage_StorageBackupTransactionInfoCallBase: ClientCallServerStreamingBase<Storage_BackupTransactionInfoRequest, Storage_BackupTransactionInfoResponse>, Storage_StorageBackupTransactionInfoCall {
  override class var method: String { return "/storage.Storage/BackupTransactionInfo" }
}


/// Instantiate Storage_StorageServiceClient, then call methods of this protocol to make API calls.
internal protocol Storage_StorageService: ServiceClient {
  /// Synchronous. Unary.
  func saveTransactions(_ request: Storage_SaveTransactionsRequest) throws -> Storage_SaveTransactionsResponse
  /// Asynchronous. Unary.
  func saveTransactions(_ request: Storage_SaveTransactionsRequest, completion: @escaping (Storage_SaveTransactionsResponse?, CallResult) -> Void) throws -> Storage_StorageSaveTransactionsCall

  /// Synchronous. Unary.
  func updateToLatestLedger(_ request: Types_UpdateToLatestLedgerRequest) throws -> Types_UpdateToLatestLedgerResponse
  /// Asynchronous. Unary.
  func updateToLatestLedger(_ request: Types_UpdateToLatestLedgerRequest, completion: @escaping (Types_UpdateToLatestLedgerResponse?, CallResult) -> Void) throws -> Storage_StorageUpdateToLatestLedgerCall

  /// Synchronous. Unary.
  func getTransactions(_ request: Storage_GetTransactionsRequest) throws -> Storage_GetTransactionsResponse
  /// Asynchronous. Unary.
  func getTransactions(_ request: Storage_GetTransactionsRequest, completion: @escaping (Storage_GetTransactionsResponse?, CallResult) -> Void) throws -> Storage_StorageGetTransactionsCall

  /// Synchronous. Unary.
  func getLatestStateRoot(_ request: Storage_GetLatestStateRootRequest) throws -> Storage_GetLatestStateRootResponse
  /// Asynchronous. Unary.
  func getLatestStateRoot(_ request: Storage_GetLatestStateRootRequest, completion: @escaping (Storage_GetLatestStateRootResponse?, CallResult) -> Void) throws -> Storage_StorageGetLatestStateRootCall

  /// Synchronous. Unary.
  func getLatestAccountState(_ request: Storage_GetLatestAccountStateRequest) throws -> Storage_GetLatestAccountStateResponse
  /// Asynchronous. Unary.
  func getLatestAccountState(_ request: Storage_GetLatestAccountStateRequest, completion: @escaping (Storage_GetLatestAccountStateResponse?, CallResult) -> Void) throws -> Storage_StorageGetLatestAccountStateCall

  /// Synchronous. Unary.
  func getAccountStateWithProofByVersion(_ request: Storage_GetAccountStateWithProofByVersionRequest) throws -> Storage_GetAccountStateWithProofByVersionResponse
  /// Asynchronous. Unary.
  func getAccountStateWithProofByVersion(_ request: Storage_GetAccountStateWithProofByVersionRequest, completion: @escaping (Storage_GetAccountStateWithProofByVersionResponse?, CallResult) -> Void) throws -> Storage_StorageGetAccountStateWithProofByVersionCall

  /// Synchronous. Unary.
  func getStartupInfo(_ request: Storage_GetStartupInfoRequest) throws -> Storage_GetStartupInfoResponse
  /// Asynchronous. Unary.
  func getStartupInfo(_ request: Storage_GetStartupInfoRequest, completion: @escaping (Storage_GetStartupInfoResponse?, CallResult) -> Void) throws -> Storage_StorageGetStartupInfoCall

  /// Synchronous. Unary.
  func getEpochChangeLedgerInfos(_ request: Storage_GetEpochChangeLedgerInfosRequest) throws -> Types_ValidatorChangeProof
  /// Asynchronous. Unary.
  func getEpochChangeLedgerInfos(_ request: Storage_GetEpochChangeLedgerInfosRequest, completion: @escaping (Types_ValidatorChangeProof?, CallResult) -> Void) throws -> Storage_StorageGetEpochChangeLedgerInfosCall

  /// Asynchronous. Server-streaming.
  /// Send the initial message.
  /// Use methods on the returned object to get streamed responses.
  func backupAccountState(_ request: Storage_BackupAccountStateRequest, completion: ((CallResult) -> Void)?) throws -> Storage_StorageBackupAccountStateCall

  /// Synchronous. Unary.
  func getAccountStateRangeProof(_ request: Storage_GetAccountStateRangeProofRequest) throws -> Storage_GetAccountStateRangeProofResponse
  /// Asynchronous. Unary.
  func getAccountStateRangeProof(_ request: Storage_GetAccountStateRangeProofRequest, completion: @escaping (Storage_GetAccountStateRangeProofResponse?, CallResult) -> Void) throws -> Storage_StorageGetAccountStateRangeProofCall

  /// Asynchronous. Server-streaming.
  /// Send the initial message.
  /// Use methods on the returned object to get streamed responses.
  func backupTransaction(_ request: Storage_BackupTransactionRequest, completion: ((CallResult) -> Void)?) throws -> Storage_StorageBackupTransactionCall

  /// Asynchronous. Server-streaming.
  /// Send the initial message.
  /// Use methods on the returned object to get streamed responses.
  func backupTransactionInfo(_ request: Storage_BackupTransactionInfoRequest, completion: ((CallResult) -> Void)?) throws -> Storage_StorageBackupTransactionInfoCall

}

internal final class Storage_StorageServiceClient: ServiceClientBase, Storage_StorageService {
  /// Synchronous. Unary.
  internal func saveTransactions(_ request: Storage_SaveTransactionsRequest) throws -> Storage_SaveTransactionsResponse {
    return try Storage_StorageSaveTransactionsCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func saveTransactions(_ request: Storage_SaveTransactionsRequest, completion: @escaping (Storage_SaveTransactionsResponse?, CallResult) -> Void) throws -> Storage_StorageSaveTransactionsCall {
    return try Storage_StorageSaveTransactionsCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func updateToLatestLedger(_ request: Types_UpdateToLatestLedgerRequest) throws -> Types_UpdateToLatestLedgerResponse {
    return try Storage_StorageUpdateToLatestLedgerCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func updateToLatestLedger(_ request: Types_UpdateToLatestLedgerRequest, completion: @escaping (Types_UpdateToLatestLedgerResponse?, CallResult) -> Void) throws -> Storage_StorageUpdateToLatestLedgerCall {
    return try Storage_StorageUpdateToLatestLedgerCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func getTransactions(_ request: Storage_GetTransactionsRequest) throws -> Storage_GetTransactionsResponse {
    return try Storage_StorageGetTransactionsCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getTransactions(_ request: Storage_GetTransactionsRequest, completion: @escaping (Storage_GetTransactionsResponse?, CallResult) -> Void) throws -> Storage_StorageGetTransactionsCall {
    return try Storage_StorageGetTransactionsCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func getLatestStateRoot(_ request: Storage_GetLatestStateRootRequest) throws -> Storage_GetLatestStateRootResponse {
    return try Storage_StorageGetLatestStateRootCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getLatestStateRoot(_ request: Storage_GetLatestStateRootRequest, completion: @escaping (Storage_GetLatestStateRootResponse?, CallResult) -> Void) throws -> Storage_StorageGetLatestStateRootCall {
    return try Storage_StorageGetLatestStateRootCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func getLatestAccountState(_ request: Storage_GetLatestAccountStateRequest) throws -> Storage_GetLatestAccountStateResponse {
    return try Storage_StorageGetLatestAccountStateCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getLatestAccountState(_ request: Storage_GetLatestAccountStateRequest, completion: @escaping (Storage_GetLatestAccountStateResponse?, CallResult) -> Void) throws -> Storage_StorageGetLatestAccountStateCall {
    return try Storage_StorageGetLatestAccountStateCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func getAccountStateWithProofByVersion(_ request: Storage_GetAccountStateWithProofByVersionRequest) throws -> Storage_GetAccountStateWithProofByVersionResponse {
    return try Storage_StorageGetAccountStateWithProofByVersionCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getAccountStateWithProofByVersion(_ request: Storage_GetAccountStateWithProofByVersionRequest, completion: @escaping (Storage_GetAccountStateWithProofByVersionResponse?, CallResult) -> Void) throws -> Storage_StorageGetAccountStateWithProofByVersionCall {
    return try Storage_StorageGetAccountStateWithProofByVersionCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func getStartupInfo(_ request: Storage_GetStartupInfoRequest) throws -> Storage_GetStartupInfoResponse {
    return try Storage_StorageGetStartupInfoCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getStartupInfo(_ request: Storage_GetStartupInfoRequest, completion: @escaping (Storage_GetStartupInfoResponse?, CallResult) -> Void) throws -> Storage_StorageGetStartupInfoCall {
    return try Storage_StorageGetStartupInfoCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func getEpochChangeLedgerInfos(_ request: Storage_GetEpochChangeLedgerInfosRequest) throws -> Types_ValidatorChangeProof {
    return try Storage_StorageGetEpochChangeLedgerInfosCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getEpochChangeLedgerInfos(_ request: Storage_GetEpochChangeLedgerInfosRequest, completion: @escaping (Types_ValidatorChangeProof?, CallResult) -> Void) throws -> Storage_StorageGetEpochChangeLedgerInfosCall {
    return try Storage_StorageGetEpochChangeLedgerInfosCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Asynchronous. Server-streaming.
  /// Send the initial message.
  /// Use methods on the returned object to get streamed responses.
  internal func backupAccountState(_ request: Storage_BackupAccountStateRequest, completion: ((CallResult) -> Void)?) throws -> Storage_StorageBackupAccountStateCall {
    return try Storage_StorageBackupAccountStateCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Synchronous. Unary.
  internal func getAccountStateRangeProof(_ request: Storage_GetAccountStateRangeProofRequest) throws -> Storage_GetAccountStateRangeProofResponse {
    return try Storage_StorageGetAccountStateRangeProofCallBase(channel)
      .run(request: request, metadata: metadata)
  }
  /// Asynchronous. Unary.
  internal func getAccountStateRangeProof(_ request: Storage_GetAccountStateRangeProofRequest, completion: @escaping (Storage_GetAccountStateRangeProofResponse?, CallResult) -> Void) throws -> Storage_StorageGetAccountStateRangeProofCall {
    return try Storage_StorageGetAccountStateRangeProofCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Asynchronous. Server-streaming.
  /// Send the initial message.
  /// Use methods on the returned object to get streamed responses.
  internal func backupTransaction(_ request: Storage_BackupTransactionRequest, completion: ((CallResult) -> Void)?) throws -> Storage_StorageBackupTransactionCall {
    return try Storage_StorageBackupTransactionCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

  /// Asynchronous. Server-streaming.
  /// Send the initial message.
  /// Use methods on the returned object to get streamed responses.
  internal func backupTransactionInfo(_ request: Storage_BackupTransactionInfoRequest, completion: ((CallResult) -> Void)?) throws -> Storage_StorageBackupTransactionInfoCall {
    return try Storage_StorageBackupTransactionInfoCallBase(channel)
      .start(request: request, metadata: metadata, completion: completion)
  }

}

/// To build a server, implement a class that conforms to this protocol.
/// If one of the methods returning `ServerStatus?` returns nil,
/// it is expected that you have already returned a status to the client by means of `session.close`.
internal protocol Storage_StorageProvider: ServiceProvider {
  func saveTransactions(request: Storage_SaveTransactionsRequest, session: Storage_StorageSaveTransactionsSession) throws -> Storage_SaveTransactionsResponse
  func updateToLatestLedger(request: Types_UpdateToLatestLedgerRequest, session: Storage_StorageUpdateToLatestLedgerSession) throws -> Types_UpdateToLatestLedgerResponse
  func getTransactions(request: Storage_GetTransactionsRequest, session: Storage_StorageGetTransactionsSession) throws -> Storage_GetTransactionsResponse
  func getLatestStateRoot(request: Storage_GetLatestStateRootRequest, session: Storage_StorageGetLatestStateRootSession) throws -> Storage_GetLatestStateRootResponse
  func getLatestAccountState(request: Storage_GetLatestAccountStateRequest, session: Storage_StorageGetLatestAccountStateSession) throws -> Storage_GetLatestAccountStateResponse
  func getAccountStateWithProofByVersion(request: Storage_GetAccountStateWithProofByVersionRequest, session: Storage_StorageGetAccountStateWithProofByVersionSession) throws -> Storage_GetAccountStateWithProofByVersionResponse
  func getStartupInfo(request: Storage_GetStartupInfoRequest, session: Storage_StorageGetStartupInfoSession) throws -> Storage_GetStartupInfoResponse
  func getEpochChangeLedgerInfos(request: Storage_GetEpochChangeLedgerInfosRequest, session: Storage_StorageGetEpochChangeLedgerInfosSession) throws -> Types_ValidatorChangeProof
  func backupAccountState(request: Storage_BackupAccountStateRequest, session: Storage_StorageBackupAccountStateSession) throws -> ServerStatus?
  func getAccountStateRangeProof(request: Storage_GetAccountStateRangeProofRequest, session: Storage_StorageGetAccountStateRangeProofSession) throws -> Storage_GetAccountStateRangeProofResponse
  func backupTransaction(request: Storage_BackupTransactionRequest, session: Storage_StorageBackupTransactionSession) throws -> ServerStatus?
  func backupTransactionInfo(request: Storage_BackupTransactionInfoRequest, session: Storage_StorageBackupTransactionInfoSession) throws -> ServerStatus?
}

extension Storage_StorageProvider {
  internal var serviceName: String { return "storage.Storage" }

  /// Determines and calls the appropriate request handler, depending on the request's method.
  /// Throws `HandleMethodError.unknownMethod` for methods not handled by this service.
  internal func handleMethod(_ method: String, handler: Handler) throws -> ServerStatus? {
    switch method {
    case "/storage.Storage/SaveTransactions":
      return try Storage_StorageSaveTransactionsSessionBase(
        handler: handler,
        providerBlock: { try self.saveTransactions(request: $0, session: $1 as! Storage_StorageSaveTransactionsSessionBase) })
          .run()
    case "/storage.Storage/UpdateToLatestLedger":
      return try Storage_StorageUpdateToLatestLedgerSessionBase(
        handler: handler,
        providerBlock: { try self.updateToLatestLedger(request: $0, session: $1 as! Storage_StorageUpdateToLatestLedgerSessionBase) })
          .run()
    case "/storage.Storage/GetTransactions":
      return try Storage_StorageGetTransactionsSessionBase(
        handler: handler,
        providerBlock: { try self.getTransactions(request: $0, session: $1 as! Storage_StorageGetTransactionsSessionBase) })
          .run()
    case "/storage.Storage/GetLatestStateRoot":
      return try Storage_StorageGetLatestStateRootSessionBase(
        handler: handler,
        providerBlock: { try self.getLatestStateRoot(request: $0, session: $1 as! Storage_StorageGetLatestStateRootSessionBase) })
          .run()
    case "/storage.Storage/GetLatestAccountState":
      return try Storage_StorageGetLatestAccountStateSessionBase(
        handler: handler,
        providerBlock: { try self.getLatestAccountState(request: $0, session: $1 as! Storage_StorageGetLatestAccountStateSessionBase) })
          .run()
    case "/storage.Storage/GetAccountStateWithProofByVersion":
      return try Storage_StorageGetAccountStateWithProofByVersionSessionBase(
        handler: handler,
        providerBlock: { try self.getAccountStateWithProofByVersion(request: $0, session: $1 as! Storage_StorageGetAccountStateWithProofByVersionSessionBase) })
          .run()
    case "/storage.Storage/GetStartupInfo":
      return try Storage_StorageGetStartupInfoSessionBase(
        handler: handler,
        providerBlock: { try self.getStartupInfo(request: $0, session: $1 as! Storage_StorageGetStartupInfoSessionBase) })
          .run()
    case "/storage.Storage/GetEpochChangeLedgerInfos":
      return try Storage_StorageGetEpochChangeLedgerInfosSessionBase(
        handler: handler,
        providerBlock: { try self.getEpochChangeLedgerInfos(request: $0, session: $1 as! Storage_StorageGetEpochChangeLedgerInfosSessionBase) })
          .run()
    case "/storage.Storage/BackupAccountState":
      return try Storage_StorageBackupAccountStateSessionBase(
        handler: handler,
        providerBlock: { try self.backupAccountState(request: $0, session: $1 as! Storage_StorageBackupAccountStateSessionBase) })
          .run()
    case "/storage.Storage/GetAccountStateRangeProof":
      return try Storage_StorageGetAccountStateRangeProofSessionBase(
        handler: handler,
        providerBlock: { try self.getAccountStateRangeProof(request: $0, session: $1 as! Storage_StorageGetAccountStateRangeProofSessionBase) })
          .run()
    case "/storage.Storage/BackupTransaction":
      return try Storage_StorageBackupTransactionSessionBase(
        handler: handler,
        providerBlock: { try self.backupTransaction(request: $0, session: $1 as! Storage_StorageBackupTransactionSessionBase) })
          .run()
    case "/storage.Storage/BackupTransactionInfo":
      return try Storage_StorageBackupTransactionInfoSessionBase(
        handler: handler,
        providerBlock: { try self.backupTransactionInfo(request: $0, session: $1 as! Storage_StorageBackupTransactionInfoSessionBase) })
          .run()
    default:
      throw HandleMethodError.unknownMethod
    }
  }
}

internal protocol Storage_StorageSaveTransactionsSession: ServerSessionUnary {}

fileprivate final class Storage_StorageSaveTransactionsSessionBase: ServerSessionUnaryBase<Storage_SaveTransactionsRequest, Storage_SaveTransactionsResponse>, Storage_StorageSaveTransactionsSession {}

internal protocol Storage_StorageUpdateToLatestLedgerSession: ServerSessionUnary {}

fileprivate final class Storage_StorageUpdateToLatestLedgerSessionBase: ServerSessionUnaryBase<Types_UpdateToLatestLedgerRequest, Types_UpdateToLatestLedgerResponse>, Storage_StorageUpdateToLatestLedgerSession {}

internal protocol Storage_StorageGetTransactionsSession: ServerSessionUnary {}

fileprivate final class Storage_StorageGetTransactionsSessionBase: ServerSessionUnaryBase<Storage_GetTransactionsRequest, Storage_GetTransactionsResponse>, Storage_StorageGetTransactionsSession {}

internal protocol Storage_StorageGetLatestStateRootSession: ServerSessionUnary {}

fileprivate final class Storage_StorageGetLatestStateRootSessionBase: ServerSessionUnaryBase<Storage_GetLatestStateRootRequest, Storage_GetLatestStateRootResponse>, Storage_StorageGetLatestStateRootSession {}

internal protocol Storage_StorageGetLatestAccountStateSession: ServerSessionUnary {}

fileprivate final class Storage_StorageGetLatestAccountStateSessionBase: ServerSessionUnaryBase<Storage_GetLatestAccountStateRequest, Storage_GetLatestAccountStateResponse>, Storage_StorageGetLatestAccountStateSession {}

internal protocol Storage_StorageGetAccountStateWithProofByVersionSession: ServerSessionUnary {}

fileprivate final class Storage_StorageGetAccountStateWithProofByVersionSessionBase: ServerSessionUnaryBase<Storage_GetAccountStateWithProofByVersionRequest, Storage_GetAccountStateWithProofByVersionResponse>, Storage_StorageGetAccountStateWithProofByVersionSession {}

internal protocol Storage_StorageGetStartupInfoSession: ServerSessionUnary {}

fileprivate final class Storage_StorageGetStartupInfoSessionBase: ServerSessionUnaryBase<Storage_GetStartupInfoRequest, Storage_GetStartupInfoResponse>, Storage_StorageGetStartupInfoSession {}

internal protocol Storage_StorageGetEpochChangeLedgerInfosSession: ServerSessionUnary {}

fileprivate final class Storage_StorageGetEpochChangeLedgerInfosSessionBase: ServerSessionUnaryBase<Storage_GetEpochChangeLedgerInfosRequest, Types_ValidatorChangeProof>, Storage_StorageGetEpochChangeLedgerInfosSession {}

internal protocol Storage_StorageBackupAccountStateSession: ServerSessionServerStreaming {
  /// Send a message to the stream. Nonblocking.
  func send(_ message: Storage_BackupAccountStateResponse, completion: @escaping (Error?) -> Void) throws
  /// Do not call this directly, call `send()` in the protocol extension below instead.
  func _send(_ message: Storage_BackupAccountStateResponse, timeout: DispatchTime) throws

  /// Close the connection and send the status. Non-blocking.
  /// This method should be called if and only if your request handler returns a nil value instead of a server status;
  /// otherwise SwiftGRPC will take care of sending the status for you.
  func close(withStatus status: ServerStatus, completion: (() -> Void)?) throws
}

internal extension Storage_StorageBackupAccountStateSession {
  /// Send a message to the stream and wait for the send operation to finish. Blocking.
  func send(_ message: Storage_BackupAccountStateResponse, timeout: DispatchTime = .distantFuture) throws { try self._send(message, timeout: timeout) }
}

fileprivate final class Storage_StorageBackupAccountStateSessionBase: ServerSessionServerStreamingBase<Storage_BackupAccountStateRequest, Storage_BackupAccountStateResponse>, Storage_StorageBackupAccountStateSession {}

internal protocol Storage_StorageGetAccountStateRangeProofSession: ServerSessionUnary {}

fileprivate final class Storage_StorageGetAccountStateRangeProofSessionBase: ServerSessionUnaryBase<Storage_GetAccountStateRangeProofRequest, Storage_GetAccountStateRangeProofResponse>, Storage_StorageGetAccountStateRangeProofSession {}

internal protocol Storage_StorageBackupTransactionSession: ServerSessionServerStreaming {
  /// Send a message to the stream. Nonblocking.
  func send(_ message: Storage_BackupTransactionResponse, completion: @escaping (Error?) -> Void) throws
  /// Do not call this directly, call `send()` in the protocol extension below instead.
  func _send(_ message: Storage_BackupTransactionResponse, timeout: DispatchTime) throws

  /// Close the connection and send the status. Non-blocking.
  /// This method should be called if and only if your request handler returns a nil value instead of a server status;
  /// otherwise SwiftGRPC will take care of sending the status for you.
  func close(withStatus status: ServerStatus, completion: (() -> Void)?) throws
}

internal extension Storage_StorageBackupTransactionSession {
  /// Send a message to the stream and wait for the send operation to finish. Blocking.
  func send(_ message: Storage_BackupTransactionResponse, timeout: DispatchTime = .distantFuture) throws { try self._send(message, timeout: timeout) }
}

fileprivate final class Storage_StorageBackupTransactionSessionBase: ServerSessionServerStreamingBase<Storage_BackupTransactionRequest, Storage_BackupTransactionResponse>, Storage_StorageBackupTransactionSession {}

internal protocol Storage_StorageBackupTransactionInfoSession: ServerSessionServerStreaming {
  /// Send a message to the stream. Nonblocking.
  func send(_ message: Storage_BackupTransactionInfoResponse, completion: @escaping (Error?) -> Void) throws
  /// Do not call this directly, call `send()` in the protocol extension below instead.
  func _send(_ message: Storage_BackupTransactionInfoResponse, timeout: DispatchTime) throws

  /// Close the connection and send the status. Non-blocking.
  /// This method should be called if and only if your request handler returns a nil value instead of a server status;
  /// otherwise SwiftGRPC will take care of sending the status for you.
  func close(withStatus status: ServerStatus, completion: (() -> Void)?) throws
}

internal extension Storage_StorageBackupTransactionInfoSession {
  /// Send a message to the stream and wait for the send operation to finish. Blocking.
  func send(_ message: Storage_BackupTransactionInfoResponse, timeout: DispatchTime = .distantFuture) throws { try self._send(message, timeout: timeout) }
}

fileprivate final class Storage_StorageBackupTransactionInfoSessionBase: ServerSessionServerStreamingBase<Storage_BackupTransactionInfoRequest, Storage_BackupTransactionInfoResponse>, Storage_StorageBackupTransactionInfoSession {}

