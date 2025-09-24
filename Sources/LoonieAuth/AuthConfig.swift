import Foundation

public protocol AuthConfig {
  var supabaseURL: URL { get }
  var supabaseAnonKey: String { get }
  var appId: String { get }
}

public struct StaticAuthConfig: AuthConfig {
  public let supabaseURL: URL
  public let supabaseAnonKey: String
  public let appId: String
  public init(supabaseURL: URL, supabaseAnonKey: String, appId: String) {
    self.supabaseURL = supabaseURL
    self.supabaseAnonKey = supabaseAnonKey
    self.appId = appId
  }
    
 

}
