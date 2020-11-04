ROUTINE %occSSH [Type=INC]
#include %callout
 
#; ------------------------------------------------------------------------
#; Error Handling
#; ------------------------------------------------------------------------
 
#define SSHERROR(%r,%o) $$$ERROR($$$SSHGeneralError,$LI(%r,1),$LI(%r,2),%o)
 
#; ------------------------------------------------------------------------
#; These map to the ordinals in the CacheSSH library
#; ------------------------------------------------------------------------
 
#define SSHCREATESESSION                1
#define SSHCONNECT                      2
#define SSHDISCONNECT                   3
#define SSHAUTHENTICATEWITHUSERNAME     4
#define SSHAUTHENTICATEWITHKEYPAIR      5
#define SSHOPENSFTP                     6
#define SSHCLOSESFTP                    7
#define SSHSFTPFILEINFO                 8
#define SSHSFTPDIR                      9
#define SSHSFTPMKDIR                    10
#define SSHSFTPRMDIR                    11
#define SSHSFTPDELETE                   12
#define SSHSFTPRENAME                   13
#define SSHSFTPSYMLINK                  14
#define SSHSFTPPUT                      15
#define SSHSFTPGET                      16
#define SSHEXECUTE                      17
#define SSHFORWARDPORT                  18
#define SSHTRACEMASK                    19
#define SSHSFTPSETSIZE                  20
#define SSHSFTPSETPERMISSIONS           21
#define SSHSFTPSETOWNERANDGROUP         22
#define SSHSFTPTOUCH                    23
#define SSHVERSIONINFO                  24
#define SSHSETTIMEOUT                   25
#define SSHGETTIMEOUT                   26
 
#;
#; End-of-file
#;