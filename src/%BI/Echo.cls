Class %BI.Echo Extends %Persistent [ ClassType = persistent, LegacyInstanceContext, Not ProcedureBlock, System = 4 ]
{

Index EchoRefID On EchoRefID As Exact;

Property EchoRefID As %String;

Property CVTName As %String(TRUNCATE = 1);

Property Rhythm As %String(TRUNCATE = 1);

Property BP As %String(TRUNCATE = 1);

Property Height As %String(TRUNCATE = 1);

Property Weight As %String(TRUNCATE = 1);

Property BSA As %String(TRUNCATE = 1);

Property LVDet As %String(TRUNCATE = 1);

Property LVDet2 As %String(TRUNCATE = 1);

Property RVDet As %String(TRUNCATE = 1);

Property GraphCol As %String(TRUNCATE = 1);

Property GraphCol1 As %String(TRUNCATE = 1);

Property GraphCol2 As %String(TRUNCATE = 1);

Property GraphCol3 As %String(TRUNCATE = 1);

Property GraphCol4 As %String(TRUNCATE = 1);

Property GraphCol5 As %String(TRUNCATE = 1);

Property Pericardium As %String(TRUNCATE = 1);

Property ArtialSept As %String(TRUNCATE = 1);

Property VentricularSept As %String(TRUNCATE = 1);

Property AORoot As %String(TRUNCATE = 1);

Property AOPA As %String(TRUNCATE = 1);

Property MitralValve As %String(TRUNCATE = 1);

Property AorticValve As %String(TRUNCATE = 1);

Property Tricuspid As %String(TRUNCATE = 1);

Property PulmonaryValve As %String(TRUNCATE = 1);

Property DiastolicMVDet As %String(TRUNCATE = 1);

Property LRAtrium As %String(TRUNCATE = 1);

Property ChamberAreaDet As %String(TRUNCATE = 1);

Property EchoDiag As %String(MAXLEN = 25000, TRUNCATE = 1);

Property NotesComt As %String(MAXLEN = 25000, TRUNCATE = 1);

Property TricuspidValveInflowDet As %String(TRUNCATE = 1);

Property SuperiorVenaC As %String(TRUNCATE = 1);

Property ProstheticValMitralDet As %String(TRUNCATE = 1);

Property ProstheticValAorticDet As %String(TRUNCATE = 1);

Property ProstheticValMitralDet2 As %String(TRUNCATE = 1);

Property ProstheticValAorticDet2 As %String(TRUNCATE = 1);

Property LftVenComt As %String(MAXLEN = 25000, TRUNCATE = 1);

Property LVMassIdxComt As %String(MAXLEN = 25000, TRUNCATE = 1);

Property LVMassComt As %String(MAXLEN = 25000, TRUNCATE = 1);

Property RigVenComt As %String(MAXLEN = 25000, TRUNCATE = 1);

Property RIMPComt As %String(MAXLEN = 25000, TRUNCATE = 1);

Property DpdtComt As %String(MAXLEN = 25000, TRUNCATE = 1);

Property PericardiumB As %String(TRUNCATE = 1);

Property ArtialSeptB As %String(TRUNCATE = 1);

Property VentricularSeptB As %String(TRUNCATE = 1);

Property AORootB As %String(TRUNCATE = 1);

Property AOPAB As %String(TRUNCATE = 1);

Property MitralValveB As %String(TRUNCATE = 1);

Property AorticValveB As %String(TRUNCATE = 1);

Property TricuspidB As %String(TRUNCATE = 1);

Property PulmonaryValveB As %String(TRUNCATE = 1);

Property Tape As %String(TRUNCATE = 1);

Property ComtPericardium As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ComtArtial As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ComtVentricul As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ComtAOroot As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ComtAOPA As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ComtMitral As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ComtAortic As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ComtTricuspid As %String(MAXLEN = 25000, TRUNCATE = 1);

Property ComtPulmonary As %String(MAXLEN = 25000, TRUNCATE = 1);

Property DiastolicMVDet2 As %String(TRUNCATE = 1);

Property DiastolicMVDet3 As %String(TRUNCATE = 1);

Property DiastolicMVDet4 As %String(TRUNCATE = 1);

Property DiastolicMVDet5 As %String(TRUNCATE = 1);

Property Peri As %String(TRUNCATE = 1);

Property XtrArtialSept As %String(TRUNCATE = 1);

Property XtrVentricularSept As %String(TRUNCATE = 1);

Property XtrAORoot As %String(TRUNCATE = 1);

Property XtrAOPA As %String(TRUNCATE = 1);

Property XtrMitralValve As %String(TRUNCATE = 1);

Property XtrAorticValve As %String(TRUNCATE = 1);

Property XtrTricuspid As %String(TRUNCATE = 1);

Property XtrPulmonaryValve As %String(TRUNCATE = 1);

Property MitC As %String(TRUNCATE = 1);

Property MitT As %String(TRUNCATE = 1);

Property MitS As %String(TRUNCATE = 1);

Property MitM As %String(TRUNCATE = 1);

Property MitTW As %String(TRUNCATE = 1);

Property EchoDate As %String(TRUNCATE = 1);

Property EchoCase As %String(TRUNCATE = 1);

// 1 means closed 0 means opened

Property RoomNo As %String(TRUNCATE = 1);

Property IVCVal As %String(TRUNCATE = 1);

Property Indi As %String(TRUNCATE = 1);

Property DoctorName As %String(TRUNCATE = 1);

Property TypeMachine As %String(TRUNCATE = 1);

Property ESV3 As %String(TRUNCATE = 1);

Property EDV3 As %String(TRUNCATE = 1);

Property EF3 As %String(TRUNCATE = 1);

Property LVSysFx As %String(TRUNCATE = 1);

Property RVHYN As %String(TRUNCATE = 1);

Property HVFSV As %String(TRUNCATE = 1);

Property HVFDV As %String(TRUNCATE = 1);

Property HVFARV As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AOPA">
<Attribute>AOPA</Attribute>
<Subscript>"AOP"</Subscript>
<Value name="1">
<Value>AOPA</Value>
</Value>
<Value name="2">
<Value>AOPAB</Value>
</Value>
<Value name="3">
<Value>XtrAOPA</Value>
</Value>
</Data>
<Data name="AORoot">
<Attribute>AORoot</Attribute>
<Subscript>"AR"</Subscript>
<Value name="1">
<Value>AORoot</Value>
</Value>
<Value name="2">
<Value>AORootB</Value>
</Value>
<Value name="3">
<Value>XtrAORoot</Value>
</Value>
</Data>
<Data name="AorticValve">
<Attribute>AorticValve</Attribute>
<Subscript>"ARV"</Subscript>
<Value name="1">
<Value>AorticValve</Value>
</Value>
<Value name="2">
<Value>AorticValveB</Value>
</Value>
<Value name="3">
<Value>XtrAorticValve</Value>
</Value>
</Data>
<Data name="ArtialSept">
<Attribute>ArtialSept</Attribute>
<Subscript>"AS"</Subscript>
<Value name="1">
<Value>ArtialSept</Value>
</Value>
<Value name="2">
<Value>ArtialSeptB</Value>
</Value>
<Value name="3">
<Value>XtrArtialSept</Value>
</Value>
</Data>
<Data name="ChamberAreaDet">
<Attribute>ChamberAreaDet</Attribute>
<Structure>node</Structure>
<Subscript>"CH"</Subscript>
</Data>
<Data name="ClassName">
<Attribute>%%CLASSNAME</Attribute>
<Structure>node</Structure>
<Subscript>"X"</Subscript>
</Data>
<Data name="ComtAOPA">
<Attribute>ComtAOPA</Attribute>
<Structure>node</Structure>
<Subscript>"CMAOP"</Subscript>
</Data>
<Data name="ComtAOroot">
<Attribute>ComtAOroot</Attribute>
<Structure>node</Structure>
<Subscript>"CMAR"</Subscript>
</Data>
<Data name="ComtAortic">
<Attribute>ComtAortic</Attribute>
<Structure>node</Structure>
<Subscript>"CMAOR"</Subscript>
</Data>
<Data name="ComtArtial">
<Attribute>ComtArtial</Attribute>
<Structure>node</Structure>
<Subscript>"CMART"</Subscript>
</Data>
<Data name="ComtMitral">
<Attribute>ComtMitral</Attribute>
<Structure>node</Structure>
<Subscript>"CMMIT"</Subscript>
</Data>
<Data name="ComtPericardium">
<Attribute>ComtPericardium</Attribute>
<Structure>node</Structure>
<Subscript>"CMPER"</Subscript>
</Data>
<Data name="ComtPulmonary">
<Attribute>ComtPulmonary</Attribute>
<Structure>node</Structure>
<Subscript>"CMPUL"</Subscript>
</Data>
<Data name="ComtTricuspid">
<Attribute>ComtTricuspid</Attribute>
<Structure>node</Structure>
<Subscript>"CMTRI"</Subscript>
</Data>
<Data name="ComtVentricul">
<Attribute>ComtVentricul</Attribute>
<Structure>node</Structure>
<Subscript>"CMVEN"</Subscript>
</Data>
<Data name="DiastolicMVDet">
<Attribute>DiastolicMVDet</Attribute>
<Structure>node</Structure>
<Subscript>"DI"</Subscript>
</Data>
<Data name="DiastolicMVDet2">
<Attribute>DiastolicMVDet2</Attribute>
<Structure>node</Structure>
<Subscript>"DI2"</Subscript>
</Data>
<Data name="DiastolicMVDet3">
<Attribute>DiastolicMVDet3</Attribute>
<Structure>node</Structure>
<Subscript>"DI3"</Subscript>
</Data>
<Data name="DiastolicMVDet4">
<Attribute>DiastolicMVDet4</Attribute>
<Structure>node</Structure>
<Subscript>"DI4"</Subscript>
</Data>
<Data name="DiastolicMVDet5">
<Attribute>DiastolicMVDet5</Attribute>
<Structure>node</Structure>
<Subscript>"DI5"</Subscript>
</Data>
<Data name="DpdtComt">
<Attribute>DpdtComt</Attribute>
<Structure>node</Structure>
<Subscript>"DPDTC"</Subscript>
</Data>
<Data name="EchoDefaultData">
<Value name="1">
<Value>BP</Value>
</Value>
<Value name="2">
<Value>ArtialSeptComt</Value>
</Value>
<Value name="3">
<Value>CVTName</Value>
</Value>
<Value name="4">
<Value>EchoRefID</Value>
</Value>
<Value name="5">
<Value>Height</Value>
</Value>
<Value name="6">
<Value>Rhythm</Value>
</Value>
<Value name="7">
<Value>Weight</Value>
</Value>
<Value name="8">
<Value>BSA</Value>
</Value>
<Value name="9">
<Value>PericardiumComt</Value>
</Value>
<Value name="10">
<Value>TricuspidComt</Value>
</Value>
<Value name="11">
<Value>AOPAB</Value>
</Value>
<Value name="12">
<Value>AORootB</Value>
</Value>
<Value name="13">
<Value>AorticValveB</Value>
</Value>
<Value name="14">
<Value>ArtialSeptB</Value>
</Value>
<Value name="15">
<Value>MitralValveB</Value>
</Value>
<Value name="16">
<Value>PericardiumB</Value>
</Value>
<Value name="17">
<Value>PulmonaryValveB</Value>
</Value>
<Value name="18">
<Value>TricuspidB</Value>
</Value>
<Value name="19">
<Value>VentricularSeptB</Value>
</Value>
<Value name="20">
<Value>Tape</Value>
</Value>
<Value name="21">
<Value>MitC</Value>
</Value>
<Value name="22">
<Value>MitM</Value>
</Value>
<Value name="23">
<Value>MitS</Value>
</Value>
<Value name="24">
<Value>MitT</Value>
</Value>
<Value name="25">
<Value>MitTW</Value>
</Value>
<Value name="26">
<Value>EchoDate</Value>
</Value>
<Value name="27">
<Value>EchoCase</Value>
</Value>
<Value name="28">
<Value>RoomNo</Value>
</Value>
<Value name="29">
<Value>IVCVal</Value>
</Value>
<Value name="30">
<Value>DoctorName</Value>
</Value>
<Value name="31">
<Value>EDV3</Value>
</Value>
<Value name="32">
<Value>EF3</Value>
</Value>
<Value name="33">
<Value>ESV3</Value>
</Value>
<Value name="34">
<Value>Indicator</Value>
</Value>
<Value name="35">
<Value>TypeMachine</Value>
</Value>
<Value name="36">
<Value>Indi</Value>
</Value>
<Value name="37">
<Value>LVSysFx</Value>
</Value>
<Value name="38">
<Value>RVHYN</Value>
</Value>
<Value name="39">
<Value>HVFARV</Value>
</Value>
<Value name="40">
<Value>HVFDV</Value>
</Value>
<Value name="41">
<Value>HVFSV</Value>
</Value>
</Data>
<Data name="EchoDiag">
<Attribute>EchoDiag</Attribute>
<Structure>node</Structure>
<Subscript>"E"</Subscript>
</Data>
<Data name="EchoTrack">
<Subscript>"ETRK"</Subscript>
<Value name="1">
<Value>EchoDate</Value>
</Value>
<Value name="2">
<Value>EchoCase</Value>
</Value>
</Data>
<Data name="GraphCol">
<Attribute>GraphCol</Attribute>
<Structure>node</Structure>
<Subscript>"GC"</Subscript>
</Data>
<Data name="GraphCol1">
<Attribute>GraphCol1</Attribute>
<Structure>node</Structure>
<Subscript>"GC1"</Subscript>
</Data>
<Data name="GraphCol2">
<Attribute>GraphCol2</Attribute>
<Structure>node</Structure>
<Subscript>"GC2"</Subscript>
</Data>
<Data name="GraphCol3">
<Attribute>GraphCol3</Attribute>
<Structure>node</Structure>
<Subscript>"GC3"</Subscript>
</Data>
<Data name="GraphCol4">
<Attribute>GraphCol4</Attribute>
<Structure>node</Structure>
<Subscript>"GC4"</Subscript>
</Data>
<Data name="GraphCol5">
<Attribute>GraphCol5</Attribute>
<Structure>node</Structure>
<Subscript>"GC5"</Subscript>
</Data>
<Data name="HVF">
<Subscript>"HVF"</Subscript>
<Value name="1">
<Value>HVFARV</Value>
</Value>
<Value name="2">
<Value>HVFDV</Value>
</Value>
<Value name="3">
<Value>HVFSV</Value>
</Value>
</Data>
<Data name="IVCValue">
<Attribute>IVCVal</Attribute>
<Structure>node</Structure>
<Subscript>"IVCVAL"</Subscript>
</Data>
<Data name="LRAtrium">
<Attribute>LRAtrium</Attribute>
<Structure>node</Structure>
<Subscript>"LRA"</Subscript>
</Data>
<Data name="LVDet">
<Attribute>LVDet</Attribute>
<Structure>node</Structure>
<Subscript>"LVD"</Subscript>
</Data>
<Data name="LVDet2">
<Attribute>LVDet2</Attribute>
<Structure>node</Structure>
<Subscript>"LVD2"</Subscript>
</Data>
<Data name="LVMassComt">
<Attribute>LVMassComt</Attribute>
<Structure>node</Structure>
<Subscript>"LVMC"</Subscript>
</Data>
<Data name="LVMassIdxComt">
<Attribute>LVMassIdxComt</Attribute>
<Structure>node</Structure>
<Subscript>"LVMIDXC"</Subscript>
</Data>
<Data name="LftVenComt">
<Attribute>LftVenComt</Attribute>
<Structure>node</Structure>
<Subscript>"LFVCMT"</Subscript>
</Data>
<Data name="MitralValve">
<Attribute>MitralValve</Attribute>
<Subscript>"MV"</Subscript>
<Value name="1">
<Value>MitralValve</Value>
</Value>
<Value name="2">
<Value>MitralValveB</Value>
</Value>
<Value name="3">
<Value>XtrMitralValve</Value>
</Value>
</Data>
<Data name="NotesComt">
<Attribute>NotesComt</Attribute>
<Structure>node</Structure>
<Subscript>"NTC"</Subscript>
</Data>
<Data name="Pericardium">
<Attribute>Pericardium</Attribute>
<Subscript>"PR"</Subscript>
<Value name="1">
<Value>Pericardium</Value>
</Value>
<Value name="2">
<Value>PericardiumB</Value>
</Value>
<Value name="3">
<Value>Peri</Value>
</Value>
</Data>
<Data name="ProstheticValAorticDet">
<Attribute>ProstheticValAorticDet</Attribute>
<Structure>node</Structure>
<Subscript>"PVAD"</Subscript>
</Data>
<Data name="ProstheticValAorticDet2">
<Attribute>ProstheticValAorticDet2</Attribute>
<Structure>node</Structure>
<Subscript>"PVAD2"</Subscript>
</Data>
<Data name="ProstheticValMitralDet">
<Attribute>ProstheticValMitralDet</Attribute>
<Structure>node</Structure>
<Subscript>"PVMD"</Subscript>
</Data>
<Data name="ProstheticValMitralDet2">
<Attribute>ProstheticValMitralDet2</Attribute>
<Structure>node</Structure>
<Subscript>"PVMD2"</Subscript>
</Data>
<Data name="PulmonaryValve">
<Attribute>PulmonaryValve</Attribute>
<Subscript>"PV"</Subscript>
<Value name="1">
<Value>PulmonaryValve</Value>
</Value>
<Value name="2">
<Value>PulmonaryValveB</Value>
</Value>
<Value name="3">
<Value>XtrPulmonaryValve</Value>
</Value>
</Data>
<Data name="RIMPComt">
<Attribute>RIMPComt</Attribute>
<Structure>node</Structure>
<Subscript>"RIMPC"</Subscript>
</Data>
<Data name="RVDet">
<Attribute>RVDet</Attribute>
<Structure>node</Structure>
<Subscript>"RVD"</Subscript>
</Data>
<Data name="RigVenComt">
<Attribute>RigVenComt</Attribute>
<Structure>node</Structure>
<Subscript>"RVC"</Subscript>
</Data>
<Data name="RoomNo">
<Attribute>RoomNo</Attribute>
<Structure>node</Structure>
<Subscript>"RMNo"</Subscript>
</Data>
<Data name="SuperiorVenaC">
<Attribute>SuperiorVenaC</Attribute>
<Structure>node</Structure>
<Subscript>"SVC"</Subscript>
</Data>
<Data name="Tricuspid">
<Attribute>Tricuspid</Attribute>
<Subscript>"TRI"</Subscript>
<Value name="1">
<Value>Tricuspid</Value>
</Value>
<Value name="2">
<Value>TricuspidB</Value>
</Value>
<Value name="3">
<Value>XtrTricuspid</Value>
</Value>
</Data>
<Data name="TricuspidValveInflowDet">
<Attribute>TricuspidValveInflowDet</Attribute>
<Structure>node</Structure>
<Subscript>"TVI"</Subscript>
</Data>
<Data name="VentricularSept">
<Attribute>VentricularSept</Attribute>
<Subscript>"VS"</Subscript>
<Value name="1">
<Value>VentricularSept</Value>
</Value>
<Value name="2">
<Value>VentricularSeptB</Value>
</Value>
<Value name="3">
<Value>XtrVentricularSept</Value>
</Value>
</Data>
<Data name="Wilskin">
<Subscript>"Wilskin"</Subscript>
<Value name="1">
<Value>MitC</Value>
</Value>
<Value name="2">
<Value>MitM</Value>
</Value>
<Value name="3">
<Value>MitS</Value>
</Value>
<Value name="4">
<Value>MitT</Value>
</Value>
<Value name="5">
<Value>MitTW</Value>
</Value>
</Data>
<Data name="XtraInfo">
<Subscript>"Xtra"</Subscript>
<Value name="1">
<Value>Indicator</Value>
</Value>
<Value name="2">
<Value>DoctorName</Value>
</Value>
<Value name="3">
<Value>TypeMachine</Value>
</Value>
<Value name="4">
<Value>ESV3</Value>
</Value>
<Value name="5">
<Value>EDV3</Value>
</Value>
<Value name="6">
<Value>EF3</Value>
</Value>
<Value name="7">
<Value>LVSysFx</Value>
</Value>
<Value name="8">
<Value>RVHYN</Value>
</Value>
</Data>
<DataLocation>^BI.EchoD</DataLocation>
<DefaultData>EchoDefaultData</DefaultData>
<IdLocation>^BI.EchoD</IdLocation>
<IndexLocation>^BI.EchoI</IndexLocation>
<StreamLocation>^BI.EchoS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}
