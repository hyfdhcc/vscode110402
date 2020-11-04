/// <class>Hashable</class> is an abstract class providing the means to attach a SHA1 hash value
/// to its subclass instances.
Class Inventory.Hashable [ Abstract ]
{

/// An index on the <property>SHA1Hash</property> value of this object
Index SHA1HashIndex On SHA1Hash As Exact;

/// The SHA1Hash of the object, base 64 encoded.
Property SHA1Hash As %String(COLLATION = "EXACT");

/// Generate a base 64 encoded SHA1 hash of <var>string</var> and store it as the <property>SHA1Hash</property> property
/// of this object.
Method GenerateSHA1Hash(string As %String)
{
}

/// Generate a base 64 encoded SHA1 hash of the contents of <var>stream</var>  and store it as the <property>SHA1Hash</property> property
/// of this object.
Method GenerateSHA1HashFromStream(stream As %Stream.Object)
{
}

}
