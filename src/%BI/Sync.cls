Include %occInclude

IncludeGenerator %occInclude

Class %BI.Sync [ Abstract, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Method SpeedOnAfterSave(insert) As %Status [ Final, ProcedureBlock = 0 ]
{
	n class,Id
	x "s class=..%ClassName(1),Id=..%Id()"
	d SyncUpd^%bi.SMr.Miner7(class,Id,..IsOLAP())
 	q $$$OK
}

Method %OnAfterSave(insert) As %Status [ Final, ProcedureBlock = 0 ]
{
	q ..SpeedOnAfterSave(insert)
}

ClassMethod %OnDelete(oid As %ObjectIdentity) As %Status [ Private, ProcedureBlock = 0, ServerOnly = 1 ]
{
	q ..SpeedOnDelete(oid)
}

ClassMethod SpeedOnDelete(oid) As %Status [ Final, ProcedureBlock = 0 ]
{
	q:%class="%BI.Sync" 1
	n class,Id
	x "s class=..%ClassName(1),Id=..%Id()"
 	d SyncDel^%bi.SMr.Miner7(class,Id,..IsOLAP())
 	q $$$OK
}

ClassMethod IsOLAP() [ CodeMode = generator, Final ]
{
	$$$GENERATE("	q "_$D(^BI.OLAPClass(%class)))
	q $$$OK
}

Trigger HyperDelete [ Event = DELETE, Order = 1, Time = AFTER ]
{
	n class,Id
	s class=$P($ZN,".",1,$L($ZN,".")-1) i class="" q
	s Id=$G(%d(1)) i Id="" q
	d SyncDel^%bi.SMr.Miner7(class,Id,..IsOLAP())
	q
}

Trigger HyperInsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
	n class,Id,o
	s class=$P($ZN,".",1,$L($ZN,".")-1) i class="" q
	s Id=$G(%d(1)) i Id="" q
	s o=$zobjclassmethod(class,"%OpenId",Id) i o="" q
	d $zobjmethod(o,"%OnAfterSave",1)
	d $zobjmethod(o,"%Close")
	q
}

Trigger HyperUpdate [ Event = UPDATE, Order = 1, Time = AFTER ]
{
	n class,Id,o
	s class=$P($ZN,".",1,$L($ZN,".")-1) i class="" q
	s Id=$G(%d(1)) i Id="" q
	s o=$zobjclassmethod(class,"%OpenId",Id) i o="" q
	d $zobjmethod(o,"%OnAfterSave",0)
	d $zobjmethod(o,"%Close")
	q
}

}
