## Overview

The SampleHelper is a very simple example of a custom bundle helper used by the `sample.json` bundle callback to generate a greeting based upon the `name` request parameter.

Bundle callbacks are JSP files that extend server-side functionality, effectively creating a custom API for the bundle to call.  The request for a bundle callback looks something like this:

```
http(s)://SERVER:PORT/SPACE?callback=sample.json&name=John
```

## Files

[bundle/SampleHelper.md](SampleHelper.md)  
README file containing information on configuring and using the sample helper.

[bundle/SampleHelper.jspf](SampleHelper.jspf)  
Helper file containing definitions for the SampleHelper.

[callbacks/sample.json.jspf](../callbacks/sample.json.jspf)  
Example callback file that leverages the SampleHelper.

## Configuration

* Copy the files listed above into your bundle
* Initialize the SampleHelper in your bundle/initialization.jspf file
* Set optional attribute configurations

### Initialize the SampleHelper

**bundle/initialization.jspf**
```jsp
<%@include file="SampleHelper.jspf"%>
<%
    request.setAttribute("SampleHelper", new SampleHelper(request));
%>
```

### Optional Attribute Configurations
The SampleHelper will generate a greeting based upon the "Sample Helper Greeting" space attribute (and defaulting to "Hello").  To customize the greeting, create a space attribute definition for "Sample Helper Greeting" and set the space attribute value to the desired salutation.

## Example Usage

**Server Side (JSP) Retrieve**
```jsp
// Build up a simple Java result object (made up of Maps, Lists, Strings, Dates, and Numbers)
Map<String, Object> result = new LinkedHashMap<>();
result.put("message", sampleHelper.greet(request.getParameter("name")));
// Render the JSON string for the result object
response.setContentType("application/json");
response.setStatus(200);
out.print(JsonHelper.toString(result));
```

---

#### BridgedResourceHelper Summary

`SampleHelper(HttpServletRequest request)`

`String greet(String name)`  
