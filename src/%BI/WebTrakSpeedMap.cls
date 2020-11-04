Class %BI.WebTrakSpeedMap [ Abstract, Not ProcedureBlock, System = 4 ]
{

ClassMethod LoadSMUsers()
{
	d LoadSMUsers^%bi.SWr.WebSpeedTrakMap
}

ClassMethod LoadTrakUsers()
{
	d LoadTrakUsers^%bi.SWr.WebSpeedTrakMap
}

ClassMethod LoadTrakGroup()
{
	d LoadTrakGroup^%bi.SWr.WebSpeedTrakMap
}

ClassMethod LoadRecords()
{
	d LoadRecords^%bi.SWr.WebSpeedTrakMap
}

ClassMethod Add(type, trak, speed, seq)
{
	d Add^%bi.SWr.WebSpeedTrakMap(type,trak,speed,seq)
}

ClassMethod Update(type, trak, speed, seq, id)
{
	d Update^%bi.SWr.WebSpeedTrakMap(type,trak,speed,seq,id)
}

ClassMethod Delete(id)
{
	d Delete^%bi.SWr.WebSpeedTrakMap(id)
}

ClassMethod UpdateDefault(smUsr)
{
	 d UpdateDefault^%bi.SWr.WebSpeedTrakMap(smUsr)
}

}
