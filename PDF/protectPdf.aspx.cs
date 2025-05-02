using System;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace PDFconvertor.PDF
{
    public partial class protectPdf : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnProtect_Click(object sender, EventArgs e)
        {
            if (!fileUpload.HasFile)
            {
                lblMessage.Text = "❌ Please upload a PDF file.";
                return;
            }

            // Validate file type
            string fileExt = Path.GetExtension(fileUpload.FileName).ToLower();
            if (fileExt != ".pdf")
            {
                lblMessage.Text = "❌ Only PDF files are allowed.";
                return;
            }

            // Check if password is entered
            if (string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                lblMessage.Text = "❌ Please enter a password.";
                return;
            }

            try
            {
                string filePath = Server.MapPath("~/Uploads/") + fileUpload.FileName;
                fileUpload.SaveAs(filePath);

                string outputFilePath = Server.MapPath("~/Uploads/Protected_" + fileUpload.FileName);
                string password = txtPassword.Text.Trim();  // Remove unnecessary spaces

                EncryptPDF(filePath, outputFilePath, password);

                lblMessage.Text = $"✅ PDF protected successfully! <a href='{ResolveUrl("~/Uploads/Protected_" + fileUpload.FileName)}' target='_blank'>Download Here</a>";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "⚠️ Error: " + ex.Message;
            }
        }

        private void EncryptPDF(string inputPdf, string outputPdf, string password)
        {
            using (Stream input = new FileStream(inputPdf, FileMode.Open, FileAccess.Read, FileShare.Read))
            using (Stream output = new FileStream(outputPdf, FileMode.Create, FileAccess.Write, FileShare.None))
            {
                PdfReader reader = new PdfReader(input);
                PdfEncryptor.Encrypt(
                    reader,
                    output,
                    PdfWriter.STRENGTH128BITS,  // 🔄 UPDATED (Replaces ENCRYPTION_AES_128)
                    password,
                    password,
                    PdfWriter.ALLOW_PRINTING
                );
                reader.Close();
            }
        }

    }
}
