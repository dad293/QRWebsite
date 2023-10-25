using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZXing;

namespace QRWebsite
{
    public partial class Employees1 : System.Web.UI.Page
    {
        int Emp_ID;
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["QRDBConnection"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                DoGridView();
                int intAttendID = Convert.ToInt32(Request.QueryString["var1"]);
                DisplayAttendee(intAttendID);
            }
        }
        private void DoGridView()
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.usp_GetEmployees_ATT_QR", myCon)) //x
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

                    // *** GET VALUE FROM QR CODE
                    string strCmpID = Request.QueryString["var2"];
                    // make sure to account for SQL Injection


                    myCom.Parameters.Add("@ID", SqlDbType.VarChar).Value = strCmpID;

                    SqlDataReader myDr = myCom.ExecuteReader();

                    gvEmployees.DataSource = myDr;
                    gvEmployees.DataBind();

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Employees doGridView: " + ex.Message; }
            finally { myCon.Close(); }
        }
        protected void lbNewEmp_Click(object sender, EventArgs e)
        {
            try
            {
                txtEmployeeName.Text = "";
                txtContactNo.Text = "";
                txtEmail.Text = "";

                lblEmployeeNew.Visible = true;
                lblEmployeeUpd.Visible = false;
                btnAddEmployee.Visible = true;
                btnUpdEmployee.Visible = false;

                GetCompaniesForDLL();

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openEmpDetail();", true);
            }
            catch (Exception) { throw; }
        }
        protected void btnAddEmployee_Click(object sender, EventArgs e)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.usp_InsEmployee", myCon))
                {
                    myCom.CommandType = CommandType.StoredProcedure;
                    myCom.Parameters.Add("@EmployeeName", SqlDbType.VarChar).Value = txtEmployeeName.Text;
                    myCom.Parameters.Add("@ContactNo", SqlDbType.VarChar).Value = txtContactNo.Text;
                    myCom.Parameters.Add("@Email", SqlDbType.VarChar).Value = txtEmail.Text;
                    myCom.Parameters.Add("@CompID", SqlDbType.VarChar).Value = int.Parse(ddlCompany.SelectedValue);

                    myCom.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in btnAddCompany_Click: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }
        protected void btnUpdEmployee_Click(object sender, EventArgs e)
        {
            UpdEmployee(lblQRCreated.Text);
            DoGridView();
        }
        protected void gvEmployees_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton lbQREmp = (LinkButton)e.Row.FindControl("lbQREmp");
                Label lblQREmp = (Label)e.Row.FindControl("lblQREmp");

                if (((LinkButton)e.Row.FindControl("lbQREmp")).Text == "Yes")
                {
                    lbQREmp.Enabled = true;
                    lbQREmp.Visible = true;
                    lblQREmp.Visible = false;
                    lbQREmp.Text = "Show";
                }
                else
                {
                    lbQREmp.Enabled = false;
                    lbQREmp.Visible = false;
                    lblQREmp.Visible = true;
                    lblQREmp.Text = "";
                }
            }
        }
        protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdEmployee")
            {
                Emp_ID = Convert.ToInt32(e.CommandArgument);

                lblEmpID.Text = Emp_ID.ToString();

                txtEmployeeName.Text = "";
                txtContactNo.Text = "";
                txtEmail.Text = "";
                imgQREmp.ImageUrl = "";
                imgShowQR.ImageUrl = "";

                lblEmployeeNew.Visible = false;
                lblEmployeeUpd.Visible = true;
                btnAddEmployee.Visible = false;
                btnUpdEmployee.Visible = true;

                GetCompaniesForDLL();
                GetEmployee(int.Parse(lblEmpID.Text));
                if (lblQRCreated.Text == "Yes")
                {
                    imgQREmp.Visible = true;
                    lblQRImageMsg.Visible = false;
                    lbCreateQRImg.Visible = false;

                    chkLoadImage(lblEmpID.Text, false);
                }
                else
                {
                    imgQREmp.Visible = false;
                    lblQRImageMsg.Visible = true;
                    lbCreateQRImg.Visible = true;
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openEmpDetail();", true);
            }
            else if (e.CommandName == "QREmp")
            {
                Emp_ID = Convert.ToInt32(e.CommandArgument);

                GetEmployee(Emp_ID);

                if (lblQRCreated.Text == "Yes")
                {
                    chkLoadImage(Emp_ID.ToString(), true);
                }
                else
                {
                    string myEmpDetails = Emp_ID.ToString() + "-"
                        + lblEmployeeName.Text + "-"
                        + lblContactNo.Text + "-"
                        + lblEmail.Text + "-"
                        + lblCompany.Text;
                }

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openEmpQR();", true);
            }
        }
        protected void gvEmployees_RowDeleting(Object sender, GridViewDeleteEventArgs e)
        {
            Emp_ID = Convert.ToInt32(gvEmployees.DataKeys[e.RowIndex].Value.ToString());

            try
            {
                myCon.Open();

                using (SqlCommand cmd = new SqlCommand("dbo.usp_DelEmployee", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = Emp_ID;
                    cmd.ExecuteScalar();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in gvEmployees_RowDeleting: " + ex.Message; }
            finally { myCon.Close(); }
            DoGridView();
        }

        protected void lbCreateQRImg_Click(object sender, EventArgs e)
        {
// change here maybe but more so below                  
            string myEmpDetails = lblEmpID.Text + "_"
                + txtEmployeeName.Text + "_"
                + txtContactNo.Text + "_"
                + txtEmail.Text + "_"
                + ddlCompany.SelectedItem.Text;

            doCreateQRImage(myEmpDetails);
            UpdEmployee("Yes");
            GetEmployee(int.Parse(lblEmpID.Text));
            chkLoadImage(lblEmpID.Text, false);
            DoGridView();

            imgQREmp.Visible = true;
            lblQRImageMsg.Visible = false;
            lbCreateQRImg.Visible = false;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openEmpDetail();", true);
        }

        private void doCreateQRImage(string myEmpDetails)
        {
            string strEmpID = (myEmpDetails.Split('_')[0]).ToString();
            int intCmpID = int.Parse(ddlCompany.SelectedValue);
            var QCwriter = new BarcodeWriter();
            QCwriter.Format = BarcodeFormat.QR_CODE;
            QCwriter.Options = new ZXing.Common.EncodingOptions
            {
                Width = 400,
                Height = 400
            };
            //THIS IS THE DASHBOARD SO WILL NEVER CREATE HERE
            // pass website and strEmpID to open to attendee record (modal)
            //var result = QCwriter.Write(myEmpDetails);
           // myEmpDetails = "https://webappist440appservice.azurewebsites.net/Attendees.aspx?var1=" + strEmpID+ "var2=" + intCmpID;
            var result = QCwriter.Write(myEmpDetails);
            string path = Server.MapPath("~/Images/" + strEmpID + ".jpg");
            var barcodeBitmap = new Bitmap(result);

            using (MemoryStream memory = new MemoryStream())
            {
                using (FileStream fs = new FileStream(path, FileMode.Create, FileAccess.ReadWrite))
                {
                    barcodeBitmap.Save(memory, ImageFormat.Jpeg);
                    byte[] bytes = memory.ToArray();
                    fs.Write(bytes, 0, bytes.Length);
                }
            }
        }
        private void chkLoadImage(string myEmpID, bool showImg)
        {
            try
            {
                if (File.Exists(Server.MapPath("~/Images/" + myEmpID + ".JPG")))
                {
                    if (showImg)
                    {
                        imgShowQR.ImageUrl = "~/Images/" + myEmpID + ".JPG";
                        imgShowQR.AlternateText = "QR Image of Employee";
                    }
                    else
                    {
                        imgQREmp.ImageUrl = "~/Images/" + myEmpID + ".JPG";
                        imgQREmp.AlternateText = "QR Image of Employee";
                    }
                }
            }
            catch (Exception ex)
            {
                WriteErrLog("Employees.aspx.cs: chkLoadImage", ex.Message);
            }
        }
        public void WriteErrLog(string WebSection, string ErrMessage)
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_InsErrlog", myCon))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@WebSection", SqlDbType.Text).Value = WebSection;
                    cmd.Parameters.Add("@ErrMessage", SqlDbType.Text).Value = ErrMessage;

                    cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { WriteErrLog("Employees.aspx.cs - WriteErrLog", "Error: " + ex.Message); }
            finally { myCon.Close(); }
        }
        private void GetEmployee(int emp_ID)
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCmd = new SqlCommand("dbo.usp_GetEmployee", myCon))
                {
                    myCmd.Connection = myCon;
                    myCmd.CommandType = CommandType.StoredProcedure;
                    myCmd.Parameters.Add("@ID", SqlDbType.Int).Value = emp_ID;
                    SqlDataReader myDr = myCmd.ExecuteReader();

                    if (myDr.HasRows)
                    {
                        while (myDr.Read())
                        {
                            txtEmployeeName.Text = myDr.GetValue(1).ToString();
                            txtContactNo.Text = myDr.GetValue(2).ToString();
                            txtEmail.Text = myDr.GetValue(3).ToString();
                            ddlCompany.SelectedValue = myDr.GetValue(4).ToString();
                            lblQRCreated.Text = myDr.GetValue(5).ToString();
                            lblEmpID.Text = lblEmpID.Text;

                            lblEmployeeName.Text = myDr.GetValue(1).ToString();
                            lblContactNo.Text = myDr.GetValue(2).ToString();
                            lblEmail.Text = myDr.GetValue(3).ToString();
                            lblCompany.Text = myDr.GetValue(7).ToString();
                            lblQRCreated.Text = myDr.GetValue(5).ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Companies GetEmployee: " + ex.Message; }
            finally { myCon.Close(); }
        }
        private void UpdEmployee(string QRCreated)
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_UpdEmployee", myCon))
                {
                    cmd.Connection = myCon;
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = int.Parse(lblEmpID.Text);
                    cmd.Parameters.Add("@EmployeeName", SqlDbType.VarChar).Value = txtEmployeeName.Text;
                    cmd.Parameters.Add("@ContactNo", SqlDbType.VarChar).Value = txtContactNo.Text;
                    cmd.Parameters.Add("@Email", SqlDbType.VarChar).Value = txtEmail.Text;
                    cmd.Parameters.Add("@CompID", SqlDbType.VarChar).Value = ddlCompany.SelectedValue;

                    cmd.Parameters.Add("@QRCreated", SqlDbType.VarChar).Value = QRCreated;

                    int rows = cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Employees - UpdEmployee: " + ex.Message; }
            finally { myCon.Close(); }
        }
        private void GetCompaniesForDLL()
        {
            try
            {
                myCon.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_GetCompanies", myCon))
                {
                    SqlDataReader myDr = cmd.ExecuteReader();

                    ddlCompany.DataSource = myDr;
                    ddlCompany.DataTextField = "CompanyName";
                    ddlCompany.DataValueField = "ID";
                    ddlCompany.DataBind();
                    ddlCompany.Items.Insert(0, new ListItem("-- Select Company --", "0"));

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Employees - GetCompaniesForDLL: " + ex.Message; }
            finally { myCon.Close(); }
        }

        private void DisplayAttendee(int strAttID) 
        {
            Emp_ID = strAttID;

            GetEmployee(Emp_ID);

            if (lblQRCreated.Text == "Yes")
            {
                chkLoadImage(Emp_ID.ToString(), true);
            }
            else
            {
                string myEmpDetails = Emp_ID.ToString() + "-"
                    + lblEmployeeName.Text + "-"
                    + lblContactNo.Text + "-"
                    + lblEmail.Text + "-"
                    + lblCompany.Text;
            }

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openEmpQR();", true);
        }
    }
}
