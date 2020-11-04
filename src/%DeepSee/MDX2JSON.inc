ROUTINE %DeepSee.MDX2JSON [Type=INC]
#include %occErrors
#include %ZEN.Utils
#define get(%name) $get(%request.Data(%name,1))
#define Debug $d(%request.Data("Debug"))
#define Public ((%request.GetCgiEnv("SERVER_PORT") = 80) || (%request.GetCgiEnv("SERVER_PORT") = 443))
#define Private '$$$Public