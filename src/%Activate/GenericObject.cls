/// This class provides functionality to create an ActiveX object, invoke its methods
/// and Get/Set its properties by name.
Class %Activate.GenericObject Extends %Activate.IDispatch [ System = 3 ]
{

/// This method is used to create a generic object given only its progid. If the object
/// cannot be found an exception is thrown. The return value should be tested against
/// $$$NULLOREF  in the usual manner to ensure that the object has been successfully
/// created
ClassMethod CreateObject(Progid As %Library.String) As %RegisteredObject [ Final ]
{
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXCreateObjectFromProgid,$ListBuild(Progid))
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit ##Class(%Activate.GenericObject).%New($List(result,2))
}

/// This method is used to create a generic object from a moniker. If the object
/// cannot be found an exception is thrown. The return value should be tested against
/// $$$NULLOREF  in the usual manner to ensure that the object has been successfully
/// created.
ClassMethod GetObject(Moniker As %Library.String) As %RegisteredObject [ Final ]
{
 Set result=$ZF($$$ORDINAL,$$$HANDLE,$$$ActXGetObject,$ListBuild(Moniker))
 If $List(result,1)'=0 $$$ActXRaise(result)
 Quit ##Class(%Activate.GenericObject).%New($List(result,2))
}

}
