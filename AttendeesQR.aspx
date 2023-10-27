<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AttendeesQR.aspx.cs" Inherits="QRWebsite.Employees1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Attendees by Event</title>

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="css/style.css">
    <script type="text/javascript">
        //open for attendee
        function openAttendeeLogin() {
            //alert("Opening modal!");
            $('#modLoginAttendee').modal('show');
        }
        function openEmpDetail() {
            //alert("Opening modal!");
            $('#modEmpDetail').modal('show');
        }
        function openEmpQR() {
            //alert("Opening modal!");
            $('#modEmpQR').modal('show');
        }
    </script>

</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
            <%-- Webpage Heading --%>
                <div class="QR-header">
                              <img src="../images/QR_Header2.png" alt="QR Logo" /> 
                </div>
            <%-- Menu / Message / New link --%>
            <div class="navbar-collapse collapse">
                <div class="col-sm-6">
                    <ul class="nav navbar-nav" style="font-weight: bold;">
<%--                         <li>
                            <asp:HyperLink ID="hlHome" NavigateUrl="~/AttendeesQR.aspx" runat="server">Home</asp:HyperLink><br />
                        </li>
                       <li>
                            <asp:HyperLink ID="hlEmployees" NavigateUrl="~/Attendees.aspx" runat="server">Attendees</asp:HyperLink><br />
                        </li>
                        <li>
                            <asp:HyperLink ID="hlCompanies" NavigateUrl="~/Events.aspx" runat="server">Event Information</asp:HyperLink><br />
                        </li>--%>
                    </ul>
                </div>
                <div class="col-sm-2">
                    <asp:Label ID="lblMessage" runat="server" Text="" />
                </div>
                <div class="col-sm-4" style="padding-top: 15px;text-align: right;">
                    <%--<asp:Label ID="Label5" runat="server" Text="[" Font-Size="12px" Visible="true"></asp:Label>--%>
                    <%--<asp:LinkButton ID="lbNewEmp" runat="server" Font-Size="12px" OnClick="lbNewEmp_Click">New</asp:LinkButton>--%>
                    <%--<asp:Label ID="Label6" runat="server" Text="]" Font-Size="12px" Visible="true"></asp:Label>--%>
                    <%--<asp:Button ID="lbNewEmp1" runat="server" class="btn btn-danger button-xs" Font-Size="12px" Text="New Attendee" Visible="true" CausesValidation="false" OnClick="lbNewEmp_Click"/>                    --%>
                </div>
            </div>
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <h1>Attendees by Event</h1>
                </div>
            </div>

            <%-- Gridview --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataKeyNames="ID"
                        CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                        OnRowCommand="gvEmployees_RowCommand"
                        OnRowDataBound="gvEmployees_RowDataBound"
                        EmptyDataText="No data for this request!">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <%# Container.DataItemIndex + 1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" Width="25px" />
                                <ItemStyle HorizontalAlign="Left" Font-Bold="true" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="EmployeeName" HeaderText="Attendee Name">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ContactNo" HeaderText="Contact Number">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Email" HeaderText="Email">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                            <asp:BoundField DataField="CompanyName" HeaderText="Event">
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Left" />
                            </asp:BoundField>
                        <%-- QR IMAGE --%>
                        <asp:TemplateField HeaderText="QR">
                            <ItemTemplate>
                                <asp:LinkButton ID="lbQREmp" runat="server" CommandArgument='<%# Eval("ID") %>'
                                    CommandName="QREmp" Text='<%# Eval("QRCreated") %>' Visible="true" />
                                <asp:Label ID="lblQREmp" runat="server" Visible="false" />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" Width="50px" />
                        </asp:TemplateField>

                            <%-- Delete Employee --%>
<%--                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelEmployee" Text="Del" runat="server"
                                        OnClientClick="return confirm('Are you sure you want to delete this employee?');" CommandName="Delete" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                            </asp:TemplateField>--%>

                            <%-- Update Employee --%>
<%--                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbUpdEmployee" runat="server" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="UpdEmployee" Text="Upd" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                            </asp:TemplateField>--%>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>

        </div>

        <!-- Modal to show Login -->
        <div class="modal fade" id="modLoginAttendee" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">

                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="Label5" runat="server" Text="Attendee Login Page" Font-Size="24px" Font-Bold="true" />
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
                                                <asp:Label ID="Label6" runat="server" Text="Email:" Font-Size="14px" Font-Bold="true" />
                                            </div>
                                            <div class="col-sm-7">
                                                <asp:Label ID="Label10" runat="server" Visible="true" Font-Size="14px" />
                                            <asp:TextBox ID="txtEmail" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Email"
                                                AutoCompleteType="Disabled" placeholder="Email" />
                                            </div>
                                            <div class="col-sm-1">
                                            </div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-3">
                                                <asp:Label ID="Label11" runat="server" Text="Password:" Font-Size="14px" Font-Bold="true" />
                                            </div>
                                            <div class="col-sm-7">
                                                <asp:Label ID="lblPassword" runat="server" Visible="true" Font-Size="14px" />
                                                <%--<asp:TextBox ID="txtPassword" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                    ToolTip="Password"
                                                    AutoCompleteType="Disabled" placeholder="Password" />--%>
                                                <input id="txtPassword" class="test" type="password" runat="server" MaxLength="20" ToolTip="Password" placeholder="   Password" >
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
                                <asp:Label ID="lblAttMessage" runat="server" ForeColor="Red" Font-Size="12px" Text="" />
                            </div>
                            <div class="col-sm-1"></div>
                        </div>
                    </div>

                    <%-- Submit Button --%>
                    <div class="modal-footer">
                        <asp:Button ID="btnSubmitAttendee" runat="server" class="btn btn-danger button-xs"  
                            Text="Submit"                            
                            OnClick="btnSubmitAttendee_Click" 
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


        <!-- Modal to show Employee QR Image -->
        <div class="modal fade" id="modEmpQR" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">

                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="Label1" runat="server" Text="Employee QR Image" Font-Size="24px" Font-Bold="true" />
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-12">

                                <%-- Employee QR --%>
                                <div class="row" style="margin-top: 0px;">
                                    <div class="col-sm-8">
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-3">
                                                <asp:Label ID="Label2" runat="server" Text="Employee:" Font-Size="14px" Font-Bold="true" />
                                            </div>
                                            <div class="col-sm-7">
                                                <asp:Label ID="lblEmployeeName" runat="server"
                                                    ToolTip="Attendee Name"
                                                    AutoCompleteType="Disabled" Font-Size="14px" />
                                                <%--<asp:Label runat="server" ID="Label2" Visible="false" Font-Size="12px" />--%>
                                                <asp:Label runat="server" ID="Label3" Visible="false" Font-Size="1px" />
                                            </div>
                                            <div class="col-sm-1">
                                            </div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-3">
                                                <asp:Label ID="Label7" runat="server" Text="Contact:" Font-Size="14px" Font-Bold="true" />
                                            </div>
                                            <div class="col-sm-7">
                                                <asp:Label ID="lblContactNo" runat="server" Visible="true" Font-Size="14px" />
                                            </div>
                                            <div class="col-sm-1">
                                            </div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-3">
                                                <asp:Label ID="Label8" runat="server" Text="Email:" Font-Size="14px" Font-Bold="true" />
                                            </div>
                                            <div class="col-sm-7">
                                                <asp:Label ID="lblEmail" runat="server" Visible="true" Font-Size="14px" />
                                            </div>
                                            <div class="col-sm-1">
                                            </div>
                                        </div>
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-1"></div>
                                            <div class="col-sm-3">
                                                <asp:Label ID="Label9" runat="server" Text="Event:" Font-Size="14px" Font-Bold="true" />
                                            </div>
                                            <div class="col-sm-7">
                                                <asp:Label ID="lblCompany" runat="server" Visible="true" Font-Size="14px" />
                                            </div>
                                            <div class="col-sm-1">
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-sm-4">
                                        <div class="row" style="margin-top: 20px;">
                                            <div class="col-sm-12">
                                                <asp:Label runat="server" ID="lblQRCreated" Visible="false" Font-Size="12px" />
                                                <asp:Image ID="imgShowQR" runat="server" Width="100%" />
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

                    <%-- Cancel Button --%>
                    <div class="modal-footer">
                        <asp:Button ID="Button3" runat="server" class="btn btn-info button-xs" data-dismiss="modal" Text="Close"
                            CausesValidation="false"
                            UseSubmitBehavior="false" />
                    </div>

                </div>
            </div>
        </div>

    </form>
</body>
</html>

