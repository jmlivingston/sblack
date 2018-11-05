#import <Cocoa/Cocoa.h>
#import <Security/Authorization.h>

@interface BLAuthentication : NSObject 
{
	AuthorizationRef authorizationRef; 
}
// returns a shared instance of the class
+ sharedInstance;
// checks if user is authentcated forCommands
- (BOOL)isAuthenticated:(NSArray *)forCommands;
// authenticates user forCommands
- (BOOL)authenticate:(NSArray *)forCommands;
// deauthenticates user
- (void)deauthenticate;
// gets the pid forProcess
- (int)getPID:(NSString *)forProcess;
// executes pathToCommand with privileges
- (BOOL)executeCommand:(NSString *)pathToCommand withArgs:(NSArray *)arguments andType:(NSString*)type andMessage:(NSString*)message;

+ (void)postAlert:(NSNotification *)aAlert;

@end
