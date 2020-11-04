ROUTINE %SetBuilder [Type=INC]
#define SetBuilderMetaGLVN ^ISC.SB.Set
#define SetBuilderListingGLVN ^ISC.SB.Listing
#define SetBuilderSnapshotGLVN ^ISC.SB.Snapshot
#define SetBuilderSnapshotRepoGLVN ^ISC.SB.SnapshotRepo

#define SetBuilderTemp ^||%SB.Temp


#define NeedsQuotes(%type) $case(%type,"%Integer":0,"%Double":0,"%Numeric":0,"%Float":0,:1)

#define SBChunkPos(%id,%chunk,%pos) set %chunk=(%id\64000)+1, %pos=(%id#64000)+1