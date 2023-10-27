<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="QRWebsite.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Events with QR Dashboard</title>

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/style.css">
    <script type="text/javascript">

        //open for attendee
        function openAttendeeLogin() {
            //alert("Opening modal!");
            $('#modLoginAttendee').modal('show');
        }

        //open for admin
        function openAdminLogin() {
            //alert("Opening modal!");
            $('#modLoginAdm').modal('show');
        }

        function closeApp() {
            close();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
            <%-- Webpage Heading --%>

                <div class="QR-header">
                              <img src="../images/QR_Header2.png" alt="QR Logo" /> 
                </div>

        <div class="navbar-collapse collapse">
                    <ul class="nav navbar-nav " style="font-weight: bold;">
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
        </div>
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

        <div class="container">
            <div class="row">
<%--                <div class="col-xs-12">
                    <h1>Login</h1>
                </div>--%>
            </div>
<%--            <div class="row">
                    <div class="LoginOptions1">
                        <asp:Button ID="lbNewAtt1" runat="server" class="btn btn-danger button-xs" Text="Attendee Login" Visible="true" CausesValidation="false" OnClick="lbAttLogIn_Click"/>
                    </div>
            </div>
            <div class="row">
                    <div class="LoginOptions2">
                        <asp:Button ID="lbNewAdm1" runat="server" class="btn btn-info button-xs" Text="Admin Login" Visible="true" CausesValidation="false" OnClick="lbAdmLogIn_Click"/>
                    </div>
            </div>--%>
        </div>

        <!-- Modal to show Login -->
        <div class="modal fade" id="modLoginAdm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">

                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="Label1" runat="server" Text="Admin Login Page" Font-Size="24px" Font-Bold="true" />
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-12">

                                <%-- LOGIN FIELDS --%>
                                <div class="row" style="margin-top: 0px;">
                                    <div class="col-sm-8">


                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-3">
                                                <asp:Label ID="Label8" runat="server" Text="Email:" Font-Size="14px" Font-Bold="true" />
                                            </div>
                                            <div class="col-sm-7">
                                                <asp:Label ID="lblEmail" runat="server" Visible="true" Font-Size="14px" />
                                            <asp:TextBox ID="txtEmail" runat="server" MaxLength="20" CssClass="form-control input-xs" 
                                                AutoCompleteType="Disabled" placeholder="Email" />
                                            </div>
                                            <div class="col-sm-1">
                                            </div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-3">
                                                <asp:Label ID="Label9" runat="server" Text="Password:" Font-Size="14px" Font-Bold="true" />
                                            </div>
                                            <div class="col-sm-7">
                                                <asp:Label ID="lblPassword" runat="server" Visible="true" Font-Size="14px" />
                                                <input id="txtPassword" type="password" runat="server" MaxLength="20" ToolTip="Password" placeholder="   Password" >
                                            </div>
                                            <div class="col-sm-1">
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>
                        </div>

                        <%-- Message label on modal page --%>
                        <div class="row" style="margin-top: 20px; margin-bottom: 10px;">
                            <div class="col-sm-1"></div>
                            <div class="col-sm-10">
                                <asp:Label ID="Label4" runat="server" ForeColor="Red" Font-Size="12px" Text="" />
                            </div>
                            <div class="col-sm-1"></div>
                        </div>
                    </div>

                    <%-- Submit Button --%>
                    <div class="modal-footer">
                        <asp:Button ID="btnSubmitAdmin" runat="server" class="btn btn-danger button-xs"  
                            Text="Submit"                            
                            OnClick="btnSubmitAdmin_Click" 
                            data-dismiss="modal" Visible="true" CausesValidation="true"
                            UseSubmitBehavior="false" />
<%--                        <asp:Button ID="Button3" runat="server" class="btn btn-info button-xs" data-dismiss="modal" Text="Exit App"
                            CausesValidation="false"
                            OnClientClick="closeApp()"
                            UseSubmitBehavior="false" />--%>
                    </div>

                </div>
            </div>
        </div>
    </form>
</body>
</html>

