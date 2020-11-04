Include %occActivate

Class %Activate.Interface Extends %RegisteredObject [ Abstract, System = 3 ]
{

Property %IDispatchPtr As %Integer [ Final ];

/// <P>Become an instance of the named class by closing the current object
/// and transferring the external objects' 'handle' to the new class. This method
/// is used when you have an Instance of a generic object but you know what
/// kind of Interface it expresses. For example, some properties or methods
/// of ActiveX objects return a generic IDispatch handle but are documented as
/// returning a more specific Interface derived from IDispatch. You can use this
/// method to take advantage of that documented knowlege.
/// 
/// <P>During the execution of this method a test is made to ensure that the
/// external object really does support the requested interface. If not, an
/// exception will be thrown
Method Become(ClassName As %String) As %RegisteredObject [ Final ]
{
 Set iid=$classmethod(ClassName,"%GetIID")
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXQueryInterface,$listbuild(i%%IDispatchPtr,iid))
 If $List(result,1)'=0 $$$ActXRaise(result)
 Set obj=$classmethod(ClassName,"%New",$List(result,2))
 If obj=$$$NULLOREF ZT "ACTX"
 Quit obj
}

/// This method copies back the appropriate value for parameters passed by reference
/// The knowntype is the type derived from the typelibrary, the actual type is the actual
/// type of the variant returned from the invocation. The binary flag is used when binary
/// streams are required to be returned rather than character streams
Method %CopyBack(ByRef pParam, pKnownType As %Integer, pValue, pActualType = {$$$VTUNKNOWN}, pOutputOnly = 0, pBinary = 0) [ Private ]
{
	#; Check to see if the parameter is passed by reference
	If $ZBOOLEAN(+pKnownType,$$$VTBYREF,1) {
		
		If $Get(pParam)'="" {
		
	 	    #; Check to see if it's an object
			If $IsObject($Get(pParam)) {
			
				#; Check to see if it's a Variant
				If pParam.%ClassName(1)="%Activate.Variant" {
				
					#; Subsitute the Variant value and Type
					Set pParam.Value=pValue
	
				} elseif pParam.%Extends("%Activate.Interface") {
				
					#; It's an ActiveX object, get the IDispatch pointer
					Set pParam.%IDispatchPtr=pValue
					
				} elseif pParam.%Extends("%Stream.Object")&&(pActualType=$$$VTSTREAM) {
					
					#; Retrieve the stream
					Do pParam.Clear()
					
					Set tResult=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXGetStream,$ListBuild(pParam,pValue,pBinary))
					If $List(tResult,1)'=0 $$$ActXRaise(tResult)
					
				} else {
				
					#; Passed an object that wasn't an ActiveX object, raise an exception
					$$$ActXRaise($ListBuild(pParam_" is NOT an ActiveX object ("_pParam.%ClassName(1)_")"))
				}
			} else {
	
				If pActualType=$$$VTUNSUPPORTED
				{
					Set pParam=##class(%Activate.Unsupported).%New(pParam)
				} else {
				
					#; Just a straight copy
					Set pParam=pValue
				}
			}	
		} else {

			#; Param is undefined, create object if output only
			If (pOutputOnly) {
				
				Set tMaskType=$ZBOOLEAN(+pKnownType,$$$VTTYPEMASK,1)
				
				If pActualType=$$$VTUNSUPPORTED
				{
					Set pParam=##class(%Activate.Unsupported).%New()
					
				} elseif pActualType=$$$VTSTREAM {
					
					#; Need to create a new stream
					If pBinary=0 {
						Set pParam=##class(%GlobalCharacterStream).%New()
					} else {
						Set pParam=##class(%GlobalBinaryStream).%New()
					}
					Set tResult=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXGetStream,$ListBuild(pParam,pValue,pBinary))
					If $List(tResult,1)'=0 $$$ActXRaise(tResult)
					
				} elseif ((tMaskType=$$$VTDISPATCH)||(tMaskType=$$$VTUNKNOWN)) {
					
					If pActualType="" {
						
						if (tMaskType=$$$VTDISPATCH) {
							
							#; It's a dispatch
							Set pParam=##class(%Activate.IDispatch).%New(pParam)
						} else {
							
							#; Most probably an Enumerator
							Set pParam=##class(%Activate.IEnumVariant).%New(pParam)
						}
					} else {
						#; Need to create a new Interface based object
						Set pParam=$classmethod(pActualType,"%New",pParam)
					}
				} else {
					#; Just a straight copy
					Set pParam=pValue
				}
			} else {
				
				If pActualType=$$$VTUNSUPPORTED
				{
					Set pParam=##class(%Activate.Unsupported).%New($$$VTUNSUPPORTED)
					
				} else {
					#; Just a straight copy
					Set pParam=pValue
				}
			}
		}
	}
}

/// This method dynamically creates the appropriate parameter for
/// passing to the underlying ActiveX implementation layer where the flags and types
/// are known (proxy generated from typelibrary)
Method %FormatKnownParam(pParam, pFlags, pType) As %List [ Private ]
{
	If $Data(pParam) {
		#; Check to see if it's an object
		If $IsObject($Get(pParam)) {		
	
			#; Make temporary copies of params to avoid by ref problems
			Set tCpyParam=pParam,tCpyFlags=pFlags,tCpyType=pType
			
			#; Check to see if the parameter is to be passed by reference
			Set tByRef=$ZBOOLEAN(+pType,$$$VTBYREF,1)		
			
			#; Check to see if it's a Variant
			If pParam.%ClassName(1)="%Activate.Variant" {
						
				#; Subsitute the Variant value and Type
				Set tCpyParam=pParam.Value,tCpyType=pParam.Type	
	
			} elseif pParam.%ClassName(1)="%Activate.IEnumVariant" {
				
				#; It's an ActiveX enumerator object, get the IDispatch pointer
				Set tCpyParam=pParam.%IDispatchPtr,tCpyType=$$$VTUNKNOWN
				
			} elseif pParam.%Extends("%Activate.Interface") {
				
				#; It's an ActiveX object, get the IDispatch pointer
				Set tCpyParam=pParam.%IDispatchPtr,tCpyType=$$$VTDISPATCH
			} else {
				
				#; Passed an object that wasn't an ActiveX object, raise an exception
				$$$ActXRaise($ListBuild(pParam_" is NOT an ActiveX object ("_pParam.%ClassName(1)_")"))		
			}
	
			#; 'OR' in the ByRef flag if required
			If tByRef Set tCpyType=$ZBOOLEAN(tCpyType,$$$VTBYREF,7)
		
			#; Return the formatted parameter
			Quit $ListBuild(tCpyParam,tCpyFlags,tCpyType)
		} else {
		
			#; Return the original parameter unmodfied
			Quit $ListBuild(pParam,pFlags,pType)
		}
	} else {
		
		#; Parameter is undefined, this indicates to Activate
		#; that the parameter may be optional, allow a list with
		#; an <undef> element for pParam
		
		Quit $ListBuild(pParam,pFlags,pType)
		
	}
}

/// This method dynamically creates the appropriate parameter for
/// passing to the underlying ActiveX implementation layer where the flags and types
/// are not known in advance
Method %FormatVariantParam(pParam) As %List [ Private ]
{
	#; Check to see if it's an object
	If $IsObject($Get(pParam)) {		

		#; Make temporary copies of param
		Set tCpyParam=pParam
		
		#; Check to see if it's a Variant
		If pParam.%Extends("%Activate.Variant") {
			
			#; Subsitute the Variant value and Type
			Set tCpyParam=pParam.Value,tCpyType=pParam.Type
		} elseif pParam.%Extends("%Activate.IEnumVariant") {
			
			#; It's an ActiveX Enumerator
			Set tCpyParam=pParam.%IDispatchPtr,tCpyType=$$$VTUNKNOWN
			
		} elseif pParam.%Extends("%Activate.Interface") {
			
			#; It's an ActiveX object, get the IDispatch pointer
			Set tCpyParam=pParam.%IDispatchPtr,tCpyType=$$$VTDISPATCH
			
		} elseif pParam.%Extends("%Stream.Object") {
			
			#; Wrap the stream in a stream adapter
			Set tCpyParam=pParam,tCpyType=$$$VTSTREAM
			
		} else {
			
			#; Passed an object that wasn't an ActiveX object, raise an exception
			$$$ActXRaise($ListBuild(pParam_" is NOT an ActiveX object ("_pParam.%ClassName(1)_")"))
		}

		#; Return the formatted parameter
		Quit $ListBuild(tCpyParam,tCpyType)
	} else {
	
		#; Return the original parameter
		Quit $ListBuild(pParam,$$$VTILLEGAL)
	}
}

/// Return the current reference count on an ActiveX object
Method %GetRefCount() As %Integer
{
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXGetRefCount,$ListBuild(i%%IDispatchPtr))
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit $List(result,2)
}

/// Set the internal 'handle'. If the handle references a
/// a valid object, release that object first. Throw an exception
/// If there is an ActiveX error during close
Method %IDispatchPtrSet(pIDispatchPtr As %Integer) As %Status [ Final ]
{
 #; Dont update if pointers are the same!
 If i%%IDispatchPtr=pIDispatchPtr Quit $$$OK
 If i%%IDispatchPtr'=0 {
 	Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXReleaseObject,$ListBuild(i%%IDispatchPtr))
 	If $List(result,1)'=0 $$$ActXRaise(result)
 }
 Set i%%IDispatchPtr=pIDispatchPtr
 Quit $$$OK
}

Method %MakeVariantReturnValue(pResult As %List, pBinary As %Boolean = 0)
{
 do {
	
	#; If the return value is an IDispatch then create an Generic object
	Set tType=$List(pResult,2),tValue=$List(pResult,3)
	If ($$$VTDISPATCH=tType) {
	
		#; If the return value is a null pointer then return a null oref
		If (tValue=0) {
			Set tRetVal=$$$NULLOREF Quit
		}
		Set tRetVal=##class(%Activate.IDispatch).%New(tValue)

	} elseif ($$$VTSTREAM=tType) {
		
		#; If the return value is of type stream, then create a stream and retrieve it's value
		If pBinary=0 {
			Set tRetVal=##class(%GlobalCharacterStream).%New()
		} else {
			Set tRetVal=##class(%GlobalBinaryStream).%New()
		}
		Set tResult=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXGetStream,$ListBuild(tRetVal,tValue,pBinary))
		If $List(tResult,1)'=0 $$$ActXRaise(tResult)
		
	} elseif ($$$VTUNSUPPORTED=tType) {
		
		#; If the return type is unsupported, e.g Array of Something, then indicate so
		Set tRetVal=##class(%Activate.Unsupported).%New(tValue)
		
	} elseif ($$$VTUNKNOWN=tType) {
		
		#; If the return value is a null pointer then return a null oref
		If (tValue=0) {
			Set tRetVal=$$$NULLOREF Quit
		}
		
		#; Assume its a IEnumVariant
		Set tRetVal=##class(%Activate.IEnumVariant).%New(tValue)
		
	} else {
		
		#; Just return the value
		Set tRetVal=tValue
	}
 } while(0)	
 Quit tRetVal
}

/// When the object is closed, the external ActiveX object must be closed
/// also. Throw an exception if there is an ActiveX error during close
Method %OnClose() As %Status [ Final, Private ]
{
 If i%%IDispatchPtr'=0 {
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXReleaseObject,$ListBuild(i%%IDispatchPtr))
 If $List(result,1)'=0 $$$ActXRaise(result)
 }
 Quit $$$OK
}

/// When the object is created, the 'handle' to the external ActiveX object
/// must be cached. It is this handle that is used to reference the external object
/// for method invocation and property access.
Method %OnNew(initval As %Integer) As %Status [ Private ]
{
 Set i%%IDispatchPtr=$Get(initval,0)
 Quit $$$OK
}

}
