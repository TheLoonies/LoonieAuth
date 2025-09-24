// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Supabase

// Payload for membership upsert.
private struct MembershipRow: Encodable {
  let AppId: String
  let UserId: String
  let Role: String
}

// Tiny helper around Supabase auth + my app membership.
public final class LoonieAuth {
    private let client: SupabaseClient
    private let appId: String
    
    public init(config: AuthConfig) {
        self.client = SupabaseClient(supabaseURL: config.supabaseURL, supabaseKey: config.supabaseAnonKey)
        self.appId = config.appId
    }
    
    
    // Email/password sign up, then set claim and membership.
    public func signUp(email: String, password: String) async throws {
      _ = try await client.auth.signUp(email: email, password: password)
      try await ensureAppIdClaim()
      try await ensureMembershipRow()
    }
    // Email/password sign in, then set claim and ensure membership.
    public func signIn(email: String, password: String) async throws {
      _ = try await client.auth.signIn(email: email, password: password)
      try await ensureAppIdClaim()
      try await ensureMembershipRow()
    }
    // Sign out on this device.
    public func signOut() async throws {
      try await client.auth.signOut()
    }
    
    // Placeholder: write app_id to JWT later.
    public func ensureAppIdClaim() async throws {
        // no-op placeholder; kept async/throws for consistent call sites
    }
    
    // Upsert (AppId, UserId, 'member') into TheLoonies_AppMembership or ANY table name.
    public func ensureMembershipRow() async throws {
      // Access session from the auth actor (requires await and can throw)
      let uid = try await client.auth.session.user.id.uuidString
      
      // Encode via a concrete Encodable struct (avoids AnyEncodable dependency)
      let row = MembershipRow(AppId: appId, UserId: uid, Role: "member")
      
      // Use upsert instead of insert(onConflict:) to match current SDK signature
      _ = try await client
        .from("TheLoonies_AppMembership")
        .upsert([row])
        .execute()
    }
}
