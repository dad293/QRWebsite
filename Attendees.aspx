<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Attendees.aspx.cs" Inherits="QRWebsite.Employees" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Attendees</title>

    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="css/style.css">
    <script type="text/javascript">
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
                <div class="col-sm-2">
                    <asp:Label ID="lblMessage" runat="server" Text="" />
                </div>
                <div class="col-sm-4" style="padding-top: 15px;text-align: right;">
                    <%--<asp:Label ID="Label5" runat="server" Text="[" Font-Size="12px" Visible="true"></asp:Label>--%>
                    <%--<asp:LinkButton ID="lbNewEmp" runat="server" Font-Size="12px" OnClick="lbNewEmp_Click">New</asp:LinkButton>--%>
                    <%--<asp:Label ID="Label6" runat="server" Text="]" Font-Size="12px" Visible="true"></asp:Label>--%>
                    <asp:Button ID="lbNewEmp1" runat="server" class="btn btn-danger button-xs" Font-Size="12px" Text="New Attendee" Visible="true" CausesValidation="false" OnClick="lbNewEmp_Click"/>                    
                </div>
            </div>
        <div class="container">
            <div class="row">
                <div class="col-xs-12">
                    <h1>Attendees</h1>
                </div>
            </div>

            <%-- Gridview --%>
            <div class="row" style="margin-top: 20px;">
                <div class="col-sm-12">
                    <asp:GridView ID="gvEmployees" runat="server" AutoGenerateColumns="False" AllowSorting="True"
                        DataKeyNames="ID"
                        CssClass="table table-striped table-bordered table-condensed" BorderColor="Silver"
                        OnRowDeleting="gvEmployees_RowDeleting"
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
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbDelEmployee" Text="Del" runat="server"
                                        OnClientClick="return confirm('Are you sure you want to delete this employee?');" CommandName="Delete" />
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Left" />
                                <ItemStyle HorizontalAlign="Center" Width="50px" />
                            </asp:TemplateField>

                            <%-- Update Employee --%>
                            <asp:TemplateField HeaderText="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbUpdEmployee" runat="server" CommandArgument='<%# Eval("ID") %>'
                                        CommandName="UpdEmployee" Text="Upd" CausesValidation="false"></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="80px" />
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>

        </div>

        <!-- Modal to Add New or View / Update a Company Details-->
        <div class="modal fade" id="modEmpDetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">

                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="lblEmployeeNew" runat="server" Text="Add New Attendees" Font-Size="24px" Font-Bold="true" />
                        <asp:Label ID="lblEmployeeUpd" runat="server" Text="View / Update an Attendees" Font-Size="24px" Font-Bold="true" />
                    </div>

                    <div class="modal-body">
                        <div class="row">
                            <div class="col-sm-12">

                                <%-- Employee Details Textboxes --%>
                                <div class="col-sm-12">
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtEmployeeName" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Attendee Name"
                                                AutoCompleteType="Disabled" placeholder="Attendee Name" />
                                            <asp:Label runat="server" ID="lblEmpID" Visible="false" Font-Size="12px" />
                                            <asp:Label runat="server" ID="lblQRCreated" Visible="false" Font-Size="12px" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtContactNo" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Contact Number"
                                                AutoCompleteType="Disabled" placeholder="Contact Number" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:TextBox ID="txtEmail" runat="server" MaxLength="255" CssClass="form-control input-xs" 
                                                ToolTip="Email"
                                                AutoCompleteType="Disabled" placeholder="Email" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:DropDownList ID="ddlCompany" runat="server" CssClass="form-control input-xs" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
<%--                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:Image ID="QR_Code" runat="server" ImageUrl="../images/QR_code_test.PNG" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>--%>
                                </div>
                                <%-- QR Image --%>
                                <div class="col-sm-6">
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:Image ID="imgQREmp" runat="server" Width="200px" Visible="false" />
                                            <asp:Label runat="server" ID="lblQRImageMsg" Visible="false" Font-Size="12px" Text="No QR Image available" Font-Bold="true" />
                                        </div>
                                        <div class="col-sm-1"></div>
                                    </div>
                                    <div class="row" style="margin-top: 20px;">
                                        <div class="col-sm-1"></div>
                                        <div class="col-sm-10">
                                            <asp:LinkButton runat="server" ID="lbCreateQRImg" Visible="false" Font-Size="12px" Text="Create Image" Font-Bold="true" OnClick="lbCreateQRImg_Click" />
                                        </div>
                                        <div class="col-sm-1">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- Message label on modal page --%>
                        <div class="row" style="margin-top: 20px; margin-bottom: 10px;">
                            <div class="col-sm-1"></div>
                            <div class="col-sm-10">
                                <asp:Label ID="lblModalMessage" runat="server" ForeColor="Red" Font-Size="12px" Text="" />
                            </div>
                            <div class="col-sm-1"></div>
                        </div>
                    </div>

                    <%-- Add, Update and Cancel Buttons --%>
                    <div class="modal-footer">
                        <asp:Button ID="btnAddEmployee" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Add Attendee"
                            Visible="true" CausesValidation="false"
                            OnClick="btnAddEmployee_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnUpdEmployee" runat="server" class="btn btn-danger button-xs" data-dismiss="modal" 
                            Text="Update Attendee"
                            Visible="false" CausesValidation="false"
                            OnClick="btnUpdEmployee_Click"
                            UseSubmitBehavior="false" />
                        <asp:Button ID="btnClose" runat="server" class="btn btn-info button-xs" data-dismiss="modal" Text="Close" 
                            CausesValidation="false"
                            UseSubmitBehavior="false" />
                    </div>

                </div>
            </div>
        </div>

        <!-- Modal to show Employee QR Image -->
        <div class="modal fade" id="modEmpQR" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg" style="width: 600px;">
                <div class="modal-content" style="font-size: 11px;">

                    <div class="modal-header" style="text-align: center;">
                        <asp:Label ID="Label1" runat="server" Text="Attendee QR Image" Font-Size="24px" Font-Bold="true" />
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
                                                <asp:Label ID="Label2" runat="server" Text="Attendee:" Font-Size="14px" Font-Bold="true" />
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

