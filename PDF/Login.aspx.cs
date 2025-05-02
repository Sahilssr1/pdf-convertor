//using System;
//using MySql.Data.MySqlClient; // Important: SQL Server ka nahi, MySQL ka
//using System.Web.UI;

//namespace PDFconvertor.PDF
//{
//    public partial class Login : System.Web.UI.Page
//    {
//        protected void Page_Load(object sender, EventArgs e)
//        {
//        }

//        protected void btnRegister_Click(object sender, EventArgs e)
//        {
//            string username = Request.Form["txtUsername"];
//            string email = Request.Form["txtEmail"];
//            string password = Request.Form["txtPassword"];

//            string connectionString = "Server=localhost;Port=3306;Database=pdfconverter;Uid=root;Pwd=tiger;";

//            try
//            {
//                using (MySqlConnection con = new MySqlConnection(connectionString))
//                {
//                    // It's better to hash the password (you can use a hashing function like SHA256 or bcrypt)
//                    string hashedPassword = password; // Use a hashing method here

//                    string query = "INSERT INTO Users (Username, Email, Password) VALUES (@Username, @Email, @Password)";
//                    MySqlCommand cmd = new MySqlCommand(query, con);
//                    cmd.Parameters.AddWithValue("@Username", username);
//                    cmd.Parameters.AddWithValue("@Email", email);
//                    cmd.Parameters.AddWithValue("@Password", hashedPassword);

//                    con.Open();
//                    cmd.ExecuteNonQuery();
//                    con.Close();
//                }

//                Response.Write("<script>alert('Registration successful! Please login.');</script>");
//            }
//            catch (Exception ex)
//            {
//                // Handle errors
//                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
//            }
//        }

//        protected void btnLogin_Click(object sender, EventArgs e)
//        {
//            string username = Request.Form["txtUsername"];
//            string password = Request.Form["txtPassword"];

//            string connectionString = "Server=localhost;Port=3306;Database=pdfconverter;Uid=root;Pwd=tiger;";

//            try
//            {
//                using (MySqlConnection con = new MySqlConnection(connectionString))
//                {
//                    // Here also, hash the entered password and compare it with the stored hash
//                    string hashedPassword = password; // Use the same hashing method used during registration

//                    string query = "SELECT COUNT(*) FROM Users WHERE Username=@Username AND Password=@Password";
//                    MySqlCommand cmd = new MySqlCommand(query, con);
//                    cmd.Parameters.AddWithValue("@Username", username);
//                    cmd.Parameters.AddWithValue("@Password", hashedPassword);

//                    con.Open();
//                    int count = Convert.ToInt32(cmd.ExecuteScalar());
//                    con.Close();

//                    if (count == 1)
//                    {
//                        Session["Username"] = username;
//                        Response.Redirect("Home.aspx");
//                    }
//                    else
//                    {
//                        Response.Write("<script>alert('Invalid Username or Password');</script>");
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                // Handle errors
//                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
//            }
//        }
//    }
//}
