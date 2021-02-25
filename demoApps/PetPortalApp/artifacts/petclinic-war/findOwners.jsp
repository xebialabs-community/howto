<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
  <link rel="stylesheet" href="/petclinic/styles/petclinic.css" type="text/css"/>
  <title>PetClinic :: a Spring Framework demonstration</title>	
</head>

<body>

  <div id="main">


<h2>Find Owners:</h2>

<%
	if(request.getMethod().equals("GET")) {
%>
<form id="owner" action="/petclinic/findOwners.jsp" method="post">
  <table>
    <tr>
      <th>
        Last Name: 
        <br/> 
        <input id="lastName" name="lastName" type="text" value="" size="30" maxlength="80"/>
      </th>
    </tr>
    <tr>
      <td><p class="submit"><input type="submit" value="Find Owners"/></p></td>
    </tr>
  </table>
</form>
<%
	} else {
%>
<table>
  <tr>
  <thead>
    <th>Name</th>
    <th>Address</th>
    <th>City</th>
    <th>Pets</th>
  </thead>
  </tr>
<%
	if("bush".equalsIgnoreCase(request.getParameter("lastName"))) {
%>
    <tr>
      <td>George W. Bush</td>
      <td>1600 Pennsylvania Avenue NW</td>
      <td>Washington, DC</td>
      <td>Barney</td>
    </tr>
<%
	}
%>
</table>
<%
	}
%>

<br/>
<table class="footer">
    <tr>
      <td><a href="/petclinic/index.html">Home</a></td>
      <td align="right"><img src="/petclinic/images/springsource-logo.png"></td>
    </tr>
  </table>

  </div>
</body>

</html>

