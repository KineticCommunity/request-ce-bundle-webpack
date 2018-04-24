<%@page pageEncoding="UTF-8" contentType="application/json" trimDirectiveWhitespaces="true"%>
<%@include file="../bundle/initialization.jspf" %>
<%
    // Obtain a reference to the sample helper
    SampleHelper sampleHelper = (SampleHelper)request.getAttribute("SampleHelper");
    
    // Determine whether the request is valid and authorized
    boolean isInvalid = !request.getParameterMap().containsKey("name");
    boolean isUnathorized = "simulate-unauthorized".equals(request.getParameter("name"));
    
    // If the request is invalid
    if (isInvalid) {
        // Build up a simple Java result object (made up of Maps, Lists, Strings, Dates, and Numbers)
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("message", "You must pass a \"name\" parameter with the request.");
        // Render the JSON string for the result object
        response.setContentType("application/json");
        response.setStatus(400);
        out.print(JsonHelper.toString(result));
    }
    // If the request is unauthorized
    else if (isUnathorized) {
        // Build up a simple Java result object (made up of Maps, Lists, Strings, Dates, and Numbers)
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("message", "You are not authorized to access this resource.");
        // Render the JSON string for the result object
        response.setContentType("application/json");
        response.setStatus(403);
        out.print(JsonHelper.toString(result));
    }
    // If the request is valid and authorized
    else {
        // Build up a simple Java result object (made up of Maps, Lists, Strings, Dates, and Numbers)
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("message", sampleHelper.greet(request.getParameter("name")));
        // Render the JSON string for the result object
        response.setContentType("application/json");
        response.setStatus(200);
        out.print(JsonHelper.toString(result));
    }
%>
