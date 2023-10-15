<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QRWebsite.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>QR Party Dashboard</title>

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <form id="form1" runat="server">
            <%-- Webpage Heading --%>
            <div class="row">
                <div class="col-xs-12">
                    <h1 class="QR-h1">Events with QR Dashboard</h1>
                </div>
            </div>
<%--        <div class="navbar-collapse collapse">--%>
                    <ul class="nav navbar-nav" style="font-weight: bold;">
                        <li>
                            <asp:HyperLink ID="hlHome" NavigateUrl="~/Default.aspx" runat="server">Home</asp:HyperLink><br />
                        </li>
                        <li>
                           <asp:HyperLink ID="hlEmployees" NavigateUrl="~/Attendees.aspx" runat="server">Attendees</asp:HyperLink><br />
                        </li>
                        <li>
                             <asp:HyperLink ID="hlCompanies" NavigateUrl="~/Events.aspx" runat="server">Event Information</asp:HyperLink><br />                            
                        </li>
                    </ul>
<%--        </div>--%>
<%--                <div class="maintenance-icon1">
                    <a runat="server" href="~/#">
                        <i ID="AdminImage" class="bi bi-file-earmark-lock2-fill"></i>
                    </a>
                </div>--%>

            <%-- Menu / Message --%>
            <div>

                <div class="col-sm-4">
                </div>
                <div class="col-sm-4">
                    <asp:Label ID="lblMessage" runat="server" Text="" />
                </div>
                <div class="col-sm-4" style="text-align: right;">
                </div>
            </div>



    </form>
</body>
</html>

