using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace QRWebsite
{
    public partial class Default : System.Web.UI.Page
    {
        int RecordCheck;
        SqlConnection myConDef = new SqlConnection(ConfigurationManager.ConnectionStrings["QRDBConnection"].ConnectionString);
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (RecordCheck == 0)
                {   
                    //Make buttons invisible after successful login
                    //lbNewAtt1.Visible = false;
                    //lbNewAdm1.Visible = false;

                    // OPEN NEW LOGIN MODAL
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openAdminLogin();", true);
                }

            }

        }

        //protected void lbAttLogIn_Click(object sender, EventArgs e)
        //{
        //    try
        //    {

        //        // OPEN NEW LOGIN MODAL
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openAttendeeLogin();", true);
        //    }
        //    catch (Exception) { throw; }
        //}

        //protected void lbAdmLogIn_Click(object sender, EventArgs e)
        //{
        //    try
        //    {

        //        // OPEN NEW LOGIN MODAL
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openAdminLogin();", true);
        //    }
        //    catch (Exception) { throw; }
        //}



            protected void btnSubmitAdmin_Click(object sender, EventArgs e)
        {

            CheckAdminCreds(txtEmail.Text, txtPassword.Value);

            if (RecordCheck == 1)
            {
                //clear out values and allow to access
                txtEmail.Text = "";
                txtPassword.Value = "";
                Label4.Text = "";

                ////Make buttons invisible after successful login
                //lbNewAtt1.Visible = false;
                //lbNewAdm1.Visible = false;

            }
            else
            {

                //clear out values
                txtEmail.Text = "";
                txtPassword.Value = "";
                //txtPassword.Text = "";

                //error message - invalid crendentials
                Label4.Text = "Invalid credentials. Please try again. ";

                // SEARCH FOR BUTTON CLICK DON'T CLOSE MODAL
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openAdminLogin();", true);
            }

        }

        private void CheckAdminCreds(string TxtEmail, string TxtPassword)
        {
            try
            {
                myConDef.Open();
                using (SqlCommand cmd = new SqlCommand("dbo.usp_GetUserAdmin", myConDef))
                {
                    cmd.Connection = myConDef;
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add("@EmailAddress", SqlDbType.VarChar).Value = TxtEmail;
                    cmd.Parameters.Add("@Password", SqlDbType.VarChar).Value = TxtPassword;

                    SqlDataReader myDrDef = cmd.ExecuteReader();

                    if (myDrDef.HasRows)
                    {
                        while (myDrDef.Read())
                        {
                            RecordCheck = 1;
                        }

                    }
                }
            }
            catch (Exception ex) { lblMessage.Text = "Error in Login - Admin: " + ex.Message; }
            finally { myConDef.Close(); }
        }

    }
}