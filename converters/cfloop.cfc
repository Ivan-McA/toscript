component extends="BaseConverter" {
	
	public string function toScript(tag) {
		var s = "";
		var attr = tag.getAttributes();
		if (!tag.hasAttributes()) {
			throw(message="cfloop must have attributes");
		}
		if (structKeyExists(attr, "condition")) {
			s = "while ( " & trim(convertOperators(tag.getAttributeContent())) & " ) {";	
		} else if (structKeyExists(attr, "array")) {
			s = "for ( " & attr.index & " in " & unPound(attr.array) & " ) {";
		} else if (structKeyExists(attr, "list") && structKeyExists(attr, "item")) {
			s = "for ( " & attr.item & " in ";
			if (structKeyExists(attr, "delimiters")) {
				s = s & "listToArray( " & unPound(attr.list) & ", " & unPound(attr.delimiters) & " )";
			} else {
				s = s & unPound(attr.list);
			}
			s = s & " ) {"; 
		} else if (structKeyExists(attr, "from") && structKeyExists(attr, "to") && structKeyExists(attr, "index")) {
			s = "for ( " & attr.index & "=" & unPound(attr.from) & " ; " & attr.index & "<=" & unPound(attr.to) & " ; " & attr.index;
			if (structKeyExists(attr, "step") && attr.step != 1) {
				s = s & "+" & attr.step;
			} else {
				s = s & "++";
			}
			s = s & " ) {";
		} else {
			throw(message="Unimplemented cfloop condition");
		}
		
		return s;
	}

	public boolean function indentBody() {
		return true;
	}

	public string function toScriptEndTag(tag) {
		return "}";
	}
	
}