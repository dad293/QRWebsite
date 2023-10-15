using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace QRWebsite
{
    public partial class Employees : System.Web.UI.Page
    {
        int Emp_ID;
        SqlConnection myCon = new SqlConnection(ConfigurationManager.ConnectionStrings["QRDBConnection"].ConnectionString);
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DoGridView();
            }
        }
        private void DoGridView()
        {
            try
            {
                myCon.Open();
                using (SqlCommand myCom = new SqlCommand("dbo.usp_GetEmployees", myCon))
                {
                    myCom.Connection = myCon;
                    myCom.CommandType = CommandType.StoredProcedure;

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

        protected void lbNewEmp1_Click(object sender, EventArgs e)
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
            UpdEmployee();
            DoGridView();
        }
        protected void gvEmployees_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "UpdEmployee")
            {
                Emp_ID = Convert.ToInt32(e.CommandArgument);

                txtEmployeeName.Text = "";
                txtContactNo.Text = "";
                txtEmail.Text = "";

                lblEmployeeNew.Visible = false;
                lblEmployeeUpd.Visible = true;
                btnAddEmployee.Visible = false;
                btnUpdEmployee.Visible = true;

                GetCompaniesForDLL();
                GetEmployee(Emp_ID);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openEmpDetail();", true);
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
                            lblEmpID.Text = Emp_ID.ToString();
                        }
                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Companies GetEmployee: " + ex.Message; }
            finally { myCon.Close(); }
        }
        private void UpdEmployee()
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
                    ddlCompany.Items.Insert(0, new ListItem("-- Select Event --", "0"));

                    myDr.Close();
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Employees - GetCompaniesForDLL: " + ex.Message; }
            finally { myCon.Close(); }
        }
    }
}
